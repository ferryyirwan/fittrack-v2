import 'package:flutter/material.dart';

import '../../../models/app_user.dart';
import 'stat_card.dart';

class ProfileStats extends StatelessWidget {
  final AppUser? user;

  const ProfileStats({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [

            StatCard(
              icon: Icons.height_rounded,
              title: "Height",
              value: "${user?.height.toInt() ?? 0} cm",
            ),

            StatCard(
              icon: Icons.monitor_weight_rounded,
              title: "Weight",
              value: "${user?.weight.toInt() ?? 0} kg",
            ),

          ],
        ),

        Row(
          children: [

            StatCard(
              icon: Icons.person_outline_rounded,
              title: "Gender",
              value: user == null
                  ? "-"
                  : (user!.gender.isEmpty
                  ? "-"
                  : user!.gender),
            ),

            StatCard(
              icon: Icons.cake_outlined,
              title: "Age",
              value: user == null
                  ? "-"
                  : "${user!.calculatedAge} Years",
            ),

          ],
        ),

      ],
    );
  }
}