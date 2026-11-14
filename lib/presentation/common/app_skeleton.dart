import 'package:flutter/material.dart';

/// Animated shimmer container providing placeholder skeletons during asynchronous loads.
class AppSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 8.0,
    this.margin,
  });

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF2C3240)
        : const Color(0xFFE2E8F0);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton placeholder for table views (e.g. Products, Invoices, Customers).
class AppSkeletonTable extends StatelessWidget {
  final int rowCount;
  final int columnCount;

  const AppSkeletonTable({
    super.key,
    this.rowCount = 5,
    this.columnCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Table Header skeleton
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          ),
          child: Row(
            children: List.generate(
              columnCount,
              (index) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: AppSkeleton(height: 14.0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        // Table Rows
        ...List.generate(
          rowCount,
          (rowIndex) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: List.generate(
                columnCount,
                (colIndex) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: AppSkeleton(
                      height: 12.0,
                      width: colIndex == 0 ? 120.0 : 80.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pre-built skeleton placeholder for mobile card lists.
class AppSkeletonList extends StatelessWidget {
  final int itemCount;

  const AppSkeletonList({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton(width: 140.0, height: 16.0),
                    AppSkeleton(width: 60.0, height: 20.0, borderRadius: 12.0),
                  ],
                ),
                SizedBox(height: 10.0),
                AppSkeleton(width: 220.0, height: 12.0),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton(width: 80.0, height: 14.0),
                    AppSkeleton(width: 100.0, height: 14.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pre-built skeleton placeholder for KPI summary cards (e.g. Dashboard, Shift Summary).
class AppSkeletonKpiGrid extends StatelessWidget {
  final int cardCount;

  const AppSkeletonKpiGrid({super.key, this.cardCount = 4});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900 ? 4 : (constraints.maxWidth >= 600 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
          ),
          itemCount: cardCount,
          itemBuilder: (context, index) => Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppSkeleton(width: 90.0, height: 12.0),
                      AppSkeleton(width: 28.0, height: 28.0, borderRadius: 14.0),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  AppSkeleton(width: 130.0, height: 22.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
