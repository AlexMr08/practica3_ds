//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practica3_ds/logic/account.dart';
import 'package:practica3_ds/logic/bank_service.dart';
import 'package:practica3_ds/view/AccountSelector.dart';
import 'package:practica3_ds/view/FilaLista.dart';
import 'package:practica3_ds/view/SingleChoice.dart';

late BankService bankService;

enum Transactions { ingresar, retirar, enviar }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de cuentas bancarias',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Gestor de cuentas bancarias'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Transactions selectedTransaction = Transactions.ingresar;
  final TextEditingController _amountController = TextEditingController();
  final bankService = BankService();
  String cadenaInput = "Cantidad a ingresar";
  String value = "0.0";
  String? selectedAccount1;
  String? selectedAccount2;

  void _handleTransactionChange(Transactions newSelection) {
    setState(() {
      selectedTransaction = newSelection;
      switch (selectedTransaction) {
        case Transactions.ingresar:
          cadenaInput = "Cantidad a ingresar";
          break;
        case Transactions.retirar:
          cadenaInput = "Cantidad a retirar";
          break;
        case Transactions.enviar:
          cadenaInput = "Cantidad a enviar";
          break;
      }
    });
    print('Seleccionaste: $newSelection');
  }

  void _createAccount() {
    setState(() {
      bankService.createAccount();
    });
  }

  void _doOperation() {
    switch (selectedTransaction) {
      case Transactions.ingresar:
        double amount = double.parse(_amountController.text);
        String account = selectedAccount1!;
        setState(() {
          bankService.accounts[account]?.deposit(amount);
        });
      //bankService.deposit(account, amount);
      case Transactions.retirar:
        double amount = double.parse(_amountController.text);
        String account = selectedAccount1!;
        setState(() {
          bankService.accounts[account]?.withdraw(amount);
        });
      //bankService.withdraw(account, amount);
      case Transactions.enviar:
        double amount = double.parse(_amountController.text);
        String account = selectedAccount1!;
        String other = selectedAccount2!;
        setState(() {
          Account fr = bankService.accounts[account]!;
          Account to = bankService.accounts[other]!;
          if (fr.balance >= amount) {
            fr.withdraw(amount);
            to.deposit(amount);
          }
        });
      //bankService.transfer(sender, recipient, amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: bankService.accounts.length,
                itemBuilder: (context, index) {
                  Account elem = bankService.accounts.values.toList()[index];
                  return FilaLista(elem, () {});
                },
              ),
            ),
            SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: _createAccount,
              child: const Text('Crear cuenta'),
            ),
            SizedBox(height: 8),
            SingleChoice(
              initialSelection: selectedTransaction,
              onSelectionChanged: _handleTransactionChange,
              cuentasDisponibles: bankService.accounts.isNotEmpty,
              dosCuentasMin: bankService.accounts.length >= 2,
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _amountController,
                enabled: bankService.accounts.isNotEmpty,
                keyboardType: TextInputType.number, // <-- Teclado numérico
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: cadenaInput,
                ),
              ),
            ),
            SizedBox(height: 8),
            AccountsSelector(
              accounts: bankService.accounts,
              opcion: selectedTransaction,
              onAccountsSelected: (key1, key2) {
                setState(() {
                  selectedAccount1 = key1;
                  selectedAccount2 = key2;
                });
                print('Cuenta 1 seleccionada: $selectedAccount1');
                print('Cuenta 2 seleccionada: $selectedAccount2');
              },
            ),
            SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: bankService.accounts.isNotEmpty ? _doOperation : null,
              child: const Text('Crear cuenta'),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}



