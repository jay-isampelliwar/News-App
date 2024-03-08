import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 16,
        itemBuilder: (BuildContext context, int index) {
          return ShimmerWidget(
            height: height * 0.14,
          );
        },
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({required this.height, super.key});
  final double height;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      clipBehavior: Clip.hardEdge,
      height: this.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(
        bottom: height * 0.02,
        left: width * 0.02,
        right: width * 0.02,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade900,
        highlightColor: Colors.grey.shade800,
        child: Container(
          color: Colors.grey.shade900,
        ),
      ),
    );
  }
}
