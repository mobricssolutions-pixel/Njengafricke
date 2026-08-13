import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/login_screen.dart';

class HeroSection extends StatelessWidget {
  final Animation<double> glowAnimation;
  final VoidCallback? onExploreGuest;

  const HeroSection({
    super.key,
    required this.glowAnimation,
    this.onExploreGuest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            AppColors.maroon,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 35),

          AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius:
                      BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellow
                          .withOpacity(
                              glowAnimation.value),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Text(
                  "KENYA AND AFRICA RISING",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          const Text(
            "Njengafricke",
            style: TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Build Kenya, Build Africa Together",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 36,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Discover opportunities, projects, fundraising campaigns and AI-powered guidance built for Kenya and Africa.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 17,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.yellow,
                foregroundColor:
                    Colors.black,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 18,
                ),
              ),
              child: const Text(
                "Login / Register",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}