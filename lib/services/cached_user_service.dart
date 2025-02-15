import 'dart:io';

import 'package:escoladeverao/services/cached_manager_service.dart';
import 'package:escoladeverao/services/image_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedUserImage extends StatelessWidget {
  final String userId;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;

  const CachedUserImage({
    Key? key,
    required this.userId,
    this.width = 48,
    this.height = 48,
    this.fit = BoxFit.cover,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: CachedImageManager().getCachedImagePath(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ClipOval(
            child: Image.file(
              File(snapshot.data!),
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            ),
          );
        }
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: width * 0.6,
            color: Colors.grey[600],
          ),
        );
  }
}
