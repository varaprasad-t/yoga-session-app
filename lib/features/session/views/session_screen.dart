import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoga_session_app/features/preview/views/preview_screen.dart';
import '../controllers/session_controller.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _stepTimer;
  Timer? _pauseWarningTimer;
  int _stepDuration = 1;
  num _elapsedSeconds = 0;
  bool _isPaused = false;

  late AnimationController _imageAnimController;
  late Animation<double> _imageScale;

  @override
  void initState() {
    super.initState();

    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _imageScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _imageAnimController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCurrentSegment();
    });
  }

  void _startCurrentSegment() async {
    _stepTimer?.cancel();
    setState(() => _elapsedSeconds = 0);

    final sessionState = ref.read(sessionProvider);
    final sessionData = sessionState.sessionData;
    if (sessionData == null) return;

    final currentSegment =
        sessionData.sequence[sessionState.currentSegmentIndex];

    final audioFile = sessionData.assets.audio[currentSegment.audioRef] ?? '';
    if (audioFile.isNotEmpty) {
      await _audioPlayer.stop();
      await _audioPlayer.setAsset('assets/audio/$audioFile');
      _audioPlayer.play();
    }

    _startStepTimer();
  }

  void _startStepTimer() {
    _stepTimer?.cancel();
    setState(() => _elapsedSeconds = 0);
    _imageAnimController.forward(from: 0);

    final sessionState = ref.read(sessionProvider);
    final currentSegment =
        sessionState.sessionData!.sequence[sessionState.currentSegmentIndex];
    final currentStep = currentSegment.script[sessionState.currentScriptIndex];

    final rawDuration = currentStep.endSec - currentStep.startSec;
    _stepDuration = (rawDuration > 0) ? rawDuration : 1;

    _stepTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedSeconds = (_elapsedSeconds + 0.05).clamp(0, _stepDuration);
        });

        if (_elapsedSeconds >= _stepDuration) {
          _onStepComplete();
        }
      }
    });
  }

  void _onStepComplete() {
    final notifier = ref.read(sessionProvider.notifier);
    final state = ref.read(sessionProvider);
    final currentSegment =
        state.sessionData!.sequence[state.currentSegmentIndex];

    setState(() => _elapsedSeconds = 0);

    if (state.currentScriptIndex < currentSegment.script.length - 1) {
      notifier.nextScriptStep();
      _startStepTimer();
    } else {
      notifier.nextSegment();
      if (state.currentSegmentIndex >= state.sessionData!.sequence.length - 1) {
        _audioPlayer.stop();
        _stepTimer?.cancel();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => const _SessionCompleteScreen(),
          ),
        );
      } else {
        _startCurrentSegment();
      }
    }
  }

  void _restartCurrentStep() {
    final sessionState = ref.read(sessionProvider);
    final currentSegment =
        sessionState.sessionData!.sequence[sessionState.currentSegmentIndex];
    final currentStep = currentSegment.script[sessionState.currentScriptIndex];

    final audioFile =
        sessionState.sessionData!.assets.audio[currentSegment.audioRef] ?? '';
    if (audioFile.isNotEmpty) {
      _audioPlayer.seek(Duration(seconds: currentStep.startSec));
    }
    setState(() => _elapsedSeconds = 0);
    _imageAnimController.forward(from: 0);
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("End Session?"),
        content: const Text("Are you sure you want to end the session early?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              _audioPlayer.stop();
              _stepTimer?.cancel();
              ref.read(sessionProvider.notifier).reset();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("End"),
          ),
        ],
      ),
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _audioPlayer.pause();
      _pauseWarningTimer?.cancel();
      _pauseWarningTimer = Timer(const Duration(seconds: 20), () {
        if (_isPaused) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Take your time, but try to resume soon 🧘"),
            ),
          );
        }
      });
    } else {
      _audioPlayer.play();
      _pauseWarningTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _stepTimer?.cancel();
    _pauseWarningTimer?.cancel();
    _imageAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final sessionData = sessionState.sessionData;

    if (sessionData == null) {
      return const Scaffold(
        body: Center(child: Text("No session data available")),
      );
    }

    final currentSegment =
        sessionData.sequence[sessionState.currentSegmentIndex];
    final currentStep = currentSegment.script[sessionState.currentScriptIndex];

    final totalRounds = sessionData.defaultLoopCount + 2;
    int currentRound;
    if (sessionState.currentSegmentIndex == 0) {
      currentRound = 1;
    } else if (sessionState.currentSegmentIndex ==
        sessionData.sequence.length - 1) {
      currentRound = totalRounds;
    } else {
      currentRound = 1 + sessionState.completedLoops + 1;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ScaleTransition(
                scale: _imageScale,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/${sessionData.assets.images[currentStep.imageRef] ?? ''}',
                      key: ValueKey(currentStep.imageRef),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Round text
          Text(
            "Round $currentRound of $totalRounds",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          // Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _elapsedSeconds / _stepDuration,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Colors.teal),
                  ),
                ),
                Text(
                  "${(_stepDuration - _elapsedSeconds).ceil()}s",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Instructions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                currentStep.text,
                key: ValueKey(currentStep.text),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? "Resume" : "Pause"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _restartCurrentStep,
                  icon: const Icon(Icons.replay),
                  label: const Text("Restart"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _showEndDialog,
                  icon: const Icon(Icons.stop),
                  label: const Text("End"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCompleteScreen extends StatelessWidget {
  const _SessionCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.teal),
        automaticallyImplyLeading: false, // removed back arrow
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.teal, size: 80),
            const SizedBox(height: 16),
            const Text(
              "Well done!\nSession Complete",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PreviewScreen()),
                );
              },
              child: const Text(
                "Go Back",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
