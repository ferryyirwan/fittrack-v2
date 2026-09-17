import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/glass_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../data/exercise_data.dart';
import '../../models/exercise.dart';
import '../../services/favorite_service.dart';
import '../exercise/widgets/exercise_card.dart';
import '../exercise_detail/exercise_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<List<Exercise>> _loadFavorites() async {
    final favoriteTitles =
        await FavoriteService.instance.getFavorites();

    return exerciseData.where((exercise) {
      return favoriteTitles.contains(exercise.title);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: FutureBuilder<List<Exercise>>(
            future: _loadFavorites(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final favorites = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 24,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.16),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Saved Workouts",
                                        style: context.heading3.copyWith(fontSize: 18),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "${favorites.length} Saved",
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Swipe left to remove from collection",
                                  style: context.bodyMedium.copyWith(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: favorites.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              final exercise = favorites[index];

                              return Dismissible(
                                key: ValueKey(exercise.title),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 24),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Remove",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                                onDismissed: (_) async {
                                  await FavoriteService.instance
                                      .toggleFavorite(exercise.title);

                                  setState(() {});

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${exercise.title} removed from favorites",
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: ExerciseCard(
                                    exercise: exercise,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ExerciseDetailScreen(
                                            exercise: exercise,
                                          ),
                                        ),
                                      );

                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  size: 64,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "No Saved Favorites Yet",
                style: context.heading2.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                "Build your personal workout library by tapping the heart icon on any exercise you love while browsing.",
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}