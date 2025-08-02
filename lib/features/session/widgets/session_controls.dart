import 'package:flutter/material.dart';

class SessionControls extends StatelessWidget {
  const SessionControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            // Pause the session
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            // Stop the session
          },
        ),
      ],
    );
  }
}
