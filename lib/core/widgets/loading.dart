import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Loading()],
    );
  }
}

class Loading extends StatelessWidget {
  final double size;
  const Loading({super.key, this.size = 27});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.sp,
      height: size.sp,
      child: const CircularProgressIndicator.adaptive(),
    );
  }
}
