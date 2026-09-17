import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../core/widgets/common/custom_back_button.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double heightValue = 170.0;
  double weightValue = 65.0;
  String selectedGender = "Male";

  double? calculatedBmi;
  String category = "Normal Weight";
  String recommendation = "";
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().user;
      if (user != null) {
        setState(() {
          if (user.height > 50 && user.height < 250) {
            heightValue = user.height;
          }
          if (user.weight > 20 && user.weight < 300) {
            weightValue = user.weight;
          }
          if (user.gender.isNotEmpty) {
            selectedGender = user.gender;
          }
          heightController.text = heightValue.toStringAsFixed(1);
          weightController.text = weightValue.toStringAsFixed(1);
          _runCalculation();
        });
      } else {
        heightController.text = heightValue.toStringAsFixed(1);
        weightController.text = weightValue.toStringAsFixed(1);
        _runCalculation();
      }
    });
  }

  void _runCalculation() {
    if (heightValue <= 0 || weightValue <= 0) return;

    final result = weightValue / ((heightValue / 100) * (heightValue / 100));

    String bmiCategory;
    String bmiRecommendation;

    if (result < 18.5) {
      bmiCategory = "Underweight";
      bmiRecommendation =
          "You are below the recommended healthy weight range. Consider increasing nutrient-dense calories and strength training to build muscle mass.";
    } else if (result < 25) {
      bmiCategory = "Normal Weight 💪";
      bmiRecommendation =
          "Fantastic! You are right in the optimal healthy weight zone. Keep up your balanced nutrition and consistent workout routine.";
    } else if (result < 30) {
      bmiCategory = "Overweight 🏃";
      bmiRecommendation =
          "You are slightly above the healthy range. Combining consistent cardiovascular exercise with strength training and mindful eating will help optimize your health.";
    } else {
      bmiCategory = "Obese ❤️";
      bmiRecommendation =
          "Your health is a priority! Consider speaking with a healthcare or nutrition professional and starting a steady, progressive daily exercise habit.";
    }

    setState(() {
      calculatedBmi = result;
      category = bmiCategory;
      recommendation = bmiRecommendation;
    });
  }

  Future<void> _saveToProfile() async {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in to save profile metrics.")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final updatedUser = user.copyWith(
        height: heightValue,
        weight: weightValue,
        gender: selectedGender,
      );

      await UserService.instance.updateUser(updatedUser);
      await userProvider.loadUser();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text("Height & weight saved to your profile!"),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Color _getCategoryColor(String cat) {
    if (cat.contains("Underweight")) return Colors.lightBlueAccent;
    if (cat.contains("Normal")) return Colors.green;
    if (cat.contains("Overweight")) return Colors.orange;
    if (cat.contains("Obese")) return Colors.redAccent;
    return AppColors.primary;
  }

  double _getHealthyMinWeight() {
    final hMeter = heightValue / 100;
    return 18.5 * hMeter * hMeter;
  }

  double _getHealthyMaxWeight() {
    final hMeter = heightValue / 100;
    return 24.9 * hMeter * hMeter;
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final statusColor = _getCategoryColor(category);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(
                      "BMI Health Studio",
                      style: context.heading2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 44), // balance back button width
                  ],
                ),

                const SizedBox(height: 24),

                // Interactive Height Slider Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(isDark ? 0.08 : 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.height_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Height",
                                style: context.heading3.copyWith(fontSize: 17),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primary.withOpacity(0.35)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 65,
                                  child: TextField(
                                    controller: heightController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    style: context.heading1.copyWith(
                                      fontSize: 24,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null && d >= 50 && d <= 250) {
                                        setState(() {
                                          heightValue = d.clamp(100.0, 230.0);
                                          _runCalculation();
                                        });
                                      }
                                    },
                                    onSubmitted: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null && d >= 50 && d <= 250) {
                                        setState(() {
                                          heightValue = d.clamp(100.0, 230.0);
                                          heightController.text = heightValue.toStringAsFixed(1);
                                          _runCalculation();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "cm",
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.edit_rounded, color: AppColors.primary, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.primary.withOpacity(0.18),
                          thumbColor: Colors.white,
                          overlayColor: AppColors.primary.withOpacity(0.2),
                          trackHeight: 8,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Slider(
                          value: heightValue,
                          min: 100.0,
                          max: 230.0,
                          onChanged: (val) {
                            setState(() {
                              heightValue = val;
                              heightController.text = val.toStringAsFixed(1);
                              _runCalculation();
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStepButton("-1 cm", () {
                            setState(() {
                              if (heightValue > 101) heightValue -= 1.0;
                              heightController.text = heightValue.toStringAsFixed(1);
                              _runCalculation();
                            });
                          }),
                          _buildStepButton("+1 cm", () {
                            setState(() {
                              if (heightValue < 229) heightValue += 1.0;
                              heightController.text = heightValue.toStringAsFixed(1);
                              _runCalculation();
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Interactive Weight Slider Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(isDark ? 0.08 : 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.monitor_weight_rounded,
                                  color: AppColors.secondary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Weight",
                                style: context.heading3.copyWith(fontSize: 17),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.secondary.withOpacity(0.35)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 65,
                                  child: TextField(
                                    controller: weightController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    style: context.heading1.copyWith(
                                      fontSize: 24,
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null && d >= 20 && d <= 300) {
                                        setState(() {
                                          weightValue = d.clamp(30.0, 180.0);
                                          _runCalculation();
                                        });
                                      }
                                    },
                                    onSubmitted: (val) {
                                      final d = double.tryParse(val);
                                      if (d != null && d >= 20 && d <= 300) {
                                        setState(() {
                                          weightValue = d.clamp(30.0, 180.0);
                                          weightController.text = weightValue.toStringAsFixed(1);
                                          _runCalculation();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "kg",
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.edit_rounded, color: AppColors.secondary, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.secondary,
                          inactiveTrackColor: AppColors.secondary.withOpacity(0.18),
                          thumbColor: Colors.white,
                          overlayColor: AppColors.secondary.withOpacity(0.2),
                          trackHeight: 8,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Slider(
                          value: weightValue,
                          min: 30.0,
                          max: 180.0,
                          onChanged: (val) {
                            setState(() {
                              weightValue = val;
                              weightController.text = val.toStringAsFixed(1);
                              _runCalculation();
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStepButton("-0.5 kg", () {
                            setState(() {
                              if (weightValue > 30.5) weightValue -= 0.5;
                              weightController.text = weightValue.toStringAsFixed(1);
                              _runCalculation();
                            });
                          }),
                          _buildStepButton("+0.5 kg", () {
                            setState(() {
                              if (weightValue < 179.5) weightValue += 0.5;
                              weightController.text = weightValue.toStringAsFixed(1);
                              _runCalculation();
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Live Result Showcase Studio Card
                if (calculatedBmi != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(isDark ? 0.15 : 0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "HEALTH STATUS",
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          calculatedBmi!.toStringAsFixed(1),
                          style: context.heading1.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: statusColor,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Body Mass Index (BMI)",
                          style: context.bodySmall.copyWith(
                            color: context.textSecondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Interactive Health Spectrum Bar
                        _buildHealthSpectrumBar(calculatedBmi!, statusColor),

                        const SizedBox(height: 24),
                        Divider(color: context.borderColor),
                        const SizedBox(height: 16),

                        // Healthy Weight Range Recommendation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ideal Weight for ${heightValue.toInt()} cm",
                                  style: context.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${_getHealthyMinWeight().toStringAsFixed(1)} kg - ${_getHealthyMaxWeight().toStringAsFixed(1)} kg",
                                  style: context.heading3.copyWith(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_rounded, color: Colors.green, size: 24),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: statusColor.withOpacity(0.25)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_outline_rounded, color: statusColor, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  recommendation,
                                  style: context.bodyMedium.copyWith(
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),
                ],

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: PrimaryButton(
                    text: isSaving ? "Saving to Profile..." : "Save Metrics to My Profile",
                    icon: isSaving ? Icons.sync_rounded : Icons.save_rounded,
                    onPressed: isSaving ? null : _saveToProfile,
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: context.isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderColor),
        ),
        child: Text(
          text,
          style: context.bodySmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildHealthSpectrumBar(double bmiValue, Color statusColor) {
    // Spectrum range: 15.0 (left) to 36.0 (right)
    final double normalized = ((bmiValue - 15.0) / (36.0 - 15.0)).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the pin's left position safely within total bar width minus pin width (~55px for badge)
        final double pinWidth = 58.0;
        final double maxTravel = (constraints.maxWidth - pinWidth).clamp(0.0, double.infinity);
        final double leftOffset = maxTravel * normalized;

        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // The 4 color bars
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 18, // < 18.5
                        child: Container(color: Colors.lightBlueAccent),
                      ),
                      Expanded(
                        flex: 30, // 18.5 - 24.9
                        child: Container(color: Colors.green),
                      ),
                      Expanded(
                        flex: 24, // 25.0 - 29.9
                        child: Container(color: Colors.orange),
                      ),
                      Expanded(
                        flex: 28, // >= 30.0
                        child: Container(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                // Indicator Pin moving dynamically!
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  left: leftOffset,
                  top: -24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.45),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "YOU (${bmiValue.toStringAsFixed(1)})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: statusColor, size: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("15.0", style: context.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                Text("18.5", style: context.bodySmall.copyWith(fontSize: 10, color: Colors.lightBlueAccent, fontWeight: FontWeight.w800)),
                Text("25.0", style: context.bodySmall.copyWith(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w800)),
                Text("30.0", style: context.bodySmall.copyWith(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w800)),
                Text("36.0+", style: context.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        );
      },
    );
  }
}