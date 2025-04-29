import 'package:practica3_ds/logic/transactions.dart';
import 'package:test/test.dart';
import 'package:practica3_ds/logic/account.dart';
import 'package:practica3_ds/logic/bank_service.dart';

void main() {
  group('Account', () {

    test('El balance inicial de una cuenta es cero', () {
      final account = Account('123');
      expect(account.balance, equals(0));
    });

    test('No permite depositar cantidades negativas o cero', () {
      final account = Account('123');
      expect(() => account.deposit(0), throwsArgumentError);
      expect(() => account.deposit(-50), throwsArgumentError);
    });

    test('No permite retirar cantidades negativas o cero', () {
      final account = Account('123');
      expect(() => account.withdraw(0), throwsArgumentError);
      expect(() => account.withdraw(-20), throwsArgumentError);
    });
  });

  group('Transaction', () {

    test('DepositTransaction.apply aumenta el saldo correctamente', () {
      final account = Account('123');
      final tx = DepositTransaction('tx1', 100);
      tx.apply(account);
      expect(account.balance, equals(100));
    });

    test('WithdrawalTransaction.apply lanza StateError con fondos insuficientes', () {
      final account = Account('123');
      final tx = WithdrawalTransaction('tx2', 50);
      expect(() => tx.apply(account), throwsStateError);
    });

    test('TransferTransaction.apply mueve fondos entre cuentas', () {
      final from = Account('123');
      from.deposit(300);
      final to = Account('456');
      final tx = TransferTransaction('tx3', 100, to);
      tx.apply(from);
      expect(from.balance, equals(200));
      expect(to.balance, equals(100));
    });
  });

  group('BankService', () {

    test('La lista inicial de cuentas está vacía', () {
      final bank = BankService();
      expect(bank.accounts.isEmpty, isTrue);
    });

    test('deposit aumenta el saldo de la cuenta', () {
      final bank = BankService();
      final account = bank.createAccount();
      bank.deposit(account, 150);
      expect(bank.getBalance(account), equals(150));
    });

    test('withdraw lanza StateError con saldo insuficiente', () {
      final bank = BankService();
      final account = bank.createAccount();
      expect(() => bank.withdraw(account, 50), throwsStateError);
    });

    test('transfer mueve fondos correctamente', () {
      final bank = BankService();
      final from = bank.createAccount();
      final to = bank.createAccount();
      bank.deposit(from, 300);
      bank.transfer(from, to, 100);
      expect(bank.getBalance(from), equals(200));
      expect(bank.getBalance(to), equals(100));
    });

    test('transfer lanza StateError con fondos insuficientes', () {
      final bank = BankService();
      final from = bank.createAccount();
      final to = bank.createAccount();
      expect(() => bank.transfer(from, to, 100), throwsStateError);
    });

    test('txId genera identificadores únicos', () {
      final bank = BankService();
      final acc = bank.createAccount();
      for (var i = 0; i < 1296; i++) {
        bank.deposit(acc, 100);
      }

      //Es un mapa con la id como indice por lo que la longitud es la cantidad de indices distintos
      //La cantidad de caracteres del generador esta puesta a 2 para que estemos seguros
      //aunque en el mundo real usaria muchos mas (36 caracteres por lo que 36*36=1296 posibilidades)
      expect(bank.transactions.length, equals(1296)); // Si se duplican se sobreescribiria alguno
    });
  });
}

