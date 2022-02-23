import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:math' show sqrt2, acos, pi;

class DropletBorder extends OutlinedBorder {
  /// Create a droplet border.
  ///
  /// The [side] argument must not be null.
  ///
  final bool useRegular;
  const DropletBorder({this.useRegular = true, BorderSide side = BorderSide.none }) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) => DropletBorder(useRegular: useRegular, side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is DropletBorder) {
      return DropletBorder(useRegular: useRegular, side: BorderSide.lerp(a.side, side, t));
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is DropletBorder) {
      return DropletBorder(useRegular: useRegular, side: BorderSide.lerp(side, b.side, t));
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    Rect innerRect = Rect.fromCenter(center: rect.center, width: rect.width - 2 * side.width, height: rect.height - 2 * side.width);
    if(useRegular){
      double r = innerRect.height / (1 + sqrt2);
      Offset center = Offset(innerRect.width / 2, innerRect.height - r);
      Offset arcStartOffset = center + Offset.fromDirection(- pi / 4, r);
      return Path()
        ..moveTo(r, 0)
        ..lineTo(arcStartOffset.dx, arcStartOffset.dy)
        ..arcTo(Rect.fromCenter(center: center, width: 2 * r, height: 2 * r), - pi / 4, 3 * pi / 2, false)
        ..close();
    } else {
      if(innerRect.width > innerRect.height){
        return Path()
          ..addOval(Rect.fromCenter(center: Offset(innerRect.width / 2, innerRect.height / 2), width: innerRect.shortestSide, height: innerRect.shortestSide));
      } else {
        double r = innerRect.width / 2;
        double theta = 2 * acos(innerRect.width / (2 * innerRect.height - innerRect.width));
        double alpha = - ((pi - theta) / 2);
        Offset center = Offset(innerRect.width / 2, innerRect.height - r);
        Offset arcStartOffset = center + Offset.fromDirection(alpha, r);
        return Path()
          ..moveTo(r, 0)
          ..lineTo(arcStartOffset.dx, arcStartOffset.dy)
          ..arcTo(Rect.fromCenter(center: center, width: 2 * r, height: 2 * r), alpha, pi - 2 * alpha, false)
          ..close();
      }
    }
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    if(rect.width > rect.height){
      return Path()
        ..addOval(Rect.fromCenter(center: Offset(rect.width / 2, rect.height / 2), width: rect.shortestSide, height: rect.shortestSide));
    } else {
      double r = rect.width / 2;
      double theta = 2 * acos(rect.width / (2 * rect.height - rect.width));
      double alpha = - ((pi - theta) / 2);
      Offset center = Offset(rect.width / 2, rect.height - r);
      Offset arcStartOffset = center + Offset.fromDirection(alpha, r);
      return Path()
        ..moveTo(r, 0)
        ..lineTo(arcStartOffset.dx, arcStartOffset.dy)
        ..arcTo(Rect.fromCenter(center: center, width: 2 * r, height: 2 * r), alpha, pi - 2 * alpha, false)
        ..close();
    }
  }

  @override
  DropletBorder copyWith({ BorderSide? side }) {
    return DropletBorder(useRegular: useRegular, side: side ?? this.side);
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
    return other is DropletBorder
        && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DropletBorder')}($side)';
  }
}