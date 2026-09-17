import 'package:flutter/material.dart';

import '../models/workout_schedule.dart';

const workoutScheduleData = [

  WorkoutSchedule(
    day: "Monday",
    title: "Chest Workout",
    category: "Chest",
    icon: Icons.fitness_center,
  ),

  WorkoutSchedule(
    day: "Tuesday",
    title: "Leg Workout",
    category: "Legs",
    icon: Icons.directions_run,
  ),

  WorkoutSchedule(
    day: "Wednesday",
    title: "Abs & Core Workout",
    category: "Abs",
    icon: Icons.shield_rounded,
  ),

  WorkoutSchedule(
    day: "Thursday",
    title: "Back Workout",
    category: "Back",
    icon: Icons.accessibility_new,
  ),

  WorkoutSchedule(
    day: "Friday",
    title: "Arms Workout",
    category: "Arms",
    icon: Icons.sports_gymnastics,
  ),

  WorkoutSchedule(
    day: "Saturday",
    title: "Full Body Blast",
    category: "All",
    icon: Icons.local_fire_department,
  ),

  WorkoutSchedule(
    day: "Sunday",
    title: "Active Recovery",
    category: "Rest",
    icon: Icons.self_improvement,
  ),

];