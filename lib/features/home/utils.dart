import 'package:flutter/material.dart';

int calculateTotalPieces(String key, int boxCount) {
  switch (key) {
    case 'classic':
    case 'supreme':
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
    case 'supreme':
      return ['${boxCount * 30} قطعة', '$boxCount باسكت'];
    case 'croissant':
    case 'double':
      int boxEquivalent = (boxCount * 24 / 30).floor();
      int remainingPieces = (boxCount * 24) % 30;
      return [
        '${boxCount * 24} قطعة',
        '$boxEquivalent باسكت \n$remainingPieces قطعة'
      ];
    case 'fino':
      return ['${boxCount * 8} قطعة', '$boxCount باسكت'];
    default:
      return ['$boxCount قطعة', '$boxCount باسكت'];
  }
}

List<String> calculateTotalBoxEquivalentForAll(
    Map<String, TextEditingController> boxControllers) {
  int totalPiecesOthers = 0;
  int finoPieces = 0;

  boxControllers.forEach((key, controller) {
    int pieces = calculateTotalPieces(key, int.tryParse(controller.text) ?? 0);
    if (key == 'fino') {
      finoPieces = pieces;
    } else {
      totalPiecesOthers += pieces;
    }
  });

  int totalBoxEquivalentOthers = (totalPiecesOthers / 30).floor();
  int remainingPiecesOthers = totalPiecesOthers % 30;

  int finoBoxes = (finoPieces / 8).floor();
  int remainingFinoPieces = finoPieces % 8;

  return [
    '$totalPiecesOthers قطعة', // Total pieces for other types
    '$totalBoxEquivalentOthers باسكت \n $remainingPiecesOthers قطعة\n'
        'فينو \n$finoBoxes باسكت \n $remainingFinoPieces قطعة'
  ];
}
