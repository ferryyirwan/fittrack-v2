class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String gender;
  final DateTime? dateOfBirth;
  final DateTime? lastWorkoutDate;
  final double height;
  final double weight;
  final String profileImageUrl;
  final int workoutStreak;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.gender,
    this.dateOfBirth,
    this.lastWorkoutDate,
    required this.height,
    required this.weight,
    this.profileImageUrl = "",
    required this.workoutStreak,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      "lastWorkoutDate":
      lastWorkoutDate?.toIso8601String(),
      'height': height,
      'weight': weight,
      'workoutStreak': workoutStreak,
      'createdAt': createdAt.toIso8601String(),
      "profileImageUrl": profileImageUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.tryParse(map['dateOfBirth'])
          : null,
      lastWorkoutDate:
      map["lastWorkoutDate"] != null
          ? DateTime.tryParse(
        map["lastWorkoutDate"],
      )
          : null,
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      workoutStreak: map['workoutStreak'] ?? 0,
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
      profileImageUrl:
      map["profileImageUrl"] ?? "",
    );
  }

  AppUser copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    DateTime? lastWorkoutDate,
    double? height,
    double? weight,
    String? profileImageUrl,
    int? workoutStreak,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      workoutStreak: workoutStreak ?? this.workoutStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get bmi {
    if (height <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }
  int get calculatedAge {
    if (dateOfBirth == null) return 0;

    final today = DateTime.now();

    int age = today.year - dateOfBirth!.year;

    if (
    today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month &&
            today.day < dateOfBirth!.day)
    ) {
      age--;
    }

    return age;
  }
}