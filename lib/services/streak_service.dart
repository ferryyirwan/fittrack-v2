import 'package:firebase_auth/firebase_auth.dart';

import 'user_service.dart';

class StreakService {
  StreakService._();

  static final StreakService instance = StreakService._();

  Future<void> completeWorkout() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final user = await UserService.instance.getUser(uid);

    if (user == null) return;

    final today = DateTime.now();

    final todayDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final lastWorkout = user.lastWorkoutDate;

    int streak = user.workoutStreak;

    if (lastWorkout == null) {
      streak = 1;
    } else {
      final lastDate = DateTime(
        lastWorkout.year,
        lastWorkout.month,
        lastWorkout.day,
      );

      final difference =
          todayDate.difference(lastDate).inDays;

      if (difference == 0) {
        // Already completed today
        return;
      } else if (difference == 1) {
        streak++;
      } else {
        streak = 1;
      }
    }

    await UserService.instance.updateWorkoutStreak(
      streak: streak,
      lastWorkoutDate: todayDate,
    );
  }
}