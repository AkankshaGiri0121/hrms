import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_in_screen.dart';

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
        'Welcome to Workmate!',
        'Make smart decisions and set clear timelines for projects and celebrate your achievements!'
    ),
    OnboardingInfo(
        'assets/lotties/animation.json',
        'Manage Stress Effectively',
        'Stay balanced! Track your workload and maintain a healthy stress level with ease.'
    ),
    OnboardingInfo(
        'assets/lotties/animation.json',
        'Plan for Success',
        'Your journey starts here! Earn achievement badges as you conquer your tasks. Let\'s get started!'
    ),
    OnboardingInfo(
        'assets/lotties/animation.json',
        'Navigate Your Work Journey\nEfficient & Easy',
        'Increase your work management & career development radically.'
    ),
  ];

  void forwardAction() {
    if (isLastPage) {
      Get.to(() => const SignInScreen(), transition: Transition.downToUp);
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void skipAction() {
    pageController.jumpToPage(onboardingPages.length - 1);
  }
}