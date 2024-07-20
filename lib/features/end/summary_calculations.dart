import 'package:flutter/material.dart';
import 'summary_utils.dart';

String calculatePercentage(String returnedValue, String soldValue) {
  int returned = int.tryParse(returnedValue) ?? 0;
  int sold = int.tryParse(soldValue) ?? 0;
  if (sold == 0) return '0%';
  double percentage = (returned / sold) * 100;
  return '${percentage.toStringAsFixed(1)}%';
}

double calculateTotalRevenue(
  Map<String, TextEditingController> soldControllers,
  Map<String, TextEditingController> returnControllers,
  Map<String, TextEditingController> goodControllers,
  TextEditingController juiceSoldController,
  TextEditingController juiceReturnController,
  TextEditingController juiceGoodController,
) {
  double totalRevenue = 0.0;

  soldControllers.forEach((key, controller) {
    int soldQuantity = int.tryParse(controller.text) ?? 0;
    int returnQuantity = int.tryParse(returnControllers[key]!.text) ?? 0;
    int goodQuantity = int.tryParse(goodControllers[key]!.text) ?? 0;
    double pricePerPiece = getPricePerPiece(key);
    totalRevenue +=
        (soldQuantity - returnQuantity - goodQuantity) * pricePerPiece;
  });

  int juiceSoldQuantity = int.tryParse(juiceSoldController.text) ?? 0;
  int juiceReturnQuantity = int.tryParse(juiceReturnController.text) ?? 0;
  int juiceGoodQuantity = int.tryParse(juiceGoodController.text) ?? 0;
  totalRevenue +=
      (juiceSoldQuantity - juiceReturnQuantity - juiceGoodQuantity) * 180.0;

  return totalRevenue;
}
