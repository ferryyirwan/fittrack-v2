import 'package:flutter/material.dart';

class ScheduleOption {
  final String title;
  final String category;
  final IconData icon;

  const ScheduleOption({
    required this.title,
    required this.category,
    required this.icon,
  });
}

const scheduleOptions = [

  ScheduleOption(
    title: "Chest Workout",
    category: "Chest",
    icon: Icons.fitness_center,
  ),

  ScheduleOption(
    title: "Back Workout",
    category: "Back",
    icon: Icons.accessibility_new,
  ),

  ScheduleOption(
    title: "Leg Workout",
    category: "Legs",
    icon: Icons.directions_run,
  ),

  ScheduleOption(
    title: "Arms Workout",
    category: "Arms",
    icon: Icons.sports_gymnastics,
  ),

  ScheduleOption(
    title: "Abs Workout",
    category: "Abs",
    icon: Icons.self_improvement,
  ),

  ScheduleOption(
    title: "Full Body",
    category: "All",
    icon: Icons.local_fire_department,
  ),

  ScheduleOption(
    title: "Rest Day",
    category: "Rest",
    icon: Icons.hotel,
  ),

];