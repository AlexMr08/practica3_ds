import '../logic/account.dart';

abstract class Transaction {
  String id;
  int amount;

  Transaction(this.id, this.amount);

  void apply(Account account){}
}