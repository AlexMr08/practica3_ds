class Account {
  String number;
  double balance = 0;

  Account(this.number);

  void deposit(double amount) {
    if (0 < amount) {
      balance += amount;
      balance = (balance*100).roundToDouble() / 100;
    } else {
      throw ArgumentError("Cantidad invalida");
    }
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError("Cantidad invalida");
    }

    if (balance >= amount) {
      balance -= amount;
      balance = (balance*100).roundToDouble() / 100;
    } else {
      throw ArgumentError("Saldo insuficiente");
    }
  }
}