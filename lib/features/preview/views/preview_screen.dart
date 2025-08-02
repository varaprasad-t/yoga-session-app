import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/json_service.dart';
import '../../session/controllers/session_controller.dart';
import '../../session/views/session_screen.dart';
import '../../session/models/session_model.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  SessionModel? _sessionData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final data = await JsonService().loadSessionData();
      setState(() {
        _sessionData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading session: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startSession() {
    if (_sessionData != null) {
      ref.read(sessionProvider.notifier).setSessionData(_sessionData!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SessionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_sessionData == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load session data")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.self_improvement, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              _sessionData!.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _sessionData!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _sessionData!.category,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Divider(height: 30, thickness: 0.8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _sessionData!.assets.images.length,
              itemBuilder: (context, index) {
                final imageFile = _sessionData!.assets.images.values.elementAt(
                  index,
                );
                final imageName = _sessionData!.assets.images.keys.elementAt(
                  index,
                );
                return Card(
                  elevation: 1,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/$imageFile',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          imageName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _startSession,
                icon: const Icon(Icons.play_arrow, size: 26),
                label: const Text(
                  "Start Session",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xfff9f9f9),
    );
  }
}
