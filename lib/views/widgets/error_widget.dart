import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const ErrorWidgetCustom({Key? key, this.message, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          Text(message ?? 'Something went wrong', style: const TextStyle(color: Colors.red)),
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
        ],
      ),
    );
  }
} 