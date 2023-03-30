import 'package:flutter/material.dart';
import 'package:gigX/constant/constants.dart';

enum ToastVariant { success, error, warning, info }

class KToast extends StatelessWidget {
  final ToastVariant variant;
  final String message;

  const KToast({
    required this.variant,
    required this.message,
    Key? key,
  }) : super(key: key);

  Color getColor(ToastVariant variant) {
    switch (variant) {
      case ToastVariant.success:
        return Colors.green;
      case ToastVariant.error:
        return Colors.red;
      case ToastVariant.warning:
        return Colors.orange;
      case ToastVariant.info:
        return Colors.blueAccent;
    }
  }

  IconData getIcon(ToastVariant variant) {
    switch (variant) {
      case ToastVariant.success:
        return Icons.check_circle;

      case ToastVariant.error:
        return Icons.cancel;

      case ToastVariant.warning:
        return Icons.warning;

      case ToastVariant.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: getColor(variant),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 2,
            color: getColor(variant).withOpacity(0.25),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(getIcon(variant), color: Colors.white),
          minWidthSpan(),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Quicksand',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
