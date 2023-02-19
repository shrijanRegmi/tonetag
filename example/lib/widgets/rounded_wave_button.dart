import 'package:flutter/material.dart';
import 'package:tonetag_example/extensions/widget_extension.dart';

class RoundedWaveButton extends StatefulWidget {
  final double size;
  final String text;
  final bool animate;
  final Color bgColor;
  final Function(bool)? onPressed;

  const RoundedWaveButton({
    super.key,
    required this.animate,
    this.size = 200.0,
    this.text = '',
    this.bgColor = Colors.blue,
    this.onPressed,
  });

  @override
  State<RoundedWaveButton> createState() => _RoundedWaveButtonState();
}

class _RoundedWaveButtonState extends State<RoundedWaveButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(
      begin: widget.size,
      end: widget.size + widget.size / 2,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    if (widget.animate) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant RoundedWaveButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animate != widget.animate) {
      if (widget.animate) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    }
  }

  void _stopAnimation() {
    if (_animationController.isAnimating) {
      _animationController.reset();
    }
  }

  // ignore: unused_element
  void _toggleAnimation() {
    if (_animationController.isAnimating) {
      _animationController.reset();
    } else {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return _circularContainer(
                  size: _animation.value,
                  color: Colors.grey.shade200,
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: _circularContainer(
              size: widget.size,
              text: widget.text,
              color: widget.bgColor,
            ).onPressed(() {
              widget.onPressed?.call(
                _animationController.isAnimating,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _circularContainer({
    final Color color = Colors.blue,
    final double size = 200.0,
    final String text = "",
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
