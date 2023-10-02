import 'package:flutter/material.dart';

class InitiativeEditButton extends StatelessWidget {
  const InitiativeEditButton({
    super.key,
    required this.onTap,
    required this.answerText,
    required this.color,
  });

  final String answerText;
  final void Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        // backgroundColor: const Color.fromARGB(255, 33, 1, 95),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        answerText,
        textAlign: TextAlign.center,
      ),
    );
  }
}
