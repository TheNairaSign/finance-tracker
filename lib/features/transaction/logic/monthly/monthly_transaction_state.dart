import 'package:equatable/equatable.dart';
import 'package:finance_tracker/features/transaction/data/models/transaction.dart';

abstract class MonthlyTransactionState extends Equatable {
  const MonthlyTransactionState();
  
  @override
  List<Object> get props => [];
}

class MonthlyTransactionInitial extends MonthlyTransactionState {}

class MonthlyTransactionLoading extends MonthlyTransactionState {}

class MonthlyTransactionLoaded extends MonthlyTransactionState {
  final List<Transaction> transactions;

  const MonthlyTransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class MonthlyTransactionError extends MonthlyTransactionState {
  final String error;

  const MonthlyTransactionError(this.error);

  @override
  List<Object> get props => [error];
}