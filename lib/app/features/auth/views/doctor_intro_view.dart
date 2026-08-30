import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class DoctorIntroView extends StatefulWidget {
  const DoctorIntroView({super.key});

  @override
  State<DoctorIntroView> createState() => _DoctorIntroViewState();
}

class _DoctorIntroViewState extends State<DoctorIntroView>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _textController;
  late AnimationController _shimmerController;

  late Animation<double> _doctorSlideY;
  late Animation<double> _doctorFade;
  late Animation<double> _doctorScale;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _shimmerAnim;

  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _badgeFade;
  late Animation<double> _buttonScale;
  late Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Doctor slides UP from bottom with elastic bounce
    _doctorSlideY = Tween<double>(begin: 600.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    _doctorFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _doctorScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );

    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Text animations
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );

    // Start animations
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
    _shimmerController.repeat();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _textController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => Get.offAllNamed(AppRoutes.login),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF14532D),
          child: Stack(
            children: [
              // Background particles
              ...List.generate(
                12,
                (i) => _buildParticle(i, size),
              ),

              // Background circular patterns
              _buildCircleDecor(size, 0.1, -0.1, 200, 0.05),
              _buildCircleDecor(size, 0.8, 0.2, 150, 0.04),
              _buildCircleDecor(size, 0.3, 0.85, 120, 0.06),

              // Glowing rings behind doctor
              Positioned(
                top: size.height * 0.06,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, _) {
                    return Center(
                      child: Container(
                        width: 320 * _pulseAnim.value,
                        height: 320 * _pulseAnim.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent.withValues(alpha: 0.08),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Doctor image with entrance animation
              Positioned(
                top: size.height * 0.03,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: Listenable.merge([_mainController, _floatController]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _doctorSlideY.value + _floatAnim.value),
                      child: Opacity(
                        opacity: _doctorFade.value,
                        child: Transform.scale(
                          scale: _doctorScale.value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _buildDoctorSection(size),
                ),
              ),

              // Top medical icons
              Positioned(
                top: 45,
                left: 25,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: 0.15 + (_pulseAnim.value - 0.9) * 1.5,
                      child: const Icon(Icons.add, color: Colors.white, size: 28),
                    );
                  },
                ),
              ),
              Positioned(
                top: 55,
                right: 25,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: 0.2 + (_pulseAnim.value - 0.9) * 1.2,
                      child: const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                    );
                  },
                ),
              ),

              // Bottom text content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 50, 24, 45),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _titleSlide,
                            child: FadeTransition(
                              opacity: _titleFade,
                              child: child,
                            ),
                          );
                        },
                        child: const Text(
                          'Votre Santé,\nNotre Priorité',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Subtitle
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _subtitleSlide,
                            child: FadeTransition(
                              opacity: _subtitleFade,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          'Des médecins qualifiés à portée de main.\nPrenez rendez-vous en quelques clics.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Badge
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _badgeFade,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, color: Colors.greenAccent, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Médecins certifiés • 24/7',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Button
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _buttonFade,
                            child: ScaleTransition(
                              scale: _buttonScale,
                              child: child,
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () => Get.offAllNamed(AppRoutes.login),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 25,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Découvrir',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: AppColors.primaryDark,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return FadeTransition(opacity: _badgeFade, child: child);
                        },
                        child: Text(
                          'Appuyez pour continuer',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Progress dots
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    return FadeTransition(opacity: _doctorFade, child: child);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(true),
                      const SizedBox(width: 8),
                      _buildDot(false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Doctor image section ----
  Widget _buildDoctorSection(Size size) {
    return Center(
      child: SizedBox(
        height: size.height * 0.52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing ring
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                return Container(
                  width: 270 * _pulseAnim.value,
                  height: 270 * _pulseAnim.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
            // Inner glow ring
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.15),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
            ),

            // Doctor photo
            Container(
              width: 230,
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(115),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 35,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.1),
                    blurRadius: 60,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(115),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'lib/app/public/assets/images/doctor_intro.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withValues(alpha: 0.15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_services_rounded,
                                size: 70,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: 10),
                              Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Shimmer overlay
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, _) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.15),
                                Colors.transparent,
                              ],
                              stops: [
                                (_shimmerAnim.value - 0.3).clamp(0.0, 1.0),
                                _shimmerAnim.value.clamp(0.0, 1.0),
                                (_shimmerAnim.value + 0.3).clamp(0.0, 1.0),
                              ],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Container(color: Colors.white.withValues(alpha: 0.08)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Floating stethoscope badge
            Positioned(
              right: size.width * 0.15,
              top: 30,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnim.value * 0.8),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: Colors.greenAccent,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Floating heart badge
            Positioned(
              left: size.width * 0.12,
              bottom: 60,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_floatAnim.value * 0.6),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Floating background particles ----
  Widget _buildParticle(int index, Size size) {
    final rng = Random(index * 42);
    final startX = rng.nextDouble() * size.width;
    final startY = rng.nextDouble() * size.height;
    final pSize = 3.0 + rng.nextDouble() * 7;
    final delay = rng.nextDouble();

    const icons = [
      Icons.add,
      Icons.favorite_border,
      Icons.medical_services_outlined,
      Icons.health_and_safety_outlined,
      Icons.local_hospital_outlined,
    ];

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, _) {
        final t = (_floatController.value + delay) % 1.0;
        final y = startY + sin(t * pi * 2) * 15;
        final x = startX + cos(t * pi * 2) * 8;
        final opacity = (0.08 + sin(t * pi) * 0.12).clamp(0.0, 0.2);

        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              icons[index % icons.length],
              size: pSize,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  // ---- Background circle decoration ----
  Widget _buildCircleDecor(Size size, double px, double py, double radius, double alpha) {
    return Positioned(
      left: size.width * px - radius / 2,
      top: size.height * py - radius / 2,
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: alpha),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ---- Progress dot ----
  Widget _buildDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: active ? Colors.white : Colors.white.withValues(alpha: 0.35),
      ),
    );
  }
}
