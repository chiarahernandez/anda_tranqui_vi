import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EstrellasDinamicas extends StatefulWidget {
  const EstrellasDinamicas({
    super.key,
    this.ratingInicial = 0,
    this.onRatingChanged,
  });

  final int ratingInicial;

  final ValueChanged<int>? onRatingChanged;

  @override
  State<EstrellasDinamicas> createState() => _EstrellasDinamicasState();
}

class _EstrellasDinamicasState extends State<EstrellasDinamicas> {
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.ratingInicial;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _currentRating.toDouble(), 
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 34.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      unratedColor: const Color(0xFFD9D9D9),
      glowColor: const Color(0xFFEEE86B),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color(0xFFEEE86B),
      ),
      onRatingUpdate: (newRating) {
        setState(() {
          _currentRating = newRating.toInt(); 
        });
        if (widget.onRatingChanged != null) {
          widget.onRatingChanged!(_currentRating); 
        }
      }
    );
  }
}
