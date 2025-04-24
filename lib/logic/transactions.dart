import '../models/transaction.dart';
import 'account.dart';

class DepositTransaction extends Transaction{

  DepositTransaction(super.id, super.amount);

  @override
  void apply(Account account) {
    account.deposit(amount);
  }
}

class WithdrawalTransaction extends Transaction{

  WithdrawalTransaction(super.id, super.amount);

  @override
  void apply(Account account) {
    try {
      account.withdraw(amount);
    } on ArgumentError catch (e) {
      throw StateError(e.message);
    }
  }
}

class TransferTransaction extends Transaction{
  Account recipient;

  TransferTransaction(super.id, super.amount, this.recipient);

  @override
  void apply(Account account) {
    try {
      account.withdraw(amount);
      recipient.deposit(amount);
    } on ArgumentError catch (e) {
      throw StateError(e.message);
    }
  }
}