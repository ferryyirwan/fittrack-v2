class WorkoutOfDay {
  static const List<Map<String, String>> weeklyWorkout = [
    {
      "title": "Chest Workout",
      "category": "Chest",
      "image": "assets/images/exercises/chest.jpg",
    },
    {
      "title": "Leg Workout",
      "category": "Legs",
      "image": "assets/images/exercises/legs.jpg",
    },
    {
      "title": "Abs & Core Workout",
      "category": "Abs",
      "image": "assets/images/exercises/abs.jpg",
    },
    {
      "title": "Back Workout",
      "category": "Back",
      "image": "assets/images/exercises/back.jpg",
    },
    {
      "title": "Arms Workout",
      "category": "Arms",
      "image": "assets/images/exercises/arms.jpg",
    },
    {
      "title": "Full Body Blast",
      "category": "All",
      "image": "assets/images/exercises/chest.jpg",
    },
    {
      "title": "Active Recovery",
      "category": "Rest",
      "image": "assets/images/exercises/back.jpg",
    },
  ];

  static Map<String, String> today() {
    final index = DateTime.now().weekday - 1;
    return weeklyWorkout[index];
  }
}