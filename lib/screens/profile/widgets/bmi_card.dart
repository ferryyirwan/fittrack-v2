import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/app_user.dart';

class BmiCard extends StatelessWidget {
  final AppUser? user;

  const BmiCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox();
    }

    final bmi = user!.bmi;

    String status;
    Color color;

    if (bmi == 0) {
      status = "Complete your profile";
      color = Colors.grey;
    } else if (bmi < 18.5) {
      status = "Underweight";
      color = Colors.lightBlue;
    } else if (bmi < 25) {
      status = "Normal";
      color = Colors.green;
    } else if (bmi < 30) {
      status = "Overweight";
      color = Colors.orange;
    } else {
      status = "Obese";
      color = Colors.red;
    }

    final progress = (bmi / 40).clamp(0.0, 1.0);
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const Icon(
                Icons.favorite,
                color: Colors.red,
              ),

              const SizedBox(width: 10),

              Text(
                "BMI Health",
                style: TextStyle(
                  color: context.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          Center(
            child: Column(
              children: [

                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    color: context.textColor,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0", style: TextStyle(color: context.textSecondaryColor)),
              Text("20", style: TextStyle(color: context.textSecondaryColor)),
              Text("40", style: TextStyle(color: context.textSecondaryColor)),
            ],
          ),
        ],
      ),
    );
  }
}