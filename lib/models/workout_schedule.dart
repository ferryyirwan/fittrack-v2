import 'package:flutter/material.dart';

class WorkoutSchedule {
  final String day;
  final String title;
  final String category;
  final IconData icon;

  const WorkoutSchedule({
    required this.day,
    required this.title,
    required this.category,
    required this.icon,
  });
}