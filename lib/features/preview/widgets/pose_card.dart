import 'package:flutter/material.dart';
import 'package:yoga_session_app/features/session/models/session_model.dart';

class PoseCard extends StatelessWidget {
  final SessionModel session;

  PoseCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(session.title),
          Text(session.category),
          // Add more session details here
        ],
      ),
    );
  }
}
