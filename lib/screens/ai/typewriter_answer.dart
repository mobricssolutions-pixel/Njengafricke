import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

class TypewriterAnswer extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration speed;
  final VoidCallback? onFinished;

  const TypewriterAnswer({
    super.key,
    required this.text,
    required this.style,
    this.speed = const Duration(milliseconds: 18),
    this.onFinished,
  });

  @override
  State<TypewriterAnswer> createState() =>
      _TypewriterAnswerState();
}

class _TypewriterAnswerState
    extends State<TypewriterAnswer> {

  String displayed = "";

  int index = 0;

  Timer? timer;

  bool cursorVisible = true;

  Timer? cursorTimer;

  @override
  void initState() {
    super.initState();

    cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        if (!mounted) return;

        setState(() {
          cursorVisible = !cursorVisible;
        });
      },
    );

    _startTyping();
  }

  void _startTyping() {
  _typeNextCharacter();
}

void _typeNextCharacter() {

  if (index >= widget.text.length) {

    widget.onFinished?.call();

    return;
  }

  setState(() {

    displayed += widget.text[index];
    if (index % 3 == 0) {
        HapticFeedback.selectionClick();
    }

    index++;

  });

WidgetsBinding.instance.addPostFrameCallback((_) {

  if (!mounted) return;

  Scrollable.ensureVisible(
    context,
    duration:
        const Duration(milliseconds: 120),
    alignment: 1.0,
  );

});

  Duration delay = widget.speed;

  final char = displayed.characters.last;

  if (char == "." ||
      char == "!" ||
      char == "?") {

    delay = const Duration(milliseconds: 350);

  } else if (char == "," ||
             char == ";") {

    delay = const Duration(milliseconds: 180);

  }

  timer = Timer(
    delay,
    _typeNextCharacter,
  );
}

  void finishImmediately() {

    timer?.cancel();

    setState(() {

      displayed = widget.text;

    });

    cursorTimer?.cancel();

    setState(() {
    cursorVisible = false;
    });

    widget.onFinished?.call();
  }

  @override
  void dispose() {

    timer?.cancel();

    cursorTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: finishImmediately,

      child: RichText(

        text: TextSpan(

          style: widget.style,

          children: [

            TextSpan(
              text: displayed,
            ),

            if (cursorVisible)

              const TextSpan(
                text: "▌",
              ),
          ],
        ),
      ),
    );
  }
}