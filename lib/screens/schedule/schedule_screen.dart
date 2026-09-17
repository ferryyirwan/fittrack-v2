import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/glass_card.dart';

import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/section_header.dart';
import '../../data/exercise_data.dart';
import '../../data/workout_schedule_data.dart';
import '../exercise_detail/exercise_detail_screen.dart';
import '../exercise/widgets/exercise_card.dart';
import 'widgets/schedule_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showFullMonth = false;

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  String _getShortDayName(int weekday) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }

  List<DateTime> _getWeekDays(DateTime current) {
    final monday = current.subtract(Duration(days: current.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final schedules = workoutScheduleData;
    final selectedWeekdayIndex = _selectedDate.weekday - 1;
    final selectedSchedule = schedules[selectedWeekdayIndex];

    final filteredExercises = exerciseData.where((ex) {
      if (selectedSchedule.category == "All") return true;
      if (selectedSchedule.category == "Rest") return false;
      return ex.category.toLowerCase() == selectedSchedule.category.toLowerCase();
    }).toList();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                            style: context.heading2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Tap any date to view planned workouts",
                            style: context.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showFullMonth = !_showFullMonth;
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(
                        _showFullMonth
                            ? Icons.calendar_view_week_rounded
                            : Icons.calendar_month_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedCrossFade(
                firstChild: _buildWeeklyStrip(),
                secondChild: _buildMonthlyGrid(),
                crossFadeState: _showFullMonth
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Planned for ${_getShortDayName(_selectedDate.weekday)}, ${_getMonthName(_selectedDate.month)} ${_selectedDate.day}",
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      ScheduleCard(
                        schedule: selectedSchedule,
                        isSelected: true,
                        onTap: () {},
                      ),

                      const SizedBox(height: 24),

                      if (selectedSchedule.category == "Rest") ...[
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.self_improvement_rounded,
                                  size: 46,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Recovery & Wellness Day",
                                style: context.heading3,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Today is dedicated to muscle recovery and rejuvenation. Adequate rest allows your muscle fibers to rebuild stronger.",
                                textAlign: TextAlign.center,
                                style: context.bodyMedium.copyWith(height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _buildRecoveryChip(Icons.water_drop_rounded, "Hydrate 3L"),
                                  _buildRecoveryChip(Icons.bedtime_rounded, "8 Hrs Sleep"),
                                  _buildRecoveryChip(Icons.spa_rounded, "Stretching"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[

                        SectionHeader(
                          title: "Recommended Exercises (${filteredExercises.length})",
                        ),
                        const SizedBox(height: 14),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredExercises.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final exercise = filteredExercises[index];
                            return ExerciseCard(
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
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStrip() {
    final weekDays = _getWeekDays(_selectedDate);

    return SizedBox(
      height: 95,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = weekDays[index];
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;
          final isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
                      )
                    : null,
                color: isSelected ? null : context.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : isToday
                          ? AppColors.primary
                          : context.borderColor,
                  width: isToday ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getShortDayName(date.weekday),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : context.textSecondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${date.day}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : context.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white
                          : workoutScheduleData[date.weekday - 1].category == "Rest"
                              ? Colors.blueAccent
                              : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthlyGrid() {
    final daysInMonth = _getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final leadingSpaces = firstDayOfMonth.weekday - 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                .map((d) => SizedBox(
                      width: 36,
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            color: context.textSecondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingSpaces + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              if (index < leadingSpaces) {
                return const SizedBox();
              }
              final dayNum = index - leadingSpaces + 1;
              final date = DateTime(_selectedDate.year, _selectedDate.month, dayNum);
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : context.isDark
                            ? Colors.white.withOpacity(0.04)
                            : Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "$dayNum",
                      style: TextStyle(
                        color: isSelected ? Colors.white : context.textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}