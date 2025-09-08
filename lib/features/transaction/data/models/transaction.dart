import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

enum TransactionType { income, expense }

@freezed
sealed class Transaction with _$Transaction {
  const factory Transaction({
    required String userId,
    String? id,
    required double amount,
    required String category,
    @DateTimeConverter() required DateTime date,
    @TransactionTypeConverter() required TransactionType type,
    String? note,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  factory Transaction.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Transaction.fromJson(data).copyWith(id: doc.id);
  }
}

/// Convert Firestore Timestamp <-> DateTime
class DateTimeConverter implements JsonConverter<DateTime, Timestamp> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Timestamp json) => json.toDate();

  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object);
}

/// Convert enum <-> String for Firestore
class TransactionTypeConverter implements JsonConverter<TransactionType, String> {
  const TransactionTypeConverter();

  @override
  TransactionType fromJson(String json) => TransactionType.values.firstWhere((e) => e.name == json);

  @override
  String toJson(TransactionType object) => object.name;
}
