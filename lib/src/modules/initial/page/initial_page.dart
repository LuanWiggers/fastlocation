import 'dart:async';

import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _animation, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _animation, curve: Curves.elasticOut),
    );
    _animation.forward();

    // Redirecionamento automático para a home
    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, size: 96, color: Colors.white),
                SizedBox(height: AppMetrics.md),
                Text(
                  'FastLocation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppMetrics.xs),
                Text(
                  'Consulte CEPs e endereços com rapidez',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
