import 'dart:math';
import 'package:practica3_ds/logic/account.dart';
import 'package:practica3_ds/logic/transactions.dart';
import '../models/transaction.dart';

class BankService {
  Map<String, Account> accounts = {};
  Map<String, (Account, Transaction)> transactions = {};
  static final Random _random = Random();

  String generateAccountId() {
    //Solo caracteres numericos
    String chars = '0123456789';
    String id;

    do {
      id = List.generate(15, (index) => chars[_random.nextInt(chars.length)]).join();
    } while (accounts.keys.contains(id));

    return id;
  }

  String generateTransactionId() {
    //Caracteres alfanumericos posibles
    String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String id;

    do {
      //Esta puesto con 2 caracteres para que estemos seguros de que son unicos
      //con los tests, en un caso real serian muchos mas.
      id = List.generate(2, (index) => chars[_random.nextInt(chars.length)]).join();
    } while (transactions.keys.contains(id));

    return id;
  }

  String createAccount() {
    Account acc = Account(generateAccountId());
    accounts[acc.number] = acc;
    return acc.number;
  }

  int getBalance(String account) {
    if(accounts[account] != null) {
      return accounts[account]!.balance;
    } else {
      throw ArgumentError("Cuenta inexistente");
    }
  }

  void deposit(account, int amount) {
    if(accounts[account] != null) {
      try {
        Transaction trans = DepositTransaction(generateTransactionId(), amount);
        trans.apply(accounts[account]!);
        transactions[trans.id] = (accounts[account]!, trans);
      } on Exception {
        rethrow;
      }
    } else {
      throw ArgumentError("Cuenta inexistente");
    }
  }

  void withdraw(account, int amount) {
    if(accounts[account] != null) {
      try {
        Transaction trans = WithdrawalTransaction(generateTransactionId(), amount);
        trans.apply(accounts[account]!);
        transactions[trans.id] = (accounts[account]!, trans);
      } on Exception {
        rethrow;
      }
    } else {
      throw ArgumentError("Cuenta inexistente");
    }
  }

  void transfer(sender, recipient, int amount) {
    if(accounts[sender] != null && accounts[recipient] != null) {
      try {
        Transaction trans = TransferTransaction(generateTransactionId(), amount, accounts[recipient]!);
        trans.apply(accounts[sender]!);
        transactions[trans.id] = (accounts[sender]!, trans);
      } on Exception {
        rethrow;
      }
    } else {
      throw ArgumentError("Cuenta inexistente");
    }
  }
}