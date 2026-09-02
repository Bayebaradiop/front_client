import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';

/// Generic Shimmer Container
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Base generic Shimmer list loading
class ShimmerLoading extends StatelessWidget {
  final int itemCount;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerLoading({
    super.key,
    this.itemCount = 5,
    this.height = 100,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (_, __) => Container(
          height: height,
          margin: margin ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ShimmerBox(width: 140, height: 14, borderRadius: 4),
                    const SizedBox(height: 8),
                    const ShimmerBox(width: 90, height: 10, borderRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic Shimmer Card (Horizontal items)
class ShimmerCard extends StatelessWidget {
  final double? width;
  final double height;

  const ShimmerCard({
    super.key,
    this.width,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 12),
            const ShimmerBox(width: 100, height: 12, borderRadius: 4),
            const SizedBox(height: 6),
            const ShimmerBox(width: 70, height: 10, borderRadius: 4),
            const Spacer(),
            const ShimmerBox(width: double.infinity, height: 32, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

/// Doctor List Card Skeleton (MedecinsView)
class MedecinCardSkeleton extends StatelessWidget {
  final int itemCount;
  const MedecinCardSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: itemCount,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 130, height: 14, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerBox(width: 90, height: 11, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerBox(width: 110, height: 10, borderRadius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const ShimmerBox(width: 85, height: 32, borderRadius: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cabinet List Card Skeleton (CabinetsView)
class CabinetCardSkeleton extends StatelessWidget {
  final int itemCount;
  const CabinetCardSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        itemCount: itemCount,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              const ShimmerBox(width: 54, height: 54, borderRadius: 16),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 150, height: 15, borderRadius: 4),
                    SizedBox(height: 8),
                    ShimmerBox(width: 180, height: 11, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerBox(width: 100, height: 11, borderRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Specialty List Card Skeleton (SpecialitesView)
class SpecialiteCardSkeleton extends StatelessWidget {
  final int itemCount;
  const SpecialiteCardSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        itemCount: itemCount,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const ShimmerBox(width: 58, height: 58, borderRadius: 18),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 140, height: 16, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerBox(width: 180, height: 11, borderRadius: 4),
                    SizedBox(height: 8),
                    ShimmerBox(width: 120, height: 18, borderRadius: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Appointment List Card Skeleton (MesRdvView)
class RdvCardSkeleton extends StatelessWidget {
  final int itemCount;
  const RdvCardSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
        itemCount: itemCount,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 130, height: 14, borderRadius: 4),
                        SizedBox(height: 4),
                        ShimmerBox(width: 90, height: 11, borderRadius: 4),
                        SizedBox(height: 4),
                        ShimmerBox(width: 110, height: 10, borderRadius: 4),
                      ],
                    ),
                  ),
                  const ShimmerBox(width: 70, height: 22, borderRadius: 12),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Expanded(child: ShimmerBox(width: double.infinity, height: 24, borderRadius: 6)),
                    SizedBox(width: 12),
                    Expanded(child: ShimmerBox(width: double.infinity, height: 24, borderRadius: 6)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: ShimmerBox(width: double.infinity, height: 36, borderRadius: 12)),
                  SizedBox(width: 8),
                  Expanded(child: ShimmerBox(width: double.infinity, height: 36, borderRadius: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal Filter Pills Skeleton (MedecinsView top bar)
class FilterPillsSkeleton extends StatelessWidget {
  final int itemCount;
  const FilterPillsSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: itemCount,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 90,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Time Slots Creneaux Skeleton (MedecinDetailView)
class CreneauxSkeleton extends StatelessWidget {
  const CreneauxSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          8,
          (index) => Container(
            width: 105,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full Doctor Detail Skeleton (MedecinDetailView)
class DoctorDetailSkeleton extends StatelessWidget {
  const DoctorDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),
            const ShimmerBox(width: 160, height: 20, borderRadius: 6),
            const SizedBox(height: 8),
            const ShimmerBox(width: 110, height: 14, borderRadius: 12),
            const SizedBox(height: 32),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 28),
            const CreneauxSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// Boarding Pass Ticket Skeleton (RdvDetailView)
class RdvDetailSkeleton extends StatelessWidget {
  const RdvDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: double.infinity, height: 44, borderRadius: 14),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 140, height: 16, borderRadius: 4),
                      SizedBox(height: 6),
                      ShimmerBox(width: 100, height: 12, borderRadius: 4),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const ShimmerBox(width: double.infinity, height: 60, borderRadius: 16),
              const SizedBox(height: 20),
              const ShimmerBox(width: double.infinity, height: 50, borderRadius: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Prochain RDV Hero Skeleton (HomeView)
class ProchainRdvSkeleton extends StatelessWidget {
  const ProchainRdvSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}
