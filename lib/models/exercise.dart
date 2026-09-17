class Exercise {
  final String title;
  final String category;
  final String level;
  final String duration;
  final String calories;
  final String image;
  final String description;
  final List<String> instructions;

  final int workSeconds;
  final int restSeconds;

  const Exercise({
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.calories,
    required this.image,
    required this.description,
    required this.instructions,

    required this.workSeconds,
    required this.restSeconds,
  });
}