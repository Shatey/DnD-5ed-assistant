import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class InitiativeClearButton extends StatefulWidget {
  const InitiativeClearButton({super.key, required this.clear});

  final VoidCallback clear;

  @override
  State<InitiativeClearButton> createState() => _InitiativeClearButtonState();
}

class _InitiativeClearButtonState extends State<InitiativeClearButton> {
  bool _isHolding = false;
  // final _longPressDuration =
  //     Duration(seconds: 1); // Adjust the duration as needed
  final _gestureRecognizer = LongPressGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _gestureRecognizer.onLongPress = _handleHold;
    _gestureRecognizer.onLongPressEnd = _handleHoldEnd;
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  void _handleHold() {
    if (!_isHolding) {
      setState(() {
        _isHolding = true;
      });
      widget.clear(); // Call the provided function
    }
  }

  void _handleHoldEnd(LongPressEndDetails details) {
    setState(() {
      _isHolding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _handleHold,
      onLongPressEnd: _handleHoldEnd,
      child: Container(
        // Customize the button's appearance as needed
        width: 100,
        color: _isHolding ? Colors.green : Colors.red,
        child: Center(
          child: Text(
            _isHolding ? 'Очищено' : 'Очистить',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
