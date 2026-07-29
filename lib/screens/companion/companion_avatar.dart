import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/colour_mood.dart';
import '../../providers/companion_provider.dart';
import '../../theme/colours.dart';

class CompanionAvatar extends StatefulWidget {
  final CompanionAvatarState state;
  final ColourMood mood;
  final String name;
  final double size;

  const CompanionAvatar({
    super.key,
    required this.state,
    required this.mood,
    required this.name,
    this.size = 120,
  });

  @override
  State<CompanionAvatar> createState() => _CompanionAvatarState();
}

class _CompanionAvatarState extends State<CompanionAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CompanionAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == CompanionAvatarState.minimised ||
        widget.mood == ColourMood.red ||
        widget.mood == ColourMood.black) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  Color get _fill {
    switch (widget.mood) {
      case ColourMood.green:
        return const Color(0xFF81C784);
      case ColourMood.yellow:
        return const Color(0xFFFFD54F);
      case ColourMood.orange:
        return const Color(0xFFFFB74D);
      case ColourMood.red:
        return const Color(0xFFEF9A9A);
      case ColourMood.purple:
        return const Color(0xFFB39DDB);
      case ColourMood.black:
        return const Color(0xFF78909C);
      case ColourMood.brown:
        return const Color(0xFFA1887F);
      case ColourMood.sparkle:
        return BethColours.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == CompanionAvatarState.minimised ||
        widget.mood == ColourMood.sparkle) {
      return Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _fill.withOpacity(0.35),
              border: Border.all(color: _fill),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'I\'m here if you need me',
            style: TextStyle(color: BethColours.textMuted, fontSize: 12),
          ),
        ],
      );
    }

    final quiet = widget.mood == ColourMood.red || widget.mood == ColourMood.black;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final breathe = quiet ? 0.0 : math.sin(_controller.value * math.pi) * 4;
        final lean = widget.state == CompanionAvatarState.listening ? 6.0 : 0.0;
        return Transform.translate(
          offset: Offset(0, -breathe + (widget.state == CompanionAvatarState.thinking ? 2 : 0)),
          child: Transform.translate(
            offset: Offset(lean, 0),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _fill.withOpacity(0.95),
                    _fill.withOpacity(0.55),
                    BethColours.primaryDark.withOpacity(0.35),
                  ],
                  stops: const [0.2, 0.7, 1],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _fill.withOpacity(0.35),
                    blurRadius: widget.state == CompanionAvatarState.speaking ? 18 : 10,
                    spreadRadius: widget.state == CompanionAvatarState.speaking ? 2 : 0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.name.isNotEmpty ? widget.name[0] : 'V',
                  style: TextStyle(
                    fontSize: widget.size * 0.38,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(quiet ? 0.7 : 1),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
