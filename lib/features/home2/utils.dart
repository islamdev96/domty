// Function to calculate total pieces based on box count
import 'package:flutter/material.dart';

int calculateTotalPieces(String key, int boxCount) {
  switch (key) {
    case 'classic':
      return boxCount * 30;
    case 'croissant':
    case 'supreme':
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
      return ['${boxCount * 30} قطعة', '$boxCount صندوق'];
    case 'croissant':
    case 'supreme':
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

// Function to calculate the total box equivalent for all types
List<String> calculateTotalBoxEquivalentForAll(
    Map<String, TextEditingController> boxControllers) {
  int totalPieces = 0;
  boxControllers.forEach((key, controller) {
    totalPieces +=
        calculateTotalPieces(key, int.tryParse(controller.text) ?? 0);
  });

  int totalBoxEquivalent = (totalPieces / 30).floor();
  int remainingPieces = totalPieces % 30;
  return [
    '$totalPieces قطعة',
    '$totalBoxEquivalent صندوق \n $remainingPieces قطعة'
  ];
}
