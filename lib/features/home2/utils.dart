// Function to calculate total pieces based on box count
import 'package:flutter/material.dart';

int calculateTotalPieces(String key, int boxCount) {
  switch (key) {
    case 'classic':
    case 'supreme': //  تم تغيير supreme  إلى 30 قطعة في الصندوق
      return boxCount * 30;
    case 'croissant':
    case 'double':
      return boxCount * 24;
    case 'fino':
      return boxCount * 8;
    default:
      return boxCount;
  }
}

// Function to calculate box equivalent
List<String> calculateBoxEquivalent(String key, int boxCount) {
  switch (key) {
    case 'classic':
    case 'supreme': //  تم تغيير supreme  إلى 30 قطعة في الصندوق
      return ['${boxCount * 30} قطعة', '$boxCount صندوق'];
    case 'croissant':
    case 'double':
      int boxEquivalent = (boxCount * 24 / 30).floor();
      int remainingPieces = (boxCount * 24) % 30;
      return [
        '${boxCount * 24} قطعة',
        '$boxEquivalent صندوق \n$remainingPieces قطعة'
      ];
    case 'fino':
      return ['${boxCount * 8} قطعة', '$boxCount صندوق'];
    default:
      return ['$boxCount قطعة', '$boxCount صندوق'];
  }
}

List<String> calculateTotalBoxEquivalentForAll(
    Map<String, TextEditingController> boxControllers) {
  int totalPieces = 0;
  int finoPieces = 0; // Variable to store total fino pieces

  boxControllers.forEach((key, controller) {
    int pieces = calculateTotalPieces(key, int.tryParse(controller.text) ?? 0);
    totalPieces += pieces;

    if (key == 'fino') {
      finoPieces = pieces; // Store fino pieces separately
    }
  });

  int totalBoxEquivalent = (totalPieces / 30).floor();
  int remainingPieces = totalPieces % 30;

  int finoBoxes = (finoPieces / 8).floor(); // Calculate fino boxes

  return [
    '$totalPieces قطعة',
    '$totalBoxEquivalent صندوق \n $remainingPieces قطعة \n $finoBoxes باسكت فينو'
  ];
}
