import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Icons matching the Figma design: Grid, Smile/Face, People, Book, Toggle/Switch
    final icons = [
      Icons.grid_view_rounded,
      Icons.sentiment_satisfied_alt_outlined,
      Icons.people_outline_rounded,
      Icons.book,
      Icons.toggle_off_outlined,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 14, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isActive = index == currentIndex;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                  size: 24,
                ),
                const SizedBox(height: 6),
                // Small gold dot indicator matching Figma
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accentGold : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
