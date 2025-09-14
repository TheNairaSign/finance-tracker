import 'package:finance_tracker/core/theme/category_colors.dart';
import 'package:flutter/material.dart';

enum TransactionCategory {
  food,
  transportation,
  housing,
  utilities,
  healthcare,
  entertainment,
  shopping,
  education,
  travel,
  insurance,
  savings,
  investments,
  gifts,
  charity,
  taxes,
  other
}

extension TransactionCategoryExtension on TransactionCategory {
  String get name {
    switch (this) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.transportation:
        return 'Transportation';
      case TransactionCategory.housing:
        return 'Housing';
      case TransactionCategory.utilities:
        return 'Utilities';
      case TransactionCategory.healthcare:
        return 'Healthcare';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.education:
        return 'Education';
      case TransactionCategory.travel:
        return 'Travel';
      case TransactionCategory.insurance:
        return 'Insurance';
      case TransactionCategory.savings:
        return 'Savings';
      case TransactionCategory.investments:
        return 'Investments';
      case TransactionCategory.gifts:
        return 'Gifts';
      case TransactionCategory.charity:
        return 'Charity';
      case TransactionCategory.taxes:
        return 'Taxes';
      case TransactionCategory.other:
        return 'Other';
    }
  }
}

extension TransactionCategoryColorExtension on TransactionCategory {
  Color get color {
    switch (this) {
      case TransactionCategory.food:
        return AppCategoryColors.food;
      case TransactionCategory.transportation:
        return AppCategoryColors.transport;
      case TransactionCategory.housing:
        return AppCategoryColors.housing;
      case TransactionCategory.utilities:
        return AppCategoryColors.utilities;
      case TransactionCategory.healthcare:
        return AppCategoryColors.healthcare;
      case TransactionCategory.entertainment:
        return AppCategoryColors.entertainment;
      case TransactionCategory.shopping:
        return AppCategoryColors.shopping;
      case TransactionCategory.education:
        return AppCategoryColors.education;
      case TransactionCategory.travel:
        return AppCategoryColors.travel;
      case TransactionCategory.insurance:
        return AppCategoryColors.insurance;
      case TransactionCategory.savings:
        return AppCategoryColors.savings;
      case TransactionCategory.investments:
        return AppCategoryColors.investments;
      case TransactionCategory.gifts:
        return AppCategoryColors.gifts;
      case TransactionCategory.charity:
        return AppCategoryColors.charity;
      case TransactionCategory.taxes:
        return AppCategoryColors.taxes;
      case TransactionCategory.other:
        return Colors.blueGrey;
    }
  }
}

