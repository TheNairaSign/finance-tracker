// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  userId: json['userId'] as String,
  id: json['id'] as String?,
  amount: (json['amount'] as num).toDouble(),
  category: json['category'] == null
      ? TransactionCategory.other
      : const TransactionCategoryConverter().fromJson(json['category'] as String),
  date: const DateTimeConverter().fromJson(json['date'] as Timestamp),
  type: json['type'] == null
      ? TransactionType.income
      : const TransactionTypeConverter().fromJson(json['type'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'amount': instance.amount,
      'category': const TransactionCategoryConverter().toJson(instance.category),
      'date': const DateTimeConverter().toJson(instance.date),
      'type': const TransactionTypeConverter().toJson(instance.type),
      'note': instance.note,
    };
