import 'package:flutter/material.dart';

/// Interaktive Star-Bewertung (Pendant zu StarRatingView.swift)
class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onChanged;
  final int maxRating;
  final double size;
  final Color filledColor;

  const StarRating({
    super.key,
    required this.rating,
    this.onChanged,
    this.maxRating = 5,
    this.size = 28,
    this.filledColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (i) {
        final star = i + 1;
        return GestureDetector(
          onTap: onChanged != null ? () => onChanged!(star) : null,
          child: Icon(
            star <= rating ? Icons.star : Icons.star_border,
            size: size,
            color: star <= rating ? filledColor : Colors.grey.shade400,
          ),
        );
      }),
    );
  }
}

/// Statische Sterne für Durchschnittswerte (Pendant zu StaticStarRatingView)
class StaticStarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color filledColor;

  const StaticStarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 14,
    this.filledColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (i) {
        final star = i + 1;
        IconData icon;
        if (star.toDouble() <= rating) {
          icon = Icons.star;
        } else if (star - 0.5 <= rating) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: star <= rating + 0.5 ? filledColor : Colors.grey.shade400);
      }),
    );
  }
}
