import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? context.colors.brandColor
        : context.colors.textSecondary;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: context.colors.specialCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.home, 'Home'),
          _buildNavItem(context, 1, Icons.bar_chart, 'History'),
          // const SizedBox(width: 48), // Space for FAB
          _buildNavItem(context, 3, Icons.credit_card, 'Reffer'),
          _buildNavItem(context, 4, Icons.person, 'Profile'),
        ],
      ),
    );
  }
}

  // Positioned(
  //           top: -24,
  //           left: 0,
  //           right: 0,
  //           child: Center(
  //             child: GestureDetector(
  //               onTap: () => onTap(2),
  //               child: Container(
  //                 width: 56,
  //                 height: 56,
  //                 decoration: BoxDecoration(
  //                   color: context.colors.brandColor,
  //                   shape: BoxShape.circle,
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: context.colors.brandColor.withOpacity(0.4),
  //                       blurRadius: 12,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: const Icon(Icons.add, color: Colors.white, size: 32),
  //               ),
  //             ),
  //           ),
  //         ),
        