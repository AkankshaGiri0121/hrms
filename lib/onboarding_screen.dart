import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_controller.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController _controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

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
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- Page View Content ---
              Expanded(
                child: PageView.builder(
                  controller: _controller.pageController,
                  onPageChanged: _controller.selectedPageIndex,
                  itemCount: _controller.onboardingPages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Lottie.asset(
                            _controller.onboardingPages[index].lottieAsset,
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          _controller.onboardingPages[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            _controller.onboardingPages[index].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // --- Page Indicators (Dots) ---
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _controller.onboardingPages.length,
                        (index) => Obx(() {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _controller.selectedPageIndex.value == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _controller.selectedPageIndex.value == index
                              ? const Color(0xFF8C52FF)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // --- Dynamic Buttons ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                child: Obx(() {
                  return Column(
                    children: [
                      // SIGN IN / NEXT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8C52FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: _controller.isLastPage
                              ? () {
                            // Last page pe Sign In BottomSheet open hoga
                            Get.bottomSheet(
                              const SignInScreen(),
                              isScrollControlled: true,
                            );
                          }
                              : _controller.forwardAction,
                          child: Text(
                            _controller.isLastPage ? 'Sign In' : 'Next',
                            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // SIGN UP / SKIP BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8C52FF), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: _controller.isLastPage
                              ? () {
                            // Last page pe Sign Up naye page pe khulega
                            Get.to(() => const SignUpScreen(), transition: Transition.rightToLeft);
                          }
                              : _controller.skipAction, // Corrected to skipAction
                          child: Text(
                            _controller.isLastPage ? 'Sign Up' : 'Skip',
                            style: const TextStyle(fontSize: 16, color: Color(0xFF8C52FF), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}