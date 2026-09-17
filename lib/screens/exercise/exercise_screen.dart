import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/app_search_bar.dart';
import '../../core/widgets/common/custom_back_button.dart';
import '../../core/widgets/common/glass_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/section_header.dart';
import '../../data/exercise_data.dart';
import '../exercise_detail/exercise_detail_screen.dart';
import 'widgets/exercise_card.dart';
import 'widgets/muscle_filter.dart';

class ExerciseScreen extends StatefulWidget {
  final String category;
  final bool showBackButton;

  const ExerciseScreen({
    super.key,
    required this.category,
    this.showBackButton = true,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late String selectedCategory;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  String selectedSortOrder = "Default";

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
  }

  void _showSortBottomSheet() {
    final sortOptions = [
      "Default",
      "A - Z",
      "Beginner First",
      "Advanced First",
      "Highest Calories",
      "Shortest Duration",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bsContext) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(bsContext).padding.bottom),
          decoration: BoxDecoration(
            color: context.isDark ? const Color(0xFF1B1B1F) : const Color(0xFFF6F6F9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border.all(color: context.borderColor),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Sort Exercises By",
                        style: context.heading2.copyWith(fontSize: 19),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (selectedSortOrder != "Default")
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSortOrder = "Default";
                          });
                          Navigator.pop(bsContext);
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ...sortOptions.map((option) {
                  final isSelected = selectedSortOrder == option;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedSortOrder = option;
                        });
                        Navigator.pop(bsContext);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.15)
                              : context.isDark
                                  ? Colors.white.withOpacity(0.03)
                                  : Colors.grey.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primary : context.textColor,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises = exerciseData.where((exercise) {
      final matchesCategory =
          selectedCategory == "All" || exercise.category == selectedCategory;

      final matchesSearch =
          exercise.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              exercise.category
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              exercise.level.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    if (selectedSortOrder == "A - Z") {
      filteredExercises.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSortOrder == "Beginner First") {
      int getLevelWeight(String level) {
        if (level.toLowerCase().contains("begin")) return 1;
        if (level.toLowerCase().contains("inter")) return 2;
        return 3;
      }
      filteredExercises.sort((a, b) => getLevelWeight(a.level).compareTo(getLevelWeight(b.level)));
    } else if (selectedSortOrder == "Advanced First") {
      int getLevelWeight(String level) {
        if (level.toLowerCase().contains("begin")) return 1;
        if (level.toLowerCase().contains("inter")) return 2;
        return 3;
      }
      filteredExercises.sort((a, b) => getLevelWeight(b.level).compareTo(getLevelWeight(a.level)));
    } else if (selectedSortOrder == "Highest Calories") {
      int parseCal(String cal) {
        final nums = RegExp(r'\d+').allMatches(cal).map((m) => int.tryParse(m.group(0)!) ?? 0);
        return nums.isNotEmpty ? nums.first : 0;
      }
      filteredExercises.sort((a, b) => parseCal(b.calories).compareTo(parseCal(a.calories)));
    } else if (selectedSortOrder == "Shortest Duration") {
      int parseDur(String dur) {
        final nums = RegExp(r'\d+').allMatches(dur).map((m) => int.tryParse(m.group(0)!) ?? 0);
        return nums.isNotEmpty ? nums.first : 0;
      }
      filteredExercises.sort((a, b) => parseDur(a.duration).compareTo(parseDur(b.duration)));
    }

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    if (widget.showBackButton) const CustomBackButton(),
                    if (widget.showBackButton)
                      const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SectionHeader(
                        title: selectedCategory == "All"
                            ? "All Exercises"
                            : "$selectedCategory Exercises",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// HERO BANNER
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  borderRadius: 22,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Workout Library",
                              style: context.heading3.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Discover ${exerciseData.length}+ targeted exercises for every fitness level & goal.",
                              style: context.bodyMedium.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// SEARCH & SORT BAR
                AppSearchBar(
                  hintText: "Search exercises, target muscle or level...",
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  showClearButton: searchQuery.isNotEmpty,
                  onClear: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = "";
                    });
                  },
                  onFilterPressed: _showSortBottomSheet,
                ),

                if (selectedSortOrder != "Default") ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.sort_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        "Sorted by: $selectedSortOrder",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => selectedSortOrder = "Default"),
                        child: const Text(
                          "Clear Sort",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                /// CATEGORY FILTER
                MuscleFilter(
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),

                const SizedBox(height: 24),

                /// EXERCISE LIST
                filteredExercises.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: GlassCard(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: AppColors.primary.withOpacity(0.6),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  "No Exercises Found",
                                  style: context.heading3,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "We couldn't find any workout matching '$searchQuery'. Try adjusting your filter or search terms.",
                                  textAlign: TextAlign.center,
                                  style: context.bodyMedium.copyWith(height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: filteredExercises.map((exercise) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: ExerciseCard(
                              exercise: exercise,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ExerciseDetailScreen(
                                      exercise: exercise,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
