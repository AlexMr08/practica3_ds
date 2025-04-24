class Account {
  String number;
  int balance = 0;

  Account(this.number);

  void deposit(int amount) {
    if (0 < amount) {
      balance += amount;
    } else {
      throw ArgumentError("Cantidad invalida");
    }
  }

  void withdraw(int amount) {
    if (amount <= 0) {
      throw ArgumentError("Cantidad invalida");
    }

    if (balance >= amount) {
      balance -= amount;
    } else {
      throw ArgumentError("Saldo insuficiente");
    }
  }
}