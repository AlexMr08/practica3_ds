import 'package:flutter/material.dart';
import 'package:practica3_ds/logic/account.dart';
import '../main.dart';

class AccountsSelector extends StatefulWidget {
  final Map<String, Account> accounts;
  final opcion;
  final void Function(String? selected1, String? selected2) onAccountsSelected;

  const AccountsSelector({
    super.key,
    required this.accounts,
    required this.opcion,
    required this.onAccountsSelected,
  });

  @override
  State<AccountsSelector> createState() => _AccountsSelectorState();
}

class _AccountsSelectorState extends State<AccountsSelector> {
  String? selectedKey1;
  String? selectedKey2;

  void _notifyParent() {
    widget.onAccountsSelected(selectedKey1, selectedKey2);
  }

  @override
  Widget build(BuildContext context) {
    // Map filtrado para el segundo
    Map<String, Account> accountsForSecondDropdown = Map.of(widget.accounts)
      ..remove(selectedKey1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AccountDropdown(
          accounts: widget.accounts,
          selectedKey: selectedKey1,
          onSelected: (value) {
            setState(() {
              selectedKey1 = value;
              if (selectedKey1 == selectedKey2) {
                selectedKey2 = null; // Evitar duplicados
              }
              _notifyParent();
            });
          },
        ),

        const SizedBox(width: 8),
        if (widget.opcion == Transactions.enviar)
          AccountDropdown(
            accounts: accountsForSecondDropdown,
            selectedKey: selectedKey2,
            onSelected: (value) {
              setState(() {
                selectedKey2 = value;
                _notifyParent();
              });
            },
          ),
      ],
    );
  }
}

class AccountDropdown extends StatelessWidget {
  final Map<String, Account> accounts;
  final String? selectedKey;
  final ValueChanged<String?> onSelected;

  const AccountDropdown({
    super.key,
    required this.accounts,
    required this.selectedKey,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: selectedKey,
      label: Text("Selecciona una cuenta"),
      width: 250,
      enabled: accounts.isNotEmpty,
      dropdownMenuEntries:
      accounts.keys.map((key) {
        return DropdownMenuEntry<String>(value: key, label: key);
      }).toList(),
      onSelected: onSelected,
    );
  }
}