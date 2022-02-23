import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:math' show asin, pi;

class RoundBaseRectangleBorder extends OutlinedBorder {
  final double factor;
  const RoundBaseRectangleBorder({required this.factor, BorderSide side = BorderSide.none }) : assert(side != null), super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) => RoundBaseRectangleBorder(factor: factor, side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RoundBaseRectangleBorder) {
      return RoundBaseRectangleBorder(factor: factor, side: BorderSide.lerp(a.side, side, t));
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RoundBaseRectangleBorder) {
      return RoundBaseRectangleBorder(factor: factor, side: BorderSide.lerp(side, b.side, t));
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    Rect innerRect = Rect.fromCenter(center: rect.center, width: rect.width - side.width * 2, height: rect.height - side.width * 2);
    double adjuster = 0.2 * innerRect.height;
    double k = innerRect.width * innerRect.width / ( 8 * adjuster);
    double r = k + (adjuster / 2);
    double alpha = asin((k - (adjuster / 2)) / r);
    Rect squareRect = Rect.fromCenter(center: innerRect.center - Offset(0, adjuster / 2), width: innerRect.width, height: innerRect.height - adjuster);
    Rect arcRect = Rect.fromCenter(center: Offset(innerRect.width / 2, innerRect.height - r), width: 2 * r, height: 2 * r);
    return Path()
      ..moveTo(0, squareRect.height)
      ..lineTo(0, 0)
      ..lineTo(squareRect.width, 0)
      ..lineTo(squareRect.width, squareRect.height)
      ..arcTo(arcRect, alpha, pi - 2 * alpha, false)
      ..close();
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    double adjuster = factor * rect.height;
    double k = rect.width * rect.width / ( 8 * adjuster);
    double r = k + (adjuster / 2);
    double alpha = asin((k - (adjuster / 2)) / r);
    Rect squareRect = Rect.fromCenter(center: rect.center - Offset(0, adjuster / 2), width: rect.width, height: rect.height - adjuster);
    Rect arcRect = Rect.fromCenter(center: Offset(rect.width / 2, rect.height - r), width: 2 * r, height: 2 * r);
    return Path()
      ..moveTo(0, squareRect.height)
      ..lineTo(0, 0)
      ..lineTo(squareRect.width, 0)
      ..lineTo(squareRect.width, squareRect.height)
      ..arcTo(arcRect, alpha, pi - 2 * alpha, false)
      ..close();
  }

  @override
  RoundBaseRectangleBorder copyWith({ BorderSide? side }) {
    return RoundBaseRectangleBorder(factor: factor, side: side ?? this.side);
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(getOuterPath(rect), side.toPaint());
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RoundBaseRectangleBorder
        && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'RoundBaseRectangleBorder')}($side)';
  }
}