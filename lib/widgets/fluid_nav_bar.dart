import 'package:flutter/material.dart';

class FluidNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FluidNavBar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bottom navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, Icons.home_outlined, 'Home', true),
              // Empty space for center button
              SizedBox(width: 60),
              _buildNavItem(
                context,
                1,
                Icons.calendar_today_outlined,
                'Forecast',
                false,
              ),
            ],
          ),

          // Center floating button
          Positioned(
            top: -20,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7CFC00), // Bright green
                      Color(0xFF00FFFF), // Cyan
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    bool isLeft,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: isLeft ? 30 : 0,
          right: !isLeft ? 30 : 0,
        ),
        child: Icon(
          icon,
          color: isSelected ? Color(0xFF7CFC00) : Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
