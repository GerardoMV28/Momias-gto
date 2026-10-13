import 'package:flutter/material.dart';

/// Personaje Explorador / Charro aventurero con sombra y orientación.
class PersonajeWidget extends StatelessWidget {
  final double ancho;
  final double alto;
  final bool mirandoIzquierda;

  const PersonajeWidget({
    super.key,
    required this.ancho,
    required this.alto,
    required this.mirandoIzquierda,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Sombra suave proyectada en el suelo
        Positioned(
          bottom: -3,
          child: Container(
            width: ancho * 0.75,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Cuerpo y sprite del aventurero
        Transform.scale(
          scaleX: mirandoIzquierda ? -1.0 : 1.0,
          child: Container(
            width: ancho,
            height: alto,
            decoration: BoxDecoration(
              // Chaleco y tonos aventureros de cuero
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF8D6E63), Color(0xFF4E342E)],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 2),
                  blurRadius: 3,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              '🤠',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}

/// Momia de Guanajuato con aura fantasmal sepulcral y vendas rústicas.
class MomiaWidget extends StatelessWidget {
  final double ancho;
  final double alto;
  final double velocidadX;

  const MomiaWidget({
    super.key,
    required this.ancho,
    required this.alto,
    required this.velocidadX,
  });

  @override
  Widget build(BuildContext context) {
    final mirandoIzquierda = velocidadX < 0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Sombra en el suelo
        Positioned(
          bottom: -2,
          child: Container(
            width: ancho * 0.7,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Cuerpo de la momia con halo místico
        Transform.scale(
          scaleX: mirandoIzquierda ? -1.0 : 1.0,
          child: Container(
            width: ancho,
            height: alto,
            decoration: BoxDecoration(
              color: const Color(0xFFD7CCC8), // Vendas envejecidas
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF795548), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF69F0AE).withValues(alpha: 0.25), // Aura espectral verdosa
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              '🧟',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}

/// Calaverita de azúcar tradicional de Guanajuato (Día de Muertos).
class CalaveritaAzucarWidget extends StatelessWidget {
  final double ancho;
  final double alto;

  const CalaveritaAzucarWidget({
    super.key,
    required this.ancho,
    required this.alto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: alto,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFF8E1).withValues(alpha: 0.85),
        boxShadow: [
          // Resplandor festivo dorado
          BoxShadow(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text(
        '💀',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

/// Farol colonial de herrería colocado en las calles de Guanajuato con cono de luz.
class FarolColonialWidget extends StatelessWidget {
  const FarolColonialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 90,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Cono de luz cálida proyectada hacia abajo
          Positioned(
            top: 15,
            child: Container(
              width: 48,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFFD54F).withValues(alpha: 0.28),
                    const Color(0xFFFFD54F).withValues(alpha: 0.0),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
            ),
          ),
          // Poste de herrería
          Positioned(
            bottom: 0,
            child: Container(
              width: 3,
              height: 75,
              color: const Color(0xFF212121),
            ),
          ),
          // Farol de vidrio y bombilla
          Positioned(
            top: 0,
            child: Container(
              width: 20,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE082),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD54F).withValues(alpha: 0.7),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text('🕯️', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }
}
