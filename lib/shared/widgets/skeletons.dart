import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = 12,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surface,
      child: child,
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.66,
        ),
        itemCount: itemCount,
        itemBuilder: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(child: ShimmerBox(radius: 18)),
            SizedBox(height: 8),
            ShimmerBox(height: 14),
            SizedBox(height: 6),
            ShimmerBox(height: 14, width: 80),
          ],
        ),
      ),
    );
  }
}

/// Compact 4-column shimmer used by Home's category strip.
class CategoryGridSkeleton extends StatelessWidget {
  const CategoryGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: 8,
        itemBuilder: (_, _) => Column(
          children: const [
            ShimmerBox(width: 56, height: 56, radius: 28),
            SizedBox(height: 8),
            ShimmerBox(height: 10, width: 60),
          ],
        ),
      ),
    );
  }
}

/// 2-column tall-card shimmer matching the dedicated Categories page.
class CategoryListSkeleton extends StatelessWidget {
  const CategoryListSkeleton({super.key, this.itemCount = 8});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemCount: itemCount,
        itemBuilder: (_, _) => const ShimmerBox(radius: 22),
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key, this.itemCount = 5});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => Row(
          children: const [
            ShimmerBox(width: 80, height: 80, radius: 14),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(height: 14, width: 120),
                  SizedBox(height: 8),
                  ShimmerBox(height: 14, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen shimmer for product detail (hero image + body content).
class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShimmerBox(height: 360, radius: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(height: 20),
                  SizedBox(height: 10),
                  ShimmerBox(height: 20, width: 200),
                  SizedBox(height: 20),
                  ShimmerBox(height: 28, width: 140),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      ShimmerBox(height: 28, width: 110, radius: 999),
                      SizedBox(width: 8),
                      ShimmerBox(height: 28, width: 140, radius: 999),
                    ],
                  ),
                  SizedBox(height: 28),
                  ShimmerBox(height: 16, width: 110),
                  SizedBox(height: 12),
                  ShimmerBox(height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(height: 14, width: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for order detail page.
class OrderDetailSkeleton extends StatelessWidget {
  const OrderDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ShimmerBox(height: 88, radius: 18),
          SizedBox(height: 24),
          ShimmerBox(height: 18, width: 90),
          SizedBox(height: 12),
          ShimmerBox(height: 180, radius: 16),
          SizedBox(height: 24),
          ShimmerBox(height: 18, width: 100),
          SizedBox(height: 12),
          ShimmerBox(height: 120, radius: 16),
          SizedBox(height: 24),
          ShimmerBox(height: 18, width: 60),
          SizedBox(height: 12),
          ShimmerBox(height: 220, radius: 16),
        ],
      ),
    );
  }
}

/// Shimmer for profile page (hero block + cards).
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          ShimmerBox(height: 260, radius: 0),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ShimmerBox(height: 68, radius: 16),
                SizedBox(height: 12),
                ShimmerBox(height: 68, radius: 16),
                SizedBox(height: 16),
                ShimmerBox(height: 220, radius: 18),
                SizedBox(height: 16),
                ShimmerBox(height: 80, radius: 18),
                SizedBox(height: 16),
                ShimmerBox(height: 220, radius: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
