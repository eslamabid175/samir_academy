import 'package:flutter/material.dart';
import 'package:samir_academy/presentation/pages/pre_home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../presentation/pages/home_page.dart';
import '../widgets/onboarding_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to E-Learning',
      'description': 'Learn anytime, anywhere with our interactive courses.',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Personalized Learning',
      'description': 'Get courses tailored to your interests and goals.',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'Join the Community',
      'description': 'Connect with learners and experts worldwide.',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  const PreHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingItem(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                imagePath: onboardingData[index]['image']!,
              );
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardingData.length,
              effect: const WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () => _completeOnboarding(context),
              child: const Text('Skip', style: TextStyle(color: Colors.blue)),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < onboardingData.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  _completeOnboarding(context);
                }
              },
              child: Text(_currentPage < onboardingData.length - 1 ? 'Next' : 'Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}