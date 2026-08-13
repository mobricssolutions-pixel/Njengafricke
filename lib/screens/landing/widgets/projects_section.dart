import 'package:flutter/material.dart';
import '../../projects/projects_screen.dart';
import '../../../core/services/project_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import 'database_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.rocket_launch,
                color: AppColors.yellow,
              ),
              SizedBox(width: 10),
              Text(
                "Projects",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          FutureBuilder<List<dynamic>>(
            future: ProjectService.getProjects(),
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const SizedBox(
                  height: 210,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Error
              if (snapshot.hasError) {
                return SizedBox(
                  height: 210,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        ErrorHandler.getMessage(snapshot.error),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final projects = snapshot.data ?? [];

              // Empty state
              if (projects.isEmpty) {
                return const SizedBox(
                  height: 210,
                  child: Center(
                    child: Text(
                      "No projects available.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }

              // Success
              return SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: projects.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return DatabaseCard(
                      icon: Icons.rocket_launch,
                      title: project.data["title"] ?? "Untitled",
                      description:
                          project.data["description"] ?? "",
                      onView: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ProjectsScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}