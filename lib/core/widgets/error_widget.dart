import 'package:flutter/material.dart';
import '../errors/failures.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;
  
  const ErrorDisplayWidget({
    super.key,
    required this.failure,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorMessage(),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorDetails(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  IconData _getErrorIcon() {
    if (failure is NetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is ServerFailure) {
      return Icons.error_outline;
    } else if (failure is AuthenticationFailure) {
      return Icons.lock_outline;
    }
    return Icons.error_outline;
  }
  
  String _getErrorMessage() {
    if (failure is NetworkFailure) {
      return 'Network Error';
    } else if (failure is ServerFailure) {
      return 'Server Error';
    } else if (failure is AuthenticationFailure) {
      return 'Authentication Error';
    }
    return 'An Error Occurred';
  }
  
  String _getErrorDetails() {
    return failure.message;
  }
}
