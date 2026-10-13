import 'package:flutter/material.dart';
import '../../logica/rectangulo.dart';

/// Renderiza una plataforma con estilo rústico de cantera rosa colonial y adoquines.
/// Si es el suelo principal (ancho >= 1000), renderiza adoquines rústicos y muro de túnel colonial.
class PlataformaCanteraWidget extends StatelessWidget {
  final Rectangulo plataforma;
  final bool esPisoPrincipal;

  const PlataformaCanteraWidget({
    super.key,
    required this.plataforma,
    this.esPisoPrincipal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (esPisoPrincipal) {
      return _buildPisoPrincipal();
    }
    return _buildPlataformaElevada();
  }

  Widget _buildPlataformaElevada() {
    return Container(
      width: plataforma.ancho,
      height: plataforma.alto,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
        // Degradado de cantera rosa auténtica con sombras de volumen
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC47B70), // Resalte de cantera superior
            Color(0xFFA3574C), // Cuerpo de cantera rosa
            Color(0xFF7A382F), // Base oscura con sombra
          ],
        ),
        border: Border.all(
          color: const Color(0xFF4A201A),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Borde superior de adoquines / sillares tallados
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFDF9E94),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          ),
          // Juntas verticales de cantería
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              (plataforma.ancho / 30).floor(),
              (index) => Container(
                width: 1.5,
                color: const Color(0xFF4A201A).withValues(alpha: 0.4),
              ),
            ),
          ),
          // Detalle de musgo / enredadera sutil en la esquina
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF33691E).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPisoPrincipal() {
    return Container(
      width: plataforma.ancho,
      height: plataforma.alto,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8D5B4C), // Adoquín superior
            Color(0xFF5A3125), // Cantera oscura
            Color(0xFF33160F), // Suelo profundo
          ],
        ),
        border: Border(
          top: BorderSide(color: Color(0xFFD7CCC8), width: 3), // Remate empedrado
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Textura de adoquines empedrados continuos
          Positioned.fill(
            child: Row(
              children: List.generate(
                (plataforma.ancho / 24).ceil(),
                (index) => Container(
                  width: 24,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.black.withValues(alpha: 0.25),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Colors.black.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
