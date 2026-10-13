import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logica/motor_juego.dart';
import '../logica/personaje.dart';
import '../logica/momia.dart';
import '../logica/calaverita.dart';
import '../logica/rectangulo.dart';
import '../logica/estado_juego.dart';
import 'widgets/fondo_guanajuato.dart';
import 'widgets/plataforma_cantera.dart';
import 'widgets/callejon_beso_widget.dart';
import 'widgets/sprites_rusticos.dart';

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;
  Timer? _bucle;
  double _direccion = 0;
  bool _teclaIzquierda = false;
  bool _teclaDerecha = false;
  bool _mirandoIzquierda = false;

  // Posiciones de los faroles coloniales en el nivel
  static const List<double> _posicionesFaroles = [180.0, 480.0, 820.0, 1350.0, 1720.0];

  double get _direccionFinal {
    double dir = _direccion;
    if (_teclaIzquierda) dir -= 1;
    if (_teclaDerecha) dir += 1;
    return dir.clamp(-1.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_manejarEventoTeclado);
    _iniciarNivel();
    _iniciarBucle();
  }

  bool _manejarEventoTeclado(KeyEvent event) {
    final esIzquierda = event.logicalKey == LogicalKeyboardKey.keyA ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final esDerecha = event.logicalKey == LogicalKeyboardKey.keyD ||
        event.logicalKey == LogicalKeyboardKey.arrowRight;
    final esSalto = event.logicalKey == LogicalKeyboardKey.keyW ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.space;

    if (esIzquierda) {
      if (event is KeyDownEvent) _teclaIzquierda = true;
      if (event is KeyUpEvent) _teclaIzquierda = false;
    }

    if (esDerecha) {
      if (event is KeyDownEvent) _teclaDerecha = true;
      if (event is KeyUpEvent) _teclaDerecha = false;
    }

    if (esSalto && event is KeyDownEvent) {
      _motor.saltar();
    }

    return false;
  }

  void _iniciarNivel() {
    _teclaIzquierda = false;
    _teclaDerecha = false;
    _direccion = 0;
    _mirandoIzquierda = false;
    _motor = MotorJuego(
      personaje: Personaje(x: 20, y: 100),
      plataformas: const [
        Rectangulo(x: 0, y: 300, ancho: 2000, alto: 40),
        Rectangulo(x: 300, y: 220, ancho: 120, alto: 20),
        Rectangulo(x: 550, y: 160, ancho: 120, alto: 20),
      ],
      momias: [
        Momia(x: 320, y: 268, limiteIzquierdo: 300, limiteDerecho: 420),
        Momia(x: 900, y: 268, limiteIzquierdo: 850, limiteDerecho: 1100),
      ],
      calaveritas: [
        Calaverita(x: 360, y: 180),
        Calaverita(x: 600, y: 120),
        Calaverita(x: 1200, y: 260),
      ],
      posicionMeta: 1900,
      anchoNivel: 2000,
    );
  }

  void _iniciarBucle() {
    _bucle = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final dir = _direccionFinal;
      if (dir < 0) {
        _mirandoIzquierda = true;
      } else if (dir > 0) {
        _mirandoIzquierda = false;
      }

      setState(() => _motor.mover(dir * 4));

      if (_motor.estado != EstadoJuego.jugando) {
        _bucle?.cancel();
        _mostrarResultado();
      }
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_manejarEventoTeclado);
    _bucle?.cancel();
    super.dispose();
  }

  void _mostrarResultado() {
    final gano = _motor.estado == EstadoJuego.ganado;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'resultado',
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
        child: FadeTransition(
          opacity: anim1,
          child: AlertDialog(
            backgroundColor: const Color(0xFF2C140E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
            ),
            title: Text(
              gano ? '¡Llegaste al Callejón del Beso! 💋' : '¡Las momias te atraparon! 🧟',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gano ? const Color(0xFFFFD54F) : const Color(0xFFFF8A80),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gano
                    ? 'Lograste cruzar los callejones coloniales de Guanajuato.'
                    : 'Te quedaste sin vidas en los túneles subterráneos.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFD7CCC8), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E1C16),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF8D6E63)),
                  ),
                  child: Text(
                    'Puntaje final: ${_motor.puntaje} pts',
                    style: const TextStyle(
                      color: Color(0xFFFFE082),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D2B1B),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(_iniciarNivel);
                    _iniciarBucle();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Jugar de nuevo', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const anchoVentana = 360.0;
    final camaraX = (_motor.personaje.x - anchoVentana / 2)
        .clamp(0.0, _motor.anchoNivel - anchoVentana);

    return Scaffold(
      backgroundColor: const Color(0xFF140D24),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🤠 ', style: TextStyle(fontSize: 20)),
            Text(
              'Momias de Guanajuato',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            Text(' 🏛️', style: TextStyle(fontSize: 20)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF31150F),
        foregroundColor: const Color(0xFFFFE082),
        elevation: 6,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: Color(0xFFD4AF37)),
        ),
      ),
      body: Column(
        children: [
          // HUD rústico superior con estilo madera colonial y repujado
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3E1C16), Color(0xFF240E0A)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF8D6E63), width: 1.5),
              boxShadow: const [
                BoxShadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 4),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Vidas con corazones
                Row(
                  children: [
                    const Text(
                      'Vidas: ',
                      style: TextStyle(
                        color: Color(0xFFFFD54F),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            index < _motor.vidas ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFFE53935),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Puntaje de calaveritas
                Row(
                  children: [
                    const Text('💀 ', style: TextStyle(fontSize: 16)),
                    Text(
                      'Puntos: ${_motor.puntaje}',
                      style: const TextStyle(
                        color: Color(0xFFFFE082),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Escenario del juego con cámara Parallax y estética colonial
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  // 1. Fondo rústico colonial de Guanajuato (Parallax, cielo, luna y siluetas)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FondoGuanajuatoPainter(camaraX: camaraX),
                    ),
                  ),

                  // 2. Faroles coloniales iluminando el callejón
                  ..._posicionesFaroles.map((fx) => Positioned(
                        left: fx - camaraX,
                        top: 215,
                        child: const FarolColonialWidget(),
                      )),

                  // 3. Meta escenográfica: El Callejón del Beso
                  Positioned(
                    left: _motor.posicionMeta - camaraX - 40,
                    top: 130,
                    child: const CallejonBesoWidget(),
                  ),

                  // 4. Plataformas de cantera rosa y piso empedrado
                  ..._motor.plataformas.map((pl) => Positioned(
                        left: pl.x - camaraX,
                        top: pl.y,
                        child: PlataformaCanteraWidget(
                          plataforma: pl,
                          esPisoPrincipal: pl.ancho >= 1000,
                        ),
                      )),

                  // 5. Calaveritas de azúcar festivas
                  ..._motor.calaveritas.where((c) => !c.recolectada).map((c) => Positioned(
                        left: c.x - camaraX,
                        top: c.y,
                        child: CalaveritaAzucarWidget(
                          ancho: c.ancho,
                          alto: c.alto,
                        ),
                      )),

                  // 6. Momias patrulleras con aura y vendas
                  ..._motor.momias.where((m) => !m.derrotada).map((m) => Positioned(
                        left: m.x - camaraX,
                        top: m.y,
                        child: MomiaWidget(
                          ancho: m.ancho,
                          alto: m.alto,
                          velocidadX: m.velocidadX,
                        ),
                      )),

                  // 7. Personaje Explorador
                  Positioned(
                    left: _motor.personaje.x - camaraX,
                    top: _motor.personaje.y,
                    child: PersonajeWidget(
                      ancho: _motor.personaje.ancho,
                      alto: _motor.personaje.alto,
                      mirandoIzquierda: _mirandoIzquierda,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Indicador de controles de teclado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF240E0A),
              border: Border(top: BorderSide(color: Color(0xFF4E2712), width: 1)),
            ),
            child: const Text(
              '🎮 Teclas: A / D o ← / → para mover  •  W / ↑ / Espacio para saltar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFFFD54F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Controles táctiles en pantalla con estilo bronce/hierro colonial
          Container(
            color: const Color(0xFF1E0A07),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _boton(
                      Icons.arrow_back,
                      'A',
                      () => _direccion = -1,
                      () => _direccion = 0,
                    ),
                    const SizedBox(width: 16),
                    _boton(
                      Icons.arrow_forward,
                      'D',
                      () => _direccion = 1,
                      () => _direccion = 0,
                    ),
                  ],
                ),
                _boton(
                  Icons.arrow_upward,
                  'Salto',
                  () => _motor.saltar(),
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _boton(
    IconData icono,
    String etiqueta,
    VoidCallback alPresionar,
    VoidCallback alSoltar,
  ) {
    return GestureDetector(
      onTapDown: (_) => alPresionar(),
      onTapUp: (_) => alSoltar(),
      onTapCancel: alSoltar,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8D5B4C), Color(0xFF3E1C16)],
          ),
          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: const Color(0xFFFFE082), size: 24),
            Text(
              etiqueta,
              style: const TextStyle(
                color: Color(0xFFFFD54F),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
