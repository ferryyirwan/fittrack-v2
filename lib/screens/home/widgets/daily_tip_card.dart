import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common/glass_card.dart';
import '../../../providers/fitness_tip_provider.dart';

class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FitnessTipProvider>().loadTip();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessTipProvider>();

    return GlassCard(
      padding: const EdgeInsets.all(22),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.amber,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily Fitness Tip",
                      style: context.heading3.copyWith(fontSize: 18),
                    ),
                    Text(
                      "Wisdom for peak performance",
                      style: context.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: "Refresh Tip",
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () async {
                  await context.read<FitnessTipProvider>().loadTip();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          provider.loading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        color: AppColors.primary.withOpacity(0.6),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.tip,
                          style: context.bodyMedium.copyWith(
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}