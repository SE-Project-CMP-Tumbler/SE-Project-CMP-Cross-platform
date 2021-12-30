import "dart:math" as math;

import "package:flutter/material.dart";

///
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  ///
  SliverAppBarDelegate({
    required final this.minHeight,
    required final this.maxHeight,
    required final this.child,
  });

  ///
  final double minHeight;

  ///
  final double maxHeight;

  ///
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(final SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
