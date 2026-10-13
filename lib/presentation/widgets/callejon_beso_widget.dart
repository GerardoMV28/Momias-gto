import 'package:flutter/material.dart';

/// Representación escenográfica del legendario Callejón del Beso de Guanajuato.
/// Muestra los dos balcones coloniales de hierro forjado casi tocándose,
/// bugambilias floreadas, farol colonial con halo de luz y letrero de madera rústica.
class CallejonBesoWidget extends StatelessWidget {
  const CallejonBesoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Fachadas de las dos casas enfrentadas (rojo colonial y amarillo ocre)
          Positioned(
            left: 0,
            bottom: 0,
            width: 48,
            height: 140,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF8B2500), // Rojo almagre colonial
                borderRadius: BorderRadius.only(topRight: Radius.circular(6)),
                border: Border(right: BorderSide(color: Colors.black45, width: 2)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    color: const Color(0xFF5A1600), // Teja
                  ),
                  const SizedBox(height: 12),
                  // Ventana colonial con reja
                  Container(
                    width: 28,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF261109),
                      border: Border.all(color: const Color(0xFFD7CCC8), width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            width: 48,
            height: 140,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFC68B19), // Amarillo ocre colonial
                borderRadius: BorderRadius.only(topLeft: Radius.circular(6)),
                border: Border(left: BorderSide(color: Colors.black45, width: 2)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    color: const Color(0xFF8B5E0D), // Teja
                  ),
                  const SizedBox(height: 12),
                  // Ventana colonial
                  Container(
                    width: 28,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF261109),
                      border: Border.all(color: const Color(0xFFD7CCC8), width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
                  ),
                ],
              ),
            ),
          ),

          // Balcón de herrería izquierda
          Positioned(
            left: 20,
            top: 60,
            width: 38,
            height: 26,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF212121),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFF9E9E9E), width: 1),
              ),
              alignment: Alignment.topCenter,
              child: const Text('🌺', style: TextStyle(fontSize: 12)),
            ),
          ),

          // Balcón de herrería derecha (casi tocándose con el izquierdo)
          Positioned(
            right: 20,
            top: 60,
            width: 38,
            height: 26,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF212121),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFF9E9E9E), width: 1),
              ),
              alignment: Alignment.topCenter,
              child: const Text('🌺', style: TextStyle(fontSize: 12)),
            ),
          ),

          // Farol colonial suspendido entre los balcones con halo de luz
          Positioned(
            top: 25,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD54F).withValues(alpha: 0.25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text('🏮', style: TextStyle(fontSize: 18)),
            ),
          ),

          // Icono del beso entre ambos balcones
          const Positioned(
            top: 65,
            child: Text(
              '💋',
              style: TextStyle(
                fontSize: 28,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // Letrero de madera rústica tallada con cadenas
          Positioned(
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF4E2712), // Madera rústica de nogal
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5), // Borde dorado
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                'Callejón del Beso',
                style: TextStyle(
                  color: Color(0xFFFFE082),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
