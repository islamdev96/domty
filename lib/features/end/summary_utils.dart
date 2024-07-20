import 'package:intl/intl.dart' as intl;

final Map<String, String> arabicNames = {
  'classic': 'كلاسيك',
  'croissant': 'كرواسون',
  'supreme': 'سوبريم',
  'double': 'دبل',
  'fino': 'فينو',
  'basket': 'باسكت',
  'aseer': 'عصير',
};

int getPiecesPerBox(String key) {
  switch (key) {
    case 'classic':
    case 'supreme':
      return 30;
    case 'croissant':
    case 'double':
      return 24;
    case 'fino':
      return 8;
    case 'basket':
      return 10;
    case 'aseer':
    default:
      return 1;
  }
}

double getPricePerPiece(String key) {
  if (key == 'fino') {
    return 20.0;
  } else {
    return 8.5;
  }
}

String formatCurrency(double amount) {
  return intl.NumberFormat('#,##0.00', 'ar_EG').format(amount);
}
