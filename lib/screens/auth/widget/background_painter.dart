import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logging_screen2_withanim/config/palette.dart';

// bu class da background renklendirmesi yapılıyor.
class BackgroundPainter extends CustomPainter {
  BackgroundPainter({Animation<double> animation})
      : bluePaint = Paint() // burda renkleri değişebilir //bu uzun şekil
    ..color = Palette.blue //renk değiştri
    ..style = PaintingStyle
        .fill, // her seferşnde yeni paint oluşturmamak için ayrırıp yapıyoruz.
        purplePaint = Paint()
          ..color = Palette.purple
          ..style = PaintingStyle.fill,
        orangePaint = Paint()
          ..color = Palette.orange
          ..style = PaintingStyle.fill,
        linePaint = Paint()
          ..color = Colors.orange[300]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
        liquidAnim = CurvedAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInBack,
          parent: animation,
        ),
        blueAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.7,
            curve: Interval(0, 0.8, curve: SpringCurve()),
          ),
          reverseCurve: Curves.linear,
        ),
        purpleAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.8,
            curve: Interval(0, 0.9, curve: SpringCurve()),
          ),
          reverseCurve: Curves.easeInCirc,
        ),

        orangeAnim = CurvedAnimation(
          parent: animation,
          curve: const SpringCurve(),
          reverseCurve: Curves.easeInCirc,
        ),
        super(repaint: animation);
  final Animation<double> liquidAnim; // lines moving
  final Animation<double> blueAnim; // position blue color
  final Animation<double> orangeAnim;
  final Animation<double> purpleAnim;
  final Paint bluePaint;
  final Paint orangePaint;
  final Paint linePaint;
  final Paint purplePaint;

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    paintOrange(canvas, size);
    paintPurple(size, canvas);
    paintBlue(size, canvas);
  }

  void paintOrange(Canvas canvas, Size size) {
    // burası mavi rengi eklemek için
    // bu şekil düz buna eğri vermek gerekiyor.
    // sadece light blue rengi için yapılacak
    final path = Path();
    path.moveTo(
        size.width,
        size.height /
            2); // burada oluşacak şekil için yüksekliği ekran size yarısı. genişlik ekran kadar olacak
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(0, size.height, orangeAnim.value),
    );
    _addPointsToPath(path, [
      // burada şekil verdik hareket etmesi için animation gerekiyor.
      Point(lerpDouble(0, size.width / 3, orangeAnim.value),
          lerpDouble(0, size.height, blueAnim.value)),

      Point(lerpDouble(size.width / 2, size.width / 4 * 3, liquidAnim.value),
          lerpDouble(size.height / 2, size.height / 4 * 3, liquidAnim.value)),
      Point(
        size.width,
        lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value),
      ),
    ]);
    canvas.drawPath(path, orangePaint);
  }

  void paintPurple(Size size, Canvas canvas) {
    final path = Path();
    path.moveTo(size.width, 300);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(
        size.height / 4,
        size.height / 2,
        purpleAnim.value,
      ),
    );
    _addPointsToPath(
      path,
      [
        Point(
          size.width / 4,
          lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 5,
          lerpDouble(size.height / 4, size.height / 2, liquidAnim.value),
        ),
        Point(
          size.width * 4 / 5,
          lerpDouble(size.height / 6, size.height / 3, purpleAnim.value),
        ),
        Point(
          size.width,
          lerpDouble(size.height / 5, size.height / 4, purpleAnim.value),
        ),
      ],
    );

    canvas.drawPath(path, purplePaint);
  }

  void paintBlue(Size size, Canvas canvas) {
    if (blueAnim.value > 0) {
      final path = Path();

      path.moveTo(size.width * 3 / 4, 0);
      path.lineTo(0, 0);
      path.lineTo(
        0,
        lerpDouble(0, size.height / 12, blueAnim.value),
      );

      _addPointsToPath(path, [
        Point(
          size.width / 7,
          lerpDouble(0, size.height / 6, liquidAnim.value),
        ),
        Point(
          size.width / 3,
          lerpDouble(0, size.height / 10, liquidAnim.value),
        ),
        Point(
          size.width / 3 * 2,
          lerpDouble(0, size.height / 8, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 4,
          0,
        ),
      ]);

      canvas.drawPath(path, bluePaint);
    }
  }

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError('Need three or more points to create a path.');
    }

    for (var i = 0; i < points.length - 2; i++) {
      final xc = (points[i].x + points[i + 1].x) / 2;
      final yc = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xc, yc);
    }

    // connect the last two points
    path.quadraticBezierTo(
      // bu o yamuk şekli vermesi için
        points[points.length - 2].x,
        points[points.length - 2].y,
        points[points.length - 1].x,
        points[points.length - 1].y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}

class SpringCurve extends Curve {
  // spring curve = yay eğrisi
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return (-(pow(e, -t / a) * cos(t * w)) + 1).toDouble();
  }
}
