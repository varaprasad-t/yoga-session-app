import 'package:flutter/material.dart';

class PoseDisplay extends StatelessWidget {
  final String poseName;
  final String imagePath;

  const PoseDisplay({Key? key, required this.poseName, required this.imagePath})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          poseName,
          //style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 8),
        Image.asset(imagePath),
      ],
    );
  }
}
