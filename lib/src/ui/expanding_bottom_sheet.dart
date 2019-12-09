/*
 * Copyright 2019 Marco Gomiero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Adapted from https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/shrine/expanding_bottom_sheet.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends_tournament/src/ui/custom_icons_icons.dart';
import 'package:friends_tournament/src/views/leaderboard_page.dart';
import 'package:meta/meta.dart';

// These curves define the emphasized easing curve.
const Cubic _kAccelerateCurve = Cubic(0.548, 0.0, 0.757, 0.464);
const Cubic _kDecelerateCurve = Cubic(0.23, 0.94, 0.41, 1.0);
// The time at which the accelerate and decelerate curves switch off
const double _kPeakVelocityTime = 0.248210;
// Percent (as a decimal) of animation that should be completed at _peakVelocityTime
const double _kPeakVelocityProgress = 0.379146;
const double _kBottomHeight = 56.0;
// Radius of the shape on the top left of the sheet.
const double _kCornerRadius = 24.0;
const double _kWidthForBottomIcon = 54.0;

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

  // Controller for the opening and closing of the ExpandingBottomSheet
  AnimationController _controller;

  // Animations for the opening and closing of the ExpandingBottomSheet
  Animation<double> _widthAnimation;
  Animation<double> _heightAnimation;
  Animation<double> _thumbnailOpacityAnimation;
  Animation<double> _leaderboardOpacityAnimation;
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
      return Tween<double>(begin: _kWidthForBottomIcon, end: screenWidth).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0.0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      // Closing animation
      return _getEmphasizedEasingAnimation(
        begin: _kWidthForBottomIcon,
        peak: _getPeakPoint(begin: _kWidthForBottomIcon, end: screenWidth),
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
        begin: _kBottomHeight,
        peak: _kBottomHeight +
            (screenHeight - _kBottomHeight) * _kPeakVelocityProgress,
        end: screenHeight,
        isForward: true,
        parent: _controller.view,
      );
    } else {
      // Closing animation
      return Tween<double>(
        begin: _kBottomHeight,
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

  Animation<double> _getLeaderboardOpacityAnimation() {
    return CurvedAnimation(
      parent: _controller.view,
      curve: _controller.status == AnimationStatus.forward
          ? const Interval(0.3, 0.6)
          : const Interval(0.766, 1.0),
    );
  }

  // Returns true if the leaderboard is open or opening and false otherwise.
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

  Widget _buildBottomIcon() {
    return ExcludeSemantics(
      child: Opacity(
        opacity: _thumbnailOpacityAnimation.value,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                AnimatedPadding(
                  padding: EdgeInsetsDirectional.only(start: 20.0, end: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Icon(CustomIcons.award),
                  ),
                  duration: const Duration(milliseconds: 225),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardPage() {
    return Opacity(
      opacity: _leaderboardOpacityAnimation.value,
      child: LeaderboardScreen(),
    );
  }

  Widget _buildLeaderboard(BuildContext context, Widget child) {
    // numProducts is the number of different products in the cart (does not
    // include multiples of the same product).
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    _widthAnimation = _getWidthAnimation(screenWidth);
    _heightAnimation = _getHeightAnimation(screenHeight);
    _shapeAnimation = _getShapeAnimation();
    _thumbnailOpacityAnimation = _getThumbnailOpacityAnimation();
    _leaderboardOpacityAnimation = _getLeaderboardOpacityAnimation();

    return Semantics(
      button: true,
      child: Container(
        width: _widthAnimation.value,
        height: _heightAnimation.value,
        child: Material(
          animationDuration: const Duration(milliseconds: 0),
          shape: ContinuousRectangleBorder (
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_shapeAnimation.value),
            ),
          ),
          elevation: 4.0,
          color: Colors.pinkAccent,
          child: _cartIsVisible ? _buildLeaderboardPage() : _buildBottomIcon(),
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

  // Closes the leaderboard if is open, otherwise exits the app (this should
  // only be relevant for Android).
  // TODO: check the back button behaviour
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
              builder: _buildLeaderboard,
              animation: _controller,
            ),
          ),
        ),
      ),
    );
  }
}
