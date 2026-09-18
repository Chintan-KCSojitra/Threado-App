/*
import 'package:flutter/material.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/view/productDetail/product_detail_screen.dart';

/// Instagram Reels–style vertical scroll container.
/// Pass the full [productList] and the [initialIndex] of the tapped item.
class ProductReelScreen extends StatefulWidget {
  final List<ProductListData> productList;
  final int initialIndex;

  const ProductReelScreen({
    super.key,
    required this.productList,
    required this.initialIndex,
  });

  @override
  State<ProductReelScreen> createState() => _ProductReelScreenState();
}

class _ProductReelScreenState extends State<ProductReelScreen> {
  late final PageController _reelController;

  /// True while a child ProductDetailScreen's image is zoomed in.
  /// We lock the reel's vertical scroll during this time.
  bool _isImageZoomed = false;

  @override
  void initState() {
    super.initState();
    // Start on the tapped product — same as Instagram jumping to the tapped reel
    _reelController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _reelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _reelController,
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            // Lock vertical reel swiping while a child image is zoomed in
            physics: _isImageZoomed
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            itemCount: widget.productList.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                key: ValueKey(index),
                tween: Tween(begin: 0.96, end: 1),
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: ProductDetailScreen(
                  productData: widget.productList[index],
                  onZoomChanged: (zoomed) {
                    // Only rebuild if the state actually changed
                    if (zoomed != _isImageZoomed) {
                      setState(() => _isImageZoomed = zoomed);
                    }
                  },
                ),
              );
            },
          ),
          IgnorePointer(
            child: SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.14),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/view/productDetail/product_detail_screen.dart';

/// Instagram Reels–style vertical scroll container.
/// Pass the full [productList] and the [initialIndex] of the tapped item.
class ProductReelScreen extends StatefulWidget {
  final List<ProductListData> productList;
  final int initialIndex;

  const ProductReelScreen({
    super.key,
    required this.productList,
    required this.initialIndex,
  });

  @override
  State<ProductReelScreen> createState() => _ProductReelScreenState();
}

class _ProductReelScreenState extends State<ProductReelScreen> {
  late final PageController _reelController;

  /// True while a child ProductDetailScreen's image is zoomed in.
  bool _isImageZoomed = false;

  // [OPT-1] Pre-compute the overlay gradient decoration once.
  // The original called Colors.black.withValues(alpha: x) inside build(),
  // which allocates new Color objects and a new LinearGradient on every frame
  // during the scale animation (TweenAnimationBuilder fires ~60fps).
  // A static const decoration is built once at compile time.
  static const _overlayDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x24000000), // black @ 14 % opacity
        Colors.transparent,
        Color(0x42000000), // black @ 26 % opacity
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _reelController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _reelController.dispose();
    super.dispose();
  }

  // [OPT-2] Zoom-change callback extracted as a named method.
  // The original created a new closure object on every itemBuilder call
  // (i.e. up to `allowImplicitScrolling` pages × 60fps during animations).
  // A named method is a single, stable tear-off — zero extra allocations.
  void _onZoomChanged(bool zoomed) {
    if (zoomed != _isImageZoomed) {
      setState(() => _isImageZoomed = zoomed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _reelController,
            scrollDirection: Axis.vertical,
            // [OPT-3] Disable allowImplicitScrolling.
            // When true, Flutter keeps the page BEFORE and AFTER the current
            // one alive in the tree at all times. Each alive ProductDetailScreen
            // holds a VideoPlayerController, a ProductDetailCubit, a
            // PageController, and a screenshot stream subscription.
            // With allowImplicitScrolling = true that means up to 3 heavy
            // screens are initialised simultaneously. Setting it to false
            // means only the visible page is alive — a significant memory and
            // CPU saving in a reel of many products.
            allowImplicitScrolling: false,
            physics: _isImageZoomed
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            itemCount: widget.productList.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: ProductDetailScreen(
                  key: ValueKey(widget.productList[index].id ?? index),
                  productData: widget.productList[index],
                  onZoomChanged: _onZoomChanged,
                ),
              );
            },
          ),

          // [OPT-6] Gradient overlay: IgnorePointer + DecoratedBox + const
          // decoration. The original used SizedBox.expand(child: DecoratedBox)
          // which is correct, but recomputed the gradient colors every build.
          // With the static const decoration, this subtree is fully inert during
          // animation frames — Flutter's element reconciler sees no changes and
          // skips it entirely.
          const IgnorePointer(
            child: DecoratedBox(
              decoration: _overlayDecoration,
              // Fill the Stack by letting DecoratedBox take its parent's size.
              child: SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
