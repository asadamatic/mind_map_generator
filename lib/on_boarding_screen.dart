import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_map_generator/ListViews/mind_maps_list_screen.dart';
import 'package:sk_onboarding_screen/flutter_onboarding.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final Function selectScreen;
  OnboardingScreen({this.selectScreen});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pages = [
    SkOnboardingModel(
        title: 'Highlight Your Documents',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/highlighted_document.png'),
    SkOnboardingModel(
        title: 'Scan The Documents',
        description:
        'We make ordering fast, simple and free-no matter if you order online or cash',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/scan_doc.png'),
    SkOnboardingModel(
        title: "Auto-Generate MindMaps",
        description: 'Pay for order using credit or debit card',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/mind_map.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return SKOnboardingScreen(
      bgColor: Colors.white,
      themeColor: Theme.of(context).primaryColor,
      pages: pages,
      skipClicked: (value) {
        widget.selectScreen();
      },

      getStartedClicked: (value) {
        widget.selectScreen();
      },
    );
  }
}
