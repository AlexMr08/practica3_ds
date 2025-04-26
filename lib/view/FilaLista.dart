
import 'package:flutter/material.dart';
import 'package:practica3_ds/logic/account.dart';

class FilaLista extends StatelessWidget {
  final Account elemento;
  final VoidCallback onPressed;

  const FilaLista(this.elemento, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              elemento.number,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Botón a la derecha
            Text(
              "${elemento.balance}€",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}