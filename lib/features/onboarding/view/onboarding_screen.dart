import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/utils/responsive.dart';
import '../controllers/onboarding_controller.dart';
import '../../auth/view/sign_in_screen.dart';
import '../../auth/view/sign_up_screen.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController _controller = Get.put(OnboardingController());
  late AnimationController _entryAnim;

  @override
  void initState() {
    super.initState();
    _entryAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Re-trigger text animations on page change
    _controller.selectedPageIndex.listen((_) {
      _entryAnim.reset();
      _entryAnim.forward();
    });
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) {
    final delay = (index * 0.12).clamp(0.0, 0.6);
    final end = (delay + 0.5).clamp(0.0, 1.0);
    final slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryAnim, curve: Interval(delay, end, curve: Curves.easeOutCubic)),
    );
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryAnim, curve: Interval(delay, end, curve: Curves.easeOut)),
    );
    return AnimatedBuilder(
      animation: _entryAnim,
      builder: (context, _) => Opacity(
        opacity: fade.value,
        child: SlideTransition(position: slide, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8C52FF),
              Color(0xFFB47CFF),
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button top right
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(20),
                  vertical: Responsive.h(8),
                ),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_controller.isLastPage)
                      GestureDetector(
                        onTap: _controller.skipAction,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.w(16),
                            vertical: Responsive.h(8),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(Responsive.r(20)),
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
              ),

              // --- Page View Content ---
              Expanded(
                child: PageView.builder(
                  controller: _controller.pageController,
                  onPageChanged: _controller.selectedPageIndex,
                  itemCount: _controller.onboardingPages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Lottie animation with glow
                          _staggered(0, Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8C52FF).withValues(alpha: 0.15),
                                  blurRadius: 60,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                            child: Lottie.asset(
                              _controller.onboardingPages[index].lottieAsset,
                              height: Responsive.h(260), // slightly smaller Lottie to make room for bigger text
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: Responsive.w(100),
                                color: Colors.grey,
                              ),
                            ),
                          )),
                          SizedBox(height: Responsive.h(32)),

                          // Title
                          _staggered(1, Text(
                            _controller.onboardingPages[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Responsive.sp(28), // Bigger title
                              fontWeight: FontWeight.w900, // Thicker font
                              color: Colors.black87,
                              height: 1.2,
                              letterSpacing: -0.5, // Premium tight tracking
                            ),
                          )),
                          SizedBox(height: Responsive.h(16)),

                          // Description
                          _staggered(2, Text(
                            _controller.onboardingPages[index].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Responsive.sp(15),
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          )),
                          SizedBox(height: Responsive.h(24)), // fixed gap before dots
                        ],
                      ),
                    );
                  },
                ),
              ),

              // --- Page Indicators ---
              Padding(
                padding: EdgeInsets.only(bottom: Responsive.h(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _controller.onboardingPages.length,
                    (index) => Obx(() {
                      final isActive = _controller.selectedPageIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(horizontal: Responsive.w(4)),
                        width: isActive ? Responsive.w(28) : Responsive.w(8),
                        height: Responsive.h(8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF8C52FF)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(Responsive.r(4)),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // --- Action Buttons ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(32),
                  vertical: Responsive.h(16),
                ),
                child: Obx(() {
                  return Column(
                    children: [
                      // Primary button
                      SizedBox(
                        width: double.infinity,
                        height: Responsive.h(54),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8C52FF),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: const Color(0xFF8C52FF).withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Responsive.r(16)),
                            ),
                          ),
                          onPressed: _controller.isLastPage
                              ? () {
                                  Get.bottomSheet(
                                    const SignInScreen(),
                                    isScrollControlled: true,
                                  );
                                }
                              : _controller.forwardAction,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _controller.isLastPage ? 'Sign In' : 'Continue',
                                style: TextStyle(
                                  fontSize: Responsive.sp(16),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (!_controller.isLastPage) ...[
                                SizedBox(width: Responsive.w(8)),
                                Icon(Icons.arrow_forward_rounded, size: Responsive.w(18)),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.h(14)),

                      // Secondary button
                      SizedBox(
                        width: double.infinity,
                        height: Responsive.h(54),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFF8C52FF),
                              width: Responsive.w(1.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Responsive.r(16)),
                            ),
                          ),
                          onPressed: _controller.isLastPage
                              ? () {
                                  Get.to(() => const SignUpScreen(),
                                      transition: Transition.rightToLeft,
                                      duration: const Duration(milliseconds: 400));
                                }
                              : _controller.skipAction,
                          child: Text(
                            _controller.isLastPage ? 'Create Workspace' : 'Skip',
                            style: TextStyle(
                              fontSize: Responsive.sp(16),
                              color: const Color(0xFF8C52FF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: Responsive.h(8)),
            ],
          ),
        ),
      ),
    );
  }
}