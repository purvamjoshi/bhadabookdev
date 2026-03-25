import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BBImageGrid extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final double itemSize;

  const BBImageGrid({super.key, required this.images, required this.onAdd, required this.onRemove, this.itemSize = 80});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: itemSize + 2,
    child: ListView(scrollDirection: Axis.horizontal, children: [
      ...List.generate(images.length, (i) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Stack(children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(images[i], width: itemSize, height: itemSize, fit: BoxFit.cover)),
          Positioned(top: 2, right: 2, child: GestureDetector(
            onTap: () => onRemove(i),
            child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle), child: const Icon(Icons.close, size: 12, color: AppColors.white)),
          )),
        ]),
      )),
      GestureDetector(
        onTap: onAdd,
        child: Container(
          width: itemSize, height: itemSize,
          decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.grey300)),
          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add, color: AppColors.grey400, size: 26), Text('Add', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.grey400))]),
        ),
      ),
    ]),
  );
}

/// Network image grid (for property detail view)
class BBNetworkImageGrid extends StatelessWidget {
  final List<String> urls;
  const BBNetworkImageGrid({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return _placeholder();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: urls.length == 1
          ? _img(urls[0], double.infinity, 200)
          : Column(children: [
              _img(urls[0], double.infinity, 160),
              const SizedBox(height: 4),
              Row(children: List.generate(urls.length - 1 > 3 ? 3 : urls.length - 1, (i) => Expanded(child: Padding(
                padding: EdgeInsets.only(left: i > 0 ? 4 : 0),
                child: _img(urls[i + 1], double.infinity, 80),
              )))),
            ]),
    );
  }

  Widget _img(String url, double w, double h) => Container(
    width: w, height: h, decoration: BoxDecoration(color: AppColors.primarySurface),
    child: Icon(Icons.image_outlined, color: AppColors.primary.withOpacity(0.4), size: 40),
    // Replace Icon with: Image.network(url, fit: BoxFit.cover, width: w, height: h)
  );

  Widget _placeholder() => Container(
    height: 140, decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
    child: const Center(child: Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.primary)),
  );
}
