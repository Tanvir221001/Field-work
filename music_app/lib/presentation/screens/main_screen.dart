import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/mini_player.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // Above bottom nav
            child: const MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: currentIndex),
    );
  }
}
