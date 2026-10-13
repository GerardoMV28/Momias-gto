import 'dart:math';
import 'package:flutter/material.dart';

/// Pinta el fondo rústico y colonial de Guanajuato con efecto Parallax:
/// Cielo crepuscular, luna colonial, cerros con el Pípila y casas coloniales escalonadas.
class FondoGuanajuatoPainter extends CustomPainter {
  final double camaraX;

  FondoGuanajuatoPainter({required this.camaraX});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Cielo crepuscular de Guanajuato (atardecer colonial místico)
    final rectCielo = Rect.fromLTWH(0, 0, size.width, size.height);
    final paintCielo = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF140D24), // Noche profunda
          Color(0xFF2C1635), // Violeta colonial
          Color(0xFF5A223B), // Guinda Guanajuato
          Color(0xFF9E432D), // Teja quemada
          Color(0xFFD97736), // Ocre dorado atardecer
        ],
        stops: [0.0, 0.35, 0.65, 0.85, 1.0],
      ).createShader(rectCielo);
    canvas.drawRect(rectCielo, paintCielo);

    // 2. Estrellas y faroles lejanos
    final paintEstrellas = Paint()..color = Colors.white.withValues(alpha: 0.7);
    final random = Random(42);
    for (int i = 0; i < 45; i++) {
      final sx = (random.nextDouble() * size.width * 2 - (camaraX * 0.05)) % size.width;
      final sy = random.nextDouble() * (size.height * 0.45);
      final radio = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(sx, sy), radio, paintEstrellas);
    }

    // 3. Luna Llena Colonial
    final lunaX = size.width * 0.8 - (camaraX * 0.03);
    const lunaY = 55.0;
    // Resplandor
    final paintHalo = Paint()
      ..color = const Color(0xFFFFECB3).withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(Offset(lunaX, lunaY), 32, paintHalo);
    // Disco lunar
    final paintLuna = Paint()..color = const Color(0xFFFFF8E1);
    canvas.drawCircle(Offset(lunaX, lunaY), 24, paintLuna);
    // Cráteres sutiles
    final paintCrater = Paint()..color = const Color(0xFFFFE082).withValues(alpha: 0.4);
    canvas.drawCircle(Offset(lunaX - 6, lunaY - 4), 5, paintCrater);
    canvas.drawCircle(Offset(lunaX + 7, lunaY + 6), 4, paintCrater);
    canvas.drawCircle(Offset(lunaX + 2, lunaY - 8), 3, paintCrater);

    // 4. Capa 1: Cerros de Guanajuato con silueta lejana (Parallax 0.12)
    _dibujarCerrosLejanos(canvas, size, camaraX * 0.12);

    // 5. Capa 2: Silueta de casas coloniales escalonadas y cúpulas (Parallax 0.28)
    _dibujarPuebloColonial(canvas, size, camaraX * 0.28);
  }

  void _dibujarCerrosLejanos(Canvas canvas, Size size, double offset) {
    final paintMontanas = Paint()..color = const Color(0xFF381B34).withValues(alpha: 0.95);
    final path = Path();
    final yBase = size.height * 0.68;
    path.moveTo(0, size.height);
    path.lineTo(0, yBase);

    // Curvas montañosas que representan las cañadas de Guanajuato
    for (double x = -100; x < size.width + 200; x += 120) {
      final posX = x - (offset % 600);
      path.quadraticBezierTo(
        posX + 60,
        yBase - 40 - (sin(x * 0.05) * 20),
        posX + 120,
        yBase + (cos(x * 0.03) * 15),
      );
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paintMontanas);
  }

  void _dibujarPuebloColonial(Canvas canvas, Size size, double offset) {
    final paintCasas = Paint()..color = const Color(0xFF281126);
    final paintTechos = Paint()..color = const Color(0xFF531E2A);
    final paintVentanaLuz = Paint()..color = const Color(0xFFFFD54F).withValues(alpha: 0.8);

    final ySuelo = size.height * 0.85;

    // Generamos fachadas continuas a lo largo del nivel
    for (int i = -2; i < 35; i++) {
      final xCasa = i * 75.0 - (offset % 1800);
      if (xCasa < -100 || xCasa > size.width + 100) continue;

      final alturaCasa = 55.0 + ((i * 37) % 50);
      final yTecho = ySuelo - alturaCasa;
      const anchoCasa = 68.0;

      // Pared colonial
      canvas.drawRect(
        Rect.fromLTWH(xCasa, yTecho, anchoCasa, alturaCasa),
        paintCasas,
      );

      // Techo de teja inclinada
      final pathTecho = Path()
        ..moveTo(xCasa - 6, yTecho)
        ..lineTo(xCasa + anchoCasa / 2, yTecho - 14)
        ..lineTo(xCasa + anchoCasa + 6, yTecho)
        ..close();
      canvas.drawPath(pathTecho, paintTechos);

      // Campanario o cúpula en algunas casas
      if (i % 4 == 0) {
        final pathCupula = Path()
          ..addArc(
            Rect.fromLTWH(xCasa + 18, yTecho - 30, 32, 30),
            pi,
            pi,
          );
        canvas.drawPath(pathCupula, paintTechos);
        // Pequeña cruz colonial
        canvas.drawLine(
          Offset(xCasa + 34, yTecho - 30),
          Offset(xCasa + 34, yTecho - 42),
          paintCasas..strokeWidth = 2,
        );
        canvas.drawLine(
          Offset(xCasa + 29, yTecho - 38),
          Offset(xCasa + 39, yTecho - 38),
          paintCasas..strokeWidth = 2,
        );
      }

      // Ventanas con farol o luz encendida (vida colonial)
      if (i % 2 == 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(xCasa + 14, yTecho + 16, 14, 18),
            const Radius.circular(6),
          ),
          paintVentanaLuz,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(xCasa + 40, yTecho + 16, 14, 18),
            const Radius.circular(6),
          ),
          paintVentanaLuz,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant FondoGuanajuatoPainter oldDelegate) {
    return oldDelegate.camaraX != camaraX;
  }
}
