import 'dart:math';
import 'package:flutter/material.dart';

/// Slides the new page up slightly while fading in.
class SlideUpFadePageRoute<T> extends PageRouteBuilder<T> {
  SlideUpFadePageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.2), // Start slightly below
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
      );
  final Widget page;
}

/// Slides the new page down slightly while fading in.
class SlideDownFadePageRoute<T> extends PageRouteBuilder<T> {
  SlideDownFadePageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
      );
  final Widget page;
}

/// Creates a depth effect by sliding the new page faster than the old page.
class ParallaxSlidePageRoute<T> extends PageRouteBuilder<T> {
  ParallaxSlidePageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          );
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          final secondaryTween = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.33, 0),
          ); // Slower slide
          final secondaryCurvedAnimation = CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInCubic,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation), // Incoming
            child: SlideTransition(
              position: secondaryTween.animate(
                secondaryCurvedAnimation,
              ), // Outgoing
              child: child, // Represents the outgoing screen in builder
            ),
          );
        },
      );
  final Widget page;
}

/// Reveals the new page using a grid of blocks appearing sequentially.
class BlockRevealPageRoute<T> extends PageRouteBuilder<T> {
  BlockRevealPageRoute({
    required this.page,
    required this.targetBlockSize, // Approx. size for square-like blocks
  }) : super(
         transitionDuration: const Duration(milliseconds: 1000),
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final size = MediaQuery.sizeOf(context);
           final columns = (size.width / targetBlockSize).ceil();
           final rows = (size.height / targetBlockSize).ceil();

           return Stack(
             children: [
               CustomPaint(
                 // Draws borders underneath
                 painter: _BlockBorderPainter(
                   animation: animation,
                   columns: columns,
                   rows: rows,
                   context: context,
                 ),
                 child: Container(),
               ),
               ClipPath(
                 // Clips the incoming content
                 clipper: _BlockRevealClipper(
                   animation: animation,
                   columns: columns,
                   rows: rows,
                 ),
                 child: FadeTransition(
                   // Fade in content during reveal
                   opacity: Tween<double>(begin: 0.5, end: 1).animate(
                     CurvedAnimation(
                       parent: animation,
                       curve: const Interval(0.5, 1, curve: Curves.easeOut),
                     ),
                   ),
                   child: child, // Represents the incoming screen here
                 ),
               ),
             ],
           );
         },
       );
  final Widget page;
  final double targetBlockSize;
}

/// Painter for drawing the borders of the revealing blocks in BlockRevealPageRoute.
class _BlockBorderPainter extends CustomPainter {
  _BlockBorderPainter({
    required this.animation,
    required this.columns,
    required this.rows,
    required this.context,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int columns;
  final int rows;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final borderColor = Colors.black;
    final paint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    final blockWidth = size.width / columns;
    final blockHeight = size.height / rows;
    final totalBlocks = columns * rows;
    final progress = Curves.easeInOutSine.transform(animation.value);
    final blocksToShow =
        (progress * (totalBlocks + columns))
            .toInt(); // Add columns for smoother end

    for (var i = 0; i < blocksToShow; i++) {
      // Calculate row and column based on diagonal reveal pattern
      var currentSum = 0;
      var r = 0;
      var c = 0;
      while (currentSum < i) {
        c++;
        if (c >= columns) {
          r++;
          c = 0;
        }
        currentSum++;
      }

      if (r < rows) {
        final rect = Rect.fromLTWH(
          c * blockWidth,
          r * blockHeight,
          blockWidth,
          blockHeight,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BlockBorderPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.context != context ||
        oldDelegate.columns != columns ||
        oldDelegate.rows != rows;
  }
}

/// Clipper for revealing content in blocks for BlockRevealPageRoute.
class _BlockRevealClipper extends CustomClipper<Path> {
  _BlockRevealClipper({
    required this.animation,
    required this.columns,
    required this.rows,
  }) : super(reclip: animation);

  final Animation<double> animation;
  final int columns;
  final int rows;

  @override
  Path getClip(Size size) {
    final path = Path();
    final blockWidth = size.width / columns;
    final blockHeight = size.height / rows;
    final totalBlocks = columns * rows;
    final progress = Curves.easeInOutSine.transform(animation.value);
    final blocksToShow =
        (progress * (totalBlocks + columns))
            .toInt(); // Add columns for smoother end

    for (var i = 0; i < blocksToShow; i++) {
      // Calculate row and column based on diagonal reveal pattern
      var currentSum = 0;
      var r = 0;
      var c = 0;
      while (currentSum < i) {
        c++;
        if (c >= columns) {
          r++;
          c = 0;
        }
        currentSum++;
      }

      if (r < rows) {
        // Add slight overlap to avoid gaps in clipping
        final rect = Rect.fromLTWH(
          c * blockWidth,
          r * blockHeight,
          blockWidth + 0.5,
          blockHeight + 0.5,
        );
        path.addRect(rect);
      }
    }
    if (animation.isCompleted) {
      // Ensure full area is revealed at the end
      path.addRect(Offset.zero & size);
    }
    return path;
  }

  @override
  bool shouldReclip(_BlockRevealClipper oldClipper) =>
      oldClipper.columns != columns || oldClipper.rows != rows || true;
}

/// Slides the new page in diagonally while fading.
class DiagonalSlideFadePageRoute<T> extends PageRouteBuilder<T> {
  DiagonalSlideFadePageRoute({
    required this.page,
    this.beginOffset = const Offset(1, -1), // Default: Top-right
  }) : super(
         transitionDuration: const Duration(milliseconds: 400),
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final tween = Tween(begin: beginOffset, end: Offset.zero);
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: Curves.easeInOutCirc,
           );

           return FadeTransition(
             opacity: animation,
             child: SlideTransition(
               position: tween.animate(curvedAnimation),
               child: child,
             ),
           );
         },
       );
  final Widget page;
  final Offset beginOffset;
}

/// Simulates flipping the page like a card around the vertical axis.
class FlipPageRoute<T> extends PageRouteBuilder<T> {
  FlipPageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Incoming page animation (rotates from -pi to 0 after halfway point)
          final incomingChild =
              animation.value < 0.5
                  ? Container() // Show nothing before halfway
                  : Transform(
                    alignment: FractionalOffset.center,
                    transform:
                        Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // Perspective
                          ..rotateY(pi * (animation.value - 1.0)),
                    child: child, // Represents incoming page
                  );

          // Outgoing screen animation (rotates from 0 to pi)
          final outgoingTransform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(pi * secondaryAnimation.value);

          // Apply outgoing transform, hide outgoing after halfway
          return Transform(
            alignment: FractionalOffset.center,
            transform: outgoingTransform,
            child:
                secondaryAnimation.value > 0.5
                    ? Container() // Hide outgoing after halfway
                    : incomingChild, // Show incoming (or nothing) based on primary animation
          );
        },
      );
  final Widget page;
}

