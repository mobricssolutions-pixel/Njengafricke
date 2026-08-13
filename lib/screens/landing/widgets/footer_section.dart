import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/login_screen.dart';

class FooterSection extends StatelessWidget {
  final VoidCallback onContact;

  const FooterSection({
    super.key,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.public,
            color: AppColors.yellow,
            size: 48,
          ),

          const SizedBox(height: 16),

          const Text(
            "Njengafricke",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Build Kenya, Build Africa Together",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.support_agent),
              label: const Text("Contact Us"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text("Login"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.yellow,
                side: const BorderSide(
                  color: AppColors.yellow,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Divider(),

          const SizedBox(height: 15),

          const Text(
            "© 2026 Njengafricke\n"
            "Empowering Kenyan and African builders through innovation, collaboration and opportunity.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}