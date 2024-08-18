import 'package:flutter/widgets.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    required this.child,
    required this.durationInMs,
    required this.delayInMs,
    required this.position,
    super.key,
  });

  final Widget child;
  final int durationInMs;
  final int delayInMs;
  final MyAnimation position;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation> {
  bool? animate;
  @override
  void initState() {
    super.initState();
    changeAnimation();
  }

  Future<void> changeAnimation() async {
    animate = false;
    await Future<void>.delayed(Duration(milliseconds: widget.delayInMs));
    if (mounted) {
      setState(() {
        animate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: widget.durationInMs),
      curve: Curves.easeInOut,
      top: animate! ? widget.position.topAfter : widget.position.topBefore,
      left: animate! ? widget.position.leftAfter : widget.position.leftBefore,
      bottom:
          animate! ? widget.position.bottomAfer : widget.position.bottomBefore,
      right:
          animate! ? widget.position.rightAfter : widget.position.rightBefore,
      child: widget.child,
    );
  }
}

class MyAnimation {
  const MyAnimation({
    this.topAfter,
    this.leftAfter,
    this.bottomAfer,
    this.rightAfter,
    this.topBefore,
    this.leftBefore,
    this.bottomBefore,
    this.rightBefore,
  });

  final double? topAfter;
  final double? leftAfter;
  final double? bottomAfer;
  final double? rightAfter;
  final double? topBefore;
  final double? leftBefore;
  final double? bottomBefore;
  final double? rightBefore;
}
