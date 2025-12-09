import 'package:flutter/material.dart';

const Color starColor = Colors.white; 
const Color unratedColor = Colors.white54;
const Color ratingContainerColor = Color(0xFF6B8E6A); 

class InteractiveRatingStars extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int>? onRatingChanged;

  const InteractiveRatingStars({
    super.key,
    this.initialRating = 0,
    this.onRatingChanged,
  });

  @override
  State<InteractiveRatingStars> createState() => _InteractiveRatingStarsState();
}

class _InteractiveRatingStarsState extends State<InteractiveRatingStars> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  Widget _buildStar(int index) {
    return IconButton(
      iconSize: 30, // Ukuran bintang
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: index < _rating ? starColor : unratedColor,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
        widget.onRatingChanged?.call(_rating);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) => _buildStar(index)),
    );
  }
}