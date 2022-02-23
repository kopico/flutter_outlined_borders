import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class OvalBorder extends OutlinedBorder {
  /// Create a oval border.
  ///
  /// The [side] argument must not be null.
  const OvalBorder({ BorderSide side = BorderSide.none }) : assert(side != null), super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) => OvalBorder(side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is OvalBorder)
      return OvalBorder(side: BorderSide.lerp(a.side, side, t));
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is OvalBorder)
      return OvalBorder(side: BorderSide.lerp(side, b.side, t));
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    return Path()
      ..addOval(Rect.fromCenter(center: rect.center, width: rect.width - (side.width * 2), height: rect.height - (side.width * 2)));
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    return Path()
      ..addOval(rect);
  }

  @override
  OvalBorder copyWith({ BorderSide? side }) {
    return OvalBorder(side: side ?? this.side);
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawOval(rect, side.toPaint());
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is OvalBorder
        && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'OvalBorder')}($side)';
  }
}