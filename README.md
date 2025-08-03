Yoga Session App 🧘‍♂️

A Flutter-based guided yoga session app that plays synchronized audio and pose images based on a JSON sequence.
Supports an intro, multiple looped breathing cycles, and an outro — all dynamically loaded with no code changes required.

Features
	•	📄 JSON-driven session flow – easily add new poses, images, and audio
	•	🎵 Audio & image sync – smooth transitions in sync with instructions
	•	⏯ Pause, resume, and restart steps
	•	📊 Progress bar with timer for each step
	•	🎯 Loop handling with round tracking

Tech Stack
	•	Flutter
	•	Riverpod (state management)
	•	just_audio (audio playback)

⸻
App Flow (Data Flow Diagram)
flowchart TD
    A[JSON File: poses.json] --> B[JsonService]
    B --> C[SessionModel & related data models]
    C --> D[SessionController (Riverpod StateNotifier)]
    D --> E[PreviewScreen: loads and displays session info]
    D --> F[SessionScreen: handles active session]
    F --> G[AudioPlayer (just_audio)]
    F --> H[UI Updates: Image, Text, Progress Bar]

⸻

Note: This is a Proof of Concept assignment for internship evaluation at RevoltronX, focused on demonstrating modular design, clean architecture, and an engaging session experience.