/// A standard cross-fade where the outgoing screen fades/scales out before the incoming screen fades/scales in.
class FadeThroughPageRoute<T> extends PageRouteBuilder<T> {
  FadeThroughPageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeOut = FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
            ),
            child: ScaleTransition(
              // Subtle scale down for outgoing
              scale: Tween<double>(begin: 1, end: 0.95).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeIn,
                ),
              ),
              child: child, // Outgoing placeholder
            ),
          );

          final fadeIn = FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: ScaleTransition(
              // Subtle scale up for incoming
              scale: Tween<double>(begin: 1.05, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: page, // Incoming page
            ),
          );

          return Stack(
            children: <Widget>[
              // Conditionally render based on animation status to avoid overlap issues
              if (secondaryAnimation.status != AnimationStatus.dismissed)
                fadeOut,
              if (animation.status != AnimationStatus.dismissed) fadeIn,
            ],
          );
        },
      );
  final Widget page;
}

/// The incoming screen slides in, revealed progressively by an expanding mask.
class MaskedSlidePageRoute<T> extends PageRouteBuilder<T> {
  MaskedSlidePageRoute({
    required this.page,
    this.maskAlignment = Alignment.centerRight, // Default: Reveal from right
  }) : super(
         transitionDuration: const Duration(
           milliseconds: 300,
         ), // Faster transition
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Note: Outgoing screen animation (e.g., fadeOut) is omitted here for simplicity,
           // but would typically be included, potentially using the 'child' parameter.

           final slideIn = SlideTransition(
             position: Tween<Offset>(
               begin: const Offset(0.1, 0),
               end: Offset.zero,
             ).animate(
               CurvedAnimation(parent: animation, curve: Curves.easeOut),
             ),
             child: ClipPath(
               clipper: _ExpandingRectMaskClipper(
                 progress: animation.value,
                 alignment: maskAlignment,
               ),
               child: page, // Incoming page
             ),
           );

           return Stack(
             children: <Widget>[
               // Add outgoing animation here if needed, e.g.:
               // if (secondaryAnimation.status != AnimationStatus.dismissed)
               //   FadeTransition(opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation), child: child),
               slideIn,
             ],
           );
         },
       );
  final Widget page;
  final Alignment maskAlignment;
}

/// Clipper that reveals content via a rectangle expanding from a specific alignment point.
class _ExpandingRectMaskClipper extends CustomClipper<Path> {
  _ExpandingRectMaskClipper({required this.progress, required this.alignment});

  final double progress;
  final Alignment alignment;

  @override
  Path getClip(Size size) {
    final center = alignment.alongSize(size);
    final width = size.width * progress;
    final height = size.height * progress;

    // Calculate top-left based on alignment and progress
    var left = center.dx - alignment.x * width * 0.5 - width * 0.5;
    var top = center.dy - alignment.y * height * 0.5 - height * 0.5;
    left = left.clamp(
      0.0,
      size.width - width,
    ); // Ensure rect stays within bounds
    top = top.clamp(0.0, size.height - height);

    final rect = Rect.fromLTWH(left, top, width, height);
    return Path()..addRect(rect);
  }

  @override
  bool shouldReclip(_ExpandingRectMaskClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.alignment != alignment;
  }
}
