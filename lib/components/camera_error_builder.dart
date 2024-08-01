import 'package:flutter/material.dart';

class CameraErrorBuilder extends StatelessWidget {
  const CameraErrorBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography_rounded,
                size: 68,
              ),
              const SizedBox(height: 12),
              Text(
                "Could not start the camera",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}
