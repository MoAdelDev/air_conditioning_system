import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  const CustomLoadingIndicator({super.key, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: Colors.blue,
      size: size,
      duration: const Duration(milliseconds: 2000),
    );
  }
}
