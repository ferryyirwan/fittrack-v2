import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common/category_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/info_card.dart';
import '../../core/widgets/common/section_header.dart';
import '../exercise/exercise_screen.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_header.dart';
import 'widgets/today_workout_card.dart';

import 'widgets/recommended_workout_card.dart';
import 'widgets/workout_streak_card.dart';
import 'widgets/bmi_banner_card.dart';

import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import 'widgets/daily_tip_card.dart';
import '../bmi/bmi_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = context.watch<UserProvider>().user;

    return Scaffold(
      drawer: const HomeDrawer(),
      body: GradientBackground(
        child: SafeArea(

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                HomeHeader(
                  user: user,
                ),

                const SizedBox(height: 24),

                const TodayWorkoutCard(),

                const SizedBox(height: AppSpacing.lg),

                WorkoutStreakCard(user: user),

                const SizedBox(height: AppSpacing.md),

                BmiBannerCard(user: user),

                const SizedBox(height: AppSpacing.xl),


                SectionHeader(
                  title: "Categories",
                  actionText: "View All",
                  onActionPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExerciseScreen(
                          category: "All",
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                SizedBox(
                  height: 175,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [

                      CategoryCard(
                        title: "Chest",
                        imagePath: "assets/images/exercises/chest.jpg",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreen(
                                category: "Chest",
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: AppSpacing.md),

                      CategoryCard(
                        title: "Back",
                        imagePath: "assets/images/exercises/back.jpg",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreen(
                                category: "Back",
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: AppSpacing.md),

                      CategoryCard(
                        title: "Legs",
                        imagePath: "assets/images/exercises/legs.jpg",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreen(
                                category: "Legs",
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: AppSpacing.md),

                      CategoryCard(
                        title: "Arms",
                        imagePath: "assets/images/exercises/arms.jpg",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreen(
                                category: "Arms",
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: AppSpacing.md),

                      CategoryCard(
                        title: "Abs",
                        imagePath: "assets/images/exercises/abs.jpg",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreen(
                                category: "Abs",
                              ),
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                SectionHeader(
                  title: "Recommended",
                ),


                const SizedBox(height: AppSpacing.md),

                const RecommendedWorkoutCard(),

                const SizedBox(height: AppSpacing.xl),

                const DailyTipCard(),
              ],
            ),
          ),
        ),
      ),
    );

  }

}