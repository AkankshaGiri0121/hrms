import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../onboarding/view/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _taglineSlide;
  late Animation<double> _taglineFade;
  late Animation<double> _loaderFade;
  late Animation<double> _glowScale;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Logo: scale + fade in (0% - 40%)
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.4, curve: Curves.elasticOut)),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.25, curve: Curves.easeOut)),
    );

    // Glow behind logo
    _glowScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.15, 0.5, curve: Curves.easeOut)),
    );

    // Title: slide up + fade (30% - 60%)
    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic)),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.3, 0.55, curve: Curves.easeOut)),
    );

    // Tagline: slide up + fade (50% - 75%)
    _taglineSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.5, 0.75, curve: Curves.easeOutCubic)),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.5, 0.7, curve: Curves.easeOut)),
    );

    // Loader: fade in (70% - 90%)
    _loaderFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.7, 0.9, curve: Curves.easeOut)),
    );

    _mainController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
        () => OnboardingScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A12) : Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _pulseController]),
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    Transform.scale(
                      scale: _glowScale.value * (0.95 + 0.05 * _pulseController.value),
                      child: Container(
                        width: Responsive.w(160),
                        height: Responsive.w(160),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.15),
                              AppColors.primary.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Logo
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoFade.value,
                        child: Container(
                          padding: EdgeInsets.all(Responsive.w(20)),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : AppColors.primary.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            'assets/logo.png',
                            width: Responsive.w(100),
                            height: Responsive.w(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(36)),
                // Title
                Transform.translate(
                  offset: Offset(0, _titleSlide.value),
                  child: Opacity(
                    opacity: _titleFade.value,
                    child: Text(
                      'HRMS Capyngen',
                      style: TextStyle(
                        fontSize: Responsive.sp(28),
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(10)),
                // Tagline
                Transform.translate(
                  offset: Offset(0, _taglineSlide.value),
                  child: Opacity(
                    opacity: _taglineFade.value,
                    child: Text(
                      'EXCELLENCE IN ENTERPRISE',
                      style: TextStyle(
                        fontSize: Responsive.sp(11),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.grey.shade500,
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(48)),
                // Loading dots
                Opacity(
                  opacity: _loaderFade.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, _) {
                          final delay = i * 0.3;
                          final val = ((_pulseController.value - delay) % 1.0).clamp(0.0, 1.0);
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: Responsive.w(4)),
                            width: Responsive.w(8),
                            height: Responsive.w(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.3 + 0.7 * val),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
