import 'package:flutter/material.dart';
import 'package:splash_screen_new/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _main;
  late final AnimationController _pulse;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _ecgProgress;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _main = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
    );
    _ecgProgress = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.45, 0.75, curve: Curves.easeIn),
    );
    _taglineFade = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    );

    _main.forward().whenComplete(_goNext);
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, _, _) => const LoginPage(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _main.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00BFA5), Color(0xFF00838F), Color(0xFF006064)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Pulsing rings + logo
              SizedBox(
                width: 300,
                height: 300,
                child: AnimatedBuilder(
                  animation: Listenable.merge([_main, _pulse]),
                  builder: (context, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        for (int i = 0; i < 2; i++) _ring((_pulse.value + i * 0.5) % 1),
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.medical_services_rounded,
                                size: 68,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Heartbeat line
              AnimatedBuilder(
                animation: _ecgProgress,
                builder: (context, _) => SizedBox(
                  width: 220,
                  height: 50,
                  child: CustomPaint(
                    painter: _EcgPainter(_ecgProgress.value),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Title
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleFade,
                  child: const Text(
                    'Patient Care',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tagline
              FadeTransition(
                opacity: _taglineFade,
                child: Text(
                  'Caring made simple',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.5,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Loading bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: AnimatedBuilder(
                  animation: _main,
                  builder: (context, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _main.value,
                      minHeight: 5,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ring(double t) {
    final size = 130 + 160 * t;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity((1 - t) * 0.5),
          width: 2,
        ),
      ),
    );
  }
}

class _EcgPainter extends CustomPainter {
  final double progress;
  _EcgPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, h * 0.5)
      ..lineTo(w * 0.30, h * 0.5)
      ..lineTo(w * 0.36, h * 0.35)
      ..lineTo(w * 0.42, h * 0.5)
      ..lineTo(w * 0.47, h * 0.5)
      ..lineTo(w * 0.52, h * 0.95)
      ..lineTo(w * 0.58, h * 0.0)
      ..lineTo(w * 0.64, h * 0.5)
      ..lineTo(w * 0.72, h * 0.5)
      ..lineTo(w * 0.78, h * 0.4)
      ..lineTo(w * 0.84, h * 0.5)
      ..lineTo(w, h * 0.5);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EcgPainter old) => old.progress != progress;
}