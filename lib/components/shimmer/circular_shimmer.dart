import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CircularShimmer extends StatelessWidget {
  const CircularShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: SizedBox(
          height: 210,
          width: MediaQuery.of(context).size.width * 0.90,
        ),
      ),
    );
  }
}
