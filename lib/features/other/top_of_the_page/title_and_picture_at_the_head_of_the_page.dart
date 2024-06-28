import 'package:flutter/material.dart';

class TitleAndPictureAtTheHeadOfThePage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double imageWidth;
  final double imageHeight;

  const TitleAndPictureAtTheHeadOfThePage({
    super.key,
    required this.title,
    required this.imageUrl,
    this.imageWidth = 45,
    this.imageHeight = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Center(
            child: imageUrl.isNotEmpty
                ? Image.asset(
                    imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                  )
                : const Placeholder(
                    fallbackHeight: 35,
                    fallbackWidth: 35,
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
