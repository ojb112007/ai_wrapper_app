import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TypingTextWidget extends StatefulWidget {
  final String text;
  final String? modelInfo;
  final Duration typingSpeed;
  final bool hasAnimatd;
  final VoidCallback onAnimationComplete;

  const TypingTextWidget({
    Key? key,
    required this.text,
    required this.hasAnimatd,
    required this.onAnimationComplete,
    this.modelInfo,
    this.typingSpeed = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  _TypingTextWidgetState createState() => _TypingTextWidgetState();
}

class _TypingTextWidgetState extends State<TypingTextWidget> {
  String _displayText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.hasAnimatd) {
      _displayText = widget.text;
    } else {
      _startTypingAnimation();
    }
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayText += widget.text[_currentIndex];
          _currentIndex++;
          //  _displayText = widget.text.substring(0, _currentIndex + 1);
          //  _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _displayText,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        if (widget.modelInfo != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              widget.modelInfo!,
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey[400],
              ),
            ),
          ),
      ],
    );
    // return AnimatedTextKit(
    //   key: GlobalKey(),
    //   animatedTexts: [
    //     TyperAnimatedText(
    //       _displayText,
    //       textStyle: TextStyle(fontSize: 20.0),
    //       speed: Duration(milliseconds: 15),
    //     )
    //   ],
    //   isRepeatingAnimation: false,
    // );
  }
}
