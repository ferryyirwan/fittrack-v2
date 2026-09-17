import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_page_transitions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/app_user.dart';
import '../../bmi/bmi_screen.dart';

class BmiBannerCard extends StatelessWidget {
  final AppUser? user;

  const BmiBannerCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final bmi = user?.bmi ?? 0.0;
    final isDark = context.isDark;

    String status = "Calculate Now";
    Color statusColor = AppColors.secondary;

    if (bmi > 0) {
      if (bmi < 18.5) {
        status = "Underweight";
        statusColor = Colors.lightBlueAccent;
      } else if (bmi < 25) {
        status = "Normal Weight 💪";
        statusColor = Colors.green;
      } else if (bmi < 30) {
        status = "Overweight 🏃";
        statusColor = Colors.orange;
      } else {
        status = "Obese ❤️";
        statusColor = Colors.redAccent;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          AppPageTransitions.slideUp(const BmiScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: statusColor.withOpacity(0.4),
            width: 1.2,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: statusColor.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: statusColor.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor, statusColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.monitor_weight_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BMI Health Calculator",
                    style: context.heading3.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  bmi > 0 ? bmi.toStringAsFixed(1) : "-",
                  style: context.heading1.copyWith(
                    fontSize: 26,
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      "Check Now",
                      style: context.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: context.textSecondaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
