import 'package:flutter/material.dart';

/// Avatar-Kreis mit Initialen (Pendant zu UserAvatarView.swift)
class UserAvatar extends StatelessWidget {
  final String name;
  final double size;

  const UserAvatar({super.key, required this.name, this.size = 44});

  String get _initials {
    final parts = name.split(' ');
    return parts.take(2).map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
  }

  Color get _backgroundColor {
    const colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple, Colors.pink];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: _backgroundColor),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
