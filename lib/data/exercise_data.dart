import '../models/exercise.dart';

final List<Exercise> exerciseData = [

// ==========================
// CHEST
// ==========================

Exercise(
title: "Push Up",
category: "Chest",
level: "Beginner",
duration: "12 mins",
calories: "120 kcal",
image: "assets/images/exercises/push_up.jpg",
description:
"The push-up is a classic bodyweight exercise that strengthens the chest, shoulders, triceps, and core while improving upper-body endurance.",
instructions: [
"Place your hands slightly wider than shoulder-width apart.",
"Keep your body straight from head to heels.",
"Lower your chest until it is close to the floor.",
"Push yourself back to the starting position.",
],
  workSeconds: 45,
  restSeconds: 15,
),

Exercise(
title: "Bench Press",
category: "Chest",
level: "Intermediate",
duration: "20 mins",
calories: "240 kcal",
image: "assets/images/exercises/bench_press.jpg",
description:
"The bench press is one of the most effective compound exercises for building chest strength, muscle mass, and pushing power.",
instructions: [
"Lie flat on the bench with your feet firmly on the floor.",
"Grip the bar slightly wider than shoulder-width.",
"Lower the bar slowly until it touches your chest.",
"Press the bar back up until your arms are fully extended.",
],
  workSeconds: 60,
  restSeconds: 20,
),

Exercise(
title: "Incline Push Up",
category: "Chest",
level: "Beginner",
duration: "15 mins",
calories: "160 kcal",
image: "assets/images/exercises/incline_push_up.jpg",
description:
"Incline push-ups reduce bodyweight resistance, making them ideal for beginners while still strengthening the chest, shoulders, and triceps.",
instructions: [
"Place your hands on a bench or elevated platform.",
"Keep your body straight throughout the movement.",
"Lower your chest toward the platform.",
"Push yourself back to the starting position.",
],
  workSeconds: 45,
  restSeconds: 15,
),

Exercise(
title: "Chest Fly",
category: "Chest",
level: "Intermediate",
duration: "18 mins",
calories: "180 kcal",
image: "assets/images/exercises/chest_fly.jpg",
description:
"The chest fly isolates the pectoral muscles and helps improve chest definition, flexibility, and muscle control.",
instructions: [
"Lie on a flat bench holding two dumbbells above your chest.",
"Lower both arms slowly in a wide arc.",
"Stop when you feel a stretch across your chest.",
"Bring the dumbbells back together above your chest.",
],
  workSeconds: 50,
  restSeconds: 20,
),

// ==========================
// BACK
// ==========================
Exercise(
title: "Pull Up",
category: "Back",
level: "Intermediate",
duration: "15 mins",
calories: "180 kcal",
image: "assets/images/exercises/pull_up.jpg",
description:
"Pull-ups are one of the best bodyweight exercises for building upper back strength, improving grip, and developing the latissimus dorsi muscles.",
instructions: [
"Grip the pull-up bar slightly wider than shoulder-width.",
"Hang with your arms fully extended.",
"Pull your body upward until your chin clears the bar.",
"Lower yourself slowly to the starting position.",
],
  workSeconds: 40,
  restSeconds: 20,
),

Exercise(
title: "Lat Pulldown",
category: "Back",
level: "Beginner",
duration: "18 mins",
calories: "190 kcal",
image: "assets/images/exercises/lat_pulldown.jpg",
description:
"The lat pulldown strengthens the latissimus dorsi while improving posture and upper-body pulling strength.",
instructions: [
"Sit comfortably with your thighs secured under the pads.",
"Grip the bar wider than shoulder-width.",
"Pull the bar down toward your upper chest.",
"Slowly return the bar to the starting position.",
],
  workSeconds: 50,
  restSeconds: 20,
),

Exercise(
title: "Barbell Row",
category: "Back",
level: "Intermediate",
duration: "20 mins",
calories: "230 kcal",
image: "assets/images/exercises/barbell_row.jpg",
description:
"The barbell row is a compound movement that builds thickness and strength throughout the upper and middle back.",
instructions: [
"Hold the barbell with a shoulder-width grip.",
"Bend forward while keeping your back straight.",
"Pull the bar toward your lower chest or upper abdomen.",
"Lower the bar under control to complete one repetition.",
],
  workSeconds: 60,
  restSeconds: 20,
),

// ==========================
// LEGS
// ==========================
Exercise(
title: "Squat",
category: "Legs",
level: "Beginner",
duration: "18 mins",
calories: "220 kcal",
image: "assets/images/exercises/squat.jpg",
description:
"The squat is one of the most effective lower-body exercises, targeting the quadriceps, hamstrings, glutes, and core while improving overall strength.",
instructions: [
"Stand with your feet shoulder-width apart.",
"Lower your hips by bending your knees and pushing your hips back.",
"Keep your chest up and your back straight throughout the movement.",
"Push through your heels to return to the starting position.",
],
  workSeconds: 60,
  restSeconds: 20,
),

Exercise(
title: "Lunges",
category: "Legs",
level: "Beginner",
duration: "15 mins",
calories: "180 kcal",
image: "assets/images/exercises/lunges.jpg",
description:
"Lunges improve lower-body strength, balance, coordination, and flexibility by working each leg independently.",
instructions: [
"Stand upright with your feet together.",
"Step forward with one leg.",
"Lower both knees until they form approximately 90-degree angles.",
"Push back to the starting position and repeat with the opposite leg.",
],
  workSeconds: 45,
  restSeconds: 15,
),

Exercise(
title: "Leg Press",
category: "Legs",
level: "Intermediate",
duration: "20 mins",
calories: "240 kcal",
image: "assets/images/exercises/leg_press.jpg",
description:
"The leg press is a machine-based exercise that builds powerful quadriceps, hamstrings, and glutes with controlled resistance.",
instructions: [
"Sit on the leg press machine with your feet shoulder-width apart.",
"Release the safety handles while keeping your feet firmly on the platform.",
"Lower the platform slowly until your knees reach about 90 degrees.",
"Press the platform back to the starting position without locking your knees.",
],
  workSeconds: 60,
  restSeconds: 20,
),

// ==========================
// ARMS
// ==========================
Exercise(
title: "Bicep Curl",
category: "Arms",
level: "Beginner",
duration: "15 mins",
calories: "140 kcal",
image: "assets/images/exercises/bicep_curl.jpg",
description:
"The bicep curl is a classic isolation exercise that strengthens and develops the biceps while improving arm endurance.",
instructions: [
"Stand upright holding a dumbbell in each hand.",
"Keep your elbows close to your body.",
"Curl the dumbbells upward until they reach shoulder height.",
"Lower the weights slowly to the starting position.",
],
  workSeconds: 45,
  restSeconds: 15,
),

Exercise(
title: "Hammer Curl",
category: "Arms",
level: "Intermediate",
duration: "16 mins",
calories: "150 kcal",
image: "assets/images/exercises/hammer_curl.jpg",
description:
"Hammer curls target the biceps and brachialis muscles, helping build thicker and stronger arms while improving grip strength.",
instructions: [
"Hold a dumbbell in each hand with your palms facing inward.",
"Keep your elbows tucked close to your body.",
"Curl the dumbbells upward without rotating your wrists.",
"Lower the dumbbells slowly under control.",
],
  workSeconds: 45,
  restSeconds: 15,
),

Exercise(
title: "Tricep Pushdown",
category: "Arms",
level: "Intermediate",
duration: "18 mins",
calories: "170 kcal",
image: "assets/images/exercises/tricep_pushdown.jpg",
description:
"The tricep pushdown isolates the triceps and helps improve arm strength, muscle definition, and pressing power.",
instructions: [
"Stand facing the cable machine with a straight bar attachment.",
"Grip the bar with both hands and keep your elbows close to your sides.",
"Push the bar downward until your arms are fully extended.",
"Slowly return the bar to the starting position.",
],
  workSeconds: 50,
  restSeconds: 20,
),

// ==========================
// ABS
// ==========================
  Exercise(
    title: "Crunch",
    category: "Abs",
    level: "Beginner",
    duration: "12 mins",
    calories: "110 kcal",
    image: "assets/images/exercises/crunch.jpg",
    description:
    "Crunches are a fundamental abdominal exercise that strengthens the upper abdominal muscles and improves core stability.",
    instructions: [
      "Lie on your back with your knees bent and feet flat on the floor.",
      "Place your hands lightly behind your head or across your chest.",
      "Lift your shoulders off the floor using your abdominal muscles.",
      "Slowly lower yourself back to the starting position.",
    ],
    workSeconds: 30,
    restSeconds: 15,
  ),

  Exercise(
    title: "Plank",
    category: "Abs",
    level: "Intermediate",
    duration: "10 mins",
    calories: "100 kcal",
    image: "assets/images/exercises/plank.jpg",
    description:
    "The plank is an isometric core exercise that strengthens the abdominals, lower back, shoulders, and glutes while improving posture.",
    instructions: [
      "Place your forearms on the floor with your elbows directly below your shoulders.",
      "Extend your legs behind you and balance on your toes.",
      "Keep your body in a straight line from head to heels.",
      "Hold the position while engaging your core muscles.",
    ],
    workSeconds: 45,
    restSeconds: 15,
  ),

  Exercise(
    title: "Russian Twist",
    category: "Abs",
    level: "Intermediate",
    duration: "15 mins",
    calories: "140 kcal",
    image: "assets/images/exercises/russian_twist.jpg",
    description:
    "The Russian twist targets the obliques and core muscles while improving rotational strength and stability.",
    instructions: [
      "Sit on the floor with your knees bent and feet slightly raised.",
      "Lean back slightly while keeping your back straight.",
      "Rotate your torso to one side, then to the other.",
      "Continue alternating sides in a controlled motion.",
    ],
    workSeconds: 40,
    restSeconds: 15,
  ),

];