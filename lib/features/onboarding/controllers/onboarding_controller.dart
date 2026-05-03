import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/view/sign_in_screen.dart';

class OnboardingInfo {
  final String lottieAsset;
  final String title;
  final String description;

  OnboardingInfo(this.lottieAsset, this.title, this.description);
}

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  var pageController = PageController();

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
        'assets/lotties/animation.json',
        'Welcome to\nHRMS Capyngen',
        'Your all-in-one workspace to manage teams, track goals, and drive performance — all from one powerful dashboard.'
    ),

    OnboardingInfo(
        'assets/lotties/animation2.json',
        'Smart Workflows,\nReal Results',
        'Automate leave requests, expense approvals, and payroll — so you can focus on what really matters.'
    ),
    OnboardingInfo(
        'assets/lotties/animation3.json',
        'Built for Teams\nThat Move Fast',
        'From attendance to analytics, everything your HR team needs — designed for speed, clarity, and scale.'
    ),
  ];

  void forwardAction() {
    if (isLastPage) {
      Get.to(() => const SignInScreen(), transition: Transition.downToUp);
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
    }
  }

  void skipAction() {
    pageController.animateToPage(
      onboardingPages.length - 1,
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }
}