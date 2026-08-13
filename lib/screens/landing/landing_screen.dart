import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';

import 'widgets/hero_section.dart';
import 'widgets/builder_mindset_section.dart';
import 'widgets/fundraiser_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/opportunities_section.dart';
import 'widgets/features_section.dart';
import 'widgets/footer_section.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() =>
      _LandingScreenState();
}

class _LandingScreenState
    extends State<LandingScreen>
    with TickerProviderStateMixin {

  // =====================================================
  // BUILDER MINDSET QUOTES
  // =====================================================

  static const List<String> motivations = [

    "Kenya does not lack talent. It lacks organized builders.",

    "The future belongs to people who execute.",

    "A dream without execution becomes regret.",

    "You are one skill away from changing your future.",

    "Build solutions. Opportunities will follow.",

    "Communities grow when builders work together.",

    "Discipline creates opportunities that motivation cannot.",
  ];

  int currentMotivation = 0;

  late Timer motivationTimer;

  late AnimationController glowController;

  late Animation<double> glowAnimation;

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(glowController);

    motivationTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {

        if (!mounted) return;

        setState(() {

          currentMotivation++;

          if (currentMotivation >=
              motivations.length) {
            currentMotivation = 0;
          }
        });
      },
    );
  }

  Future<void> openWhatsApp() async {

    final uri = Uri.parse(
      "https://wa.me/254799480784",
    );

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode:
            LaunchMode.externalApplication,
      );
    }
  }

  @override
  void dispose() {

    motivationTimer.cancel();

    glowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              HeroSection(
                glowAnimation:
                    glowAnimation,
              ),

              const SizedBox(height: 30),

              BuilderMindsetSection(
                quote:
                    motivations[currentMotivation],
              ),

              const SizedBox(height: 35),

              const FundraiserSection(),

              const SizedBox(height: 24),

              const ProjectsSection(),

              const SizedBox(height: 24),

              const OpportunitiesSection(),

              const SizedBox(height: 35),

              const FeaturesSection(),

              const SizedBox(height: 40),

              FooterSection(
                onContact: openWhatsApp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}