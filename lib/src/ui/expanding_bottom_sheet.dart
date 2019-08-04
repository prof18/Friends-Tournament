// Adapted from https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/shrine/expanding_bottom_sheet.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends_tournament/src/views/leaderboard_page.dart';
import 'package:meta/meta.dart';

// These curves define the emphasized easing curve.
const Cubic _kAccelerateCurve = Cubic(0.548, 0.0, 0.757, 0.464);
const Cubic _kDecelerateCurve = Cubic(0.23, 0.94, 0.41, 1.0);
// The time at which the accelerate and decelerate curves switch off
const double _kPeakVelocityTime = 0.248210;
// Percent (as a decimal) of animation that should be completed at _peakVelocityTime
const double _kPeakVelocityProgress = 0.379146;
const double _kCartHeight = 56.0;
// Radius of the shape on the top left of the sheet.
const double _kCornerRadius = 24.0;
// Width for just the cart icon and no thumbnails.
const double _kWidthForCartIcon = 64.0;

class ExpandingBottomSheet extends StatefulWidget {
  const ExpandingBottomSheet({Key key, @required this.hideController})
      : assert(hideController != null),
        super(key: key);

  final AnimationController hideController;

  @override
  _ExpandingBottomSheetState createState() => _ExpandingBottomSheetState();

  static _ExpandingBottomSheetState of(BuildContext context,
      {bool isNullOk = false}) {
    assert(isNullOk != null);
    assert(context != null);
    final _ExpandingBottomSheetState result = context
        .ancestorStateOfType(const TypeMatcher<_ExpandingBottomSheetState>());
    if (isNullOk || result != null) {
      return result;
    }
    throw FlutterError(
        'ExpandingBottomSheet.of() called with a context that does not contain a ExpandingBottomSheet.\n');
  }
}

// Emphasized Easing is a motion curve that has an organic, exciting feeling.
// It's very fast to begin with and then very slow to finish. Unlike standard
// curves, like [Curves.fastOutSlowIn], it can't be expressed in a cubic bezier
// curve formula. It's quintic, not cubic. But it _can_ be expressed as one
// curve followed by another, which we do here.
Animation<T> _getEmphasizedEasingAnimation<T>({
  @required T begin,
  @required T peak,
  @required T end,
  @required bool isForward,
  @required Animation<double> parent,
}) {
  Curve firstCurve;
  Curve secondCurve;
  double firstWeight;
  double secondWeight;

  if (isForward) {
    firstCurve = _kAccelerateCurve;
    secondCurve = _kDecelerateCurve;
    firstWeight = _kPeakVelocityTime;
    secondWeight = 1.0 - _kPeakVelocityTime;
  } else {
    firstCurve = _kDecelerateCurve.flipped;
    secondCurve = _kAccelerateCurve.flipped;
    firstWeight = 1.0 - _kPeakVelocityTime;
    secondWeight = _kPeakVelocityTime;
  }

  return TweenSequence<T>(
    <TweenSequenceItem<T>>[
      TweenSequenceItem<T>(
        weight: firstWeight,
        tween: Tween<T>(
          begin: begin,
          end: peak,
        ).chain(CurveTween(curve: firstCurve)),
      ),
      TweenSequenceItem<T>(
        weight: secondWeight,
        tween: Tween<T>(
          begin: peak,
          end: end,
        ).chain(CurveTween(curve: secondCurve)),
      ),
    ],
  ).animate(parent);
}

// Calculates the value where two double Animations should be joined. Used by
// callers of _getEmphasisedEasing<double>().
double _getPeakPoint({double begin, double end}) {
  return begin + (end - begin) * _kPeakVelocityProgress;
}

