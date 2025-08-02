import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_model.dart';

final sessionProvider = StateNotifierProvider<SessionController, SessionState>((
  ref,
) {
  return SessionController();
});

class SessionState {
  final SessionModel? sessionData;
  final int currentSegmentIndex;
  final int currentScriptIndex;
  final int completedLoops;

  SessionState({
    this.sessionData,
    this.currentSegmentIndex = 0,
    this.currentScriptIndex = 0,
    this.completedLoops = 0,
  });

  SessionState copyWith({
    SessionModel? sessionData,
    int? currentSegmentIndex,
    int? currentScriptIndex,
    int? completedLoops,
  }) {
    return SessionState(
      sessionData: sessionData ?? this.sessionData,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      currentScriptIndex: currentScriptIndex ?? this.currentScriptIndex,
      completedLoops: completedLoops ?? this.completedLoops,
    );
  }
}

class SessionController extends StateNotifier<SessionState> {
  SessionController() : super(SessionState());

  void setSessionData(SessionModel data) {
    state = state.copyWith(sessionData: data);
  }

  void nextScriptStep() {
    final currentSegment =
        state.sessionData!.sequence[state.currentSegmentIndex];
    if (state.currentScriptIndex < currentSegment.script.length - 1) {
      state = state.copyWith(currentScriptIndex: state.currentScriptIndex + 1);
    } else {
      nextSegment();
    }
  }

  void nextSegment() {
    final session = state.sessionData;
    if (session == null) return;

    final currentSegment = session.sequence[state.currentSegmentIndex];

    if (currentSegment.type == "loop") {
      final targetLoops = session.defaultLoopCount;
      final newCompletedLoops = state.completedLoops + 1;

      if (newCompletedLoops < targetLoops) {
        // Stay on same loop
        state = state.copyWith(
          currentScriptIndex: 0,
          completedLoops: newCompletedLoops,
        );
        return;
      } else {
        // Loop finished, reset loop count and go to outro
        state = state.copyWith(
          completedLoops: 0,
          currentSegmentIndex: state.currentSegmentIndex + 1,
          currentScriptIndex: 0,
        );
        return;
      }
    }

    // If not a loop, move to next normally
    if (state.currentSegmentIndex < session.sequence.length - 1) {
      state = state.copyWith(
        currentSegmentIndex: state.currentSegmentIndex + 1,
        currentScriptIndex: 0,
      );
    }
  }

  void incrementLoop() {
    state = state.copyWith(completedLoops: state.completedLoops + 1);
  }

  void reset() {
    state = SessionState(
      sessionData: state.sessionData,
      currentSegmentIndex: 0,
      currentScriptIndex: 0,
      completedLoops: 0,
    );
  }
}
