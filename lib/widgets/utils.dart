import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildImageFromUrl(String imageUrl, double size) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(size),
    child: CachedNetworkImage(
      width: size,
      height: size,
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          CircularProgressIndicator(), // Menampilkan loading saat gambar sedang dimuat
      errorWidget: (context, url, error) =>
          Icon(Icons.error), // Menampilkan ikon error jika gagal memuat gambar
      fit: BoxFit.cover,
    ),
  );
}