class _ExpandingBottomSheetState extends State<ExpandingBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey _expandingBottomSheetKey =
      GlobalKey(debugLabel: 'Expanding bottom sheet');

  // The width of the Material, calculated by _widthFor() & based on the number
  // of products in the cart. 64.0 is the width when there are 0 products
  // (_kWidthForZeroProducts)
  double _width = _kWidthForCartIcon;

  // Controller for the opening and closing of the ExpandingBottomSheet
  AnimationController _controller;

  // Animations for the opening and closing of the ExpandingBottomSheet
  Animation<double> _widthAnimation;
  Animation<double> _heightAnimation;
  Animation<double> _thumbnailOpacityAnimation;
  Animation<double> _cartOpacityAnimation;
  Animation<double> _shapeAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _getWidthAnimation(double screenWidth) {
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation
      return Tween<double>(begin: _width, end: screenWidth).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0.0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      // Closing animation
      return _getEmphasizedEasingAnimation(
        begin: _width,
        peak: _getPeakPoint(begin: _width, end: screenWidth),
        end: screenWidth,
        isForward: false,
        parent: CurvedAnimation(
            parent: _controller.view, curve: const Interval(0.0, 0.87)),
      );
    }
  }

  Animation<double> _getHeightAnimation(double screenHeight) {
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation

      return _getEmphasizedEasingAnimation(
        begin: _kCartHeight,
        peak: _kCartHeight +
            (screenHeight - _kCartHeight) * _kPeakVelocityProgress,
        end: screenHeight,
        isForward: true,
        parent: _controller.view,
      );
    } else {
      // Closing animation
      return Tween<double>(
        begin: _kCartHeight,
        end: screenHeight,
      ).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0.434, 1.0, curve: Curves.linear), // not used
          // only the reverseCurve will be used
          reverseCurve:
              Interval(0.434, 1.0, curve: Curves.fastOutSlowIn.flipped),
        ),
      );
    }
  }

  // Animation of the cut corner. It's cut when closed and not cut when open.
  Animation<double> _getShapeAnimation() {
    if (_controller.status == AnimationStatus.forward) {
      return Tween<double>(begin: _kCornerRadius, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0.0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      return _getEmphasizedEasingAnimation(
        begin: _kCornerRadius,
        peak: _getPeakPoint(begin: _kCornerRadius, end: 0.0),
        end: 0.0,
        isForward: false,
        parent: _controller.view,
      );
    }
  }

  Animation<double> _getThumbnailOpacityAnimation() {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller.view,
        curve: _controller.status == AnimationStatus.forward
            ? const Interval(0.0, 0.3)
            : const Interval(0.532, 0.766),
      ),
    );
  }

  Animation<double> _getCartOpacityAnimation() {
    return CurvedAnimation(
      parent: _controller.view,
      curve: _controller.status == AnimationStatus.forward
          ? const Interval(0.3, 0.6)
          : const Interval(0.766, 1.0),
    );
  }

  // Returns the correct width of the ExpandingBottomSheet based on the number of
  // products in the cart.
  double _widthFor(int numProducts) {
    switch (numProducts) {
      case 0:
        return _kWidthForCartIcon;
      case 1:
        return 136.0;
      case 2:
        return 192.0;
      case 3:
        return 248.0;
      default:
        return 278.0;
    }
  }

  // Returns true if the cart is open or opening and false otherwise.
  bool get _isOpen {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  // Opens the ExpandingBottomSheet if it's closed, otherwise does nothing.
  void open() {
    if (!_isOpen) {
      _controller.forward();
    }
  }

  // Closes the ExpandingBottomSheet if it's open or opening, otherwise does nothing.
  void close() {
    if (_isOpen) {
      _controller.reverse();
    }
  }

  bool get _cartIsVisible => _thumbnailOpacityAnimation.value == 0.0;

  Widget _buildThumbnails() {
    return ExcludeSemantics(
      child: Opacity(
        opacity: _thumbnailOpacityAnimation.value,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                AnimatedPadding(
                  padding: EdgeInsetsDirectional.only(start: 20.0, end: 8.0),
                  child: const Icon(Icons.shopping_cart),
                  duration: const Duration(milliseconds: 225),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingCartPage() {
    return Opacity(
      opacity: _cartOpacityAnimation.value,
      child: LeaderboardScreen(),
    );
  }

  Widget _buildCart(BuildContext context, Widget child) {
    // numProducts is the number of different products in the cart (does not
    // include multiples of the same product).
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    _width = _kWidthForCartIcon;
    _widthAnimation = _getWidthAnimation(screenWidth);
    _heightAnimation = _getHeightAnimation(screenHeight);
    _shapeAnimation = _getShapeAnimation();
    _thumbnailOpacityAnimation = _getThumbnailOpacityAnimation();
    _cartOpacityAnimation = _getCartOpacityAnimation();

    return Semantics(
      button: true,
      value: 'Shopping cart',
      child: Container(
        width: _widthAnimation.value,
        height: _heightAnimation.value,
        child: Material(
          animationDuration: const Duration(milliseconds: 0),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_shapeAnimation.value),
            ),
          ),
          elevation: 4.0,
          color: Colors.pinkAccent,
          child: _cartIsVisible ? _buildShoppingCartPage() : _buildThumbnails(),
        ),
      ),
    );
  }

  // Builder for the hide and reveal animation when the backdrop opens and closes
  Widget _buildSlideAnimation(BuildContext context, Widget child) {
    _slideAnimation = _getEmphasizedEasingAnimation(
      begin: const Offset(1.0, 0.0),
      peak: const Offset(_kPeakVelocityProgress, 0.0),
      end: const Offset(0.0, 0.0),
      isForward: widget.hideController.status == AnimationStatus.forward,
      parent: widget.hideController,
    );

    return SlideTransition(
      position: _slideAnimation,
      child: child,
    );
  }

  // Closes the cart if the cart is open, otherwise exits the app (this should
  // only be relevant for Android).
  Future<bool> _onWillPop() async {
    if (!_isOpen) {
      await SystemNavigator.pop();
      return true;
    }

    close();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      key: _expandingBottomSheetKey,
      duration: const Duration(milliseconds: 225),
      curve: Curves.easeInOut,
      vsync: this,
      alignment: FractionalOffset.topLeft,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: AnimatedBuilder(
          animation: widget.hideController,
          builder: _buildSlideAnimation,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: open,
            child: AnimatedBuilder(
              builder: _buildCart,
              animation: _controller,
            ),
          ),
        ),
      ),
    );
  }
}
