import 'package:flutter/material.dart';
import '../main.dart';


class SingleChoice extends StatefulWidget {
  final Transactions initialSelection;
  final ValueChanged<Transactions> onSelectionChanged;
  final bool cuentasDisponibles;
  final bool dosCuentasMin;

  const SingleChoice({
    super.key,
    required this.initialSelection,
    required this.onSelectionChanged,
    required this.cuentasDisponibles,
    required this.dosCuentasMin,
  });

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  late Transactions transactionView;

  @override
  void initState() {
    super.initState();
    transactionView = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Transactions>(
      segments: <ButtonSegment<Transactions>>[
        ButtonSegment<Transactions>(
          value: Transactions.ingresar,
          label: const Text('Ingresar'),
          icon: const Icon(Icons.calendar_view_day),
          enabled: widget.cuentasDisponibles,
        ),
        ButtonSegment<Transactions>(
          value: Transactions.retirar,
          label: Text('Retirar'),
          icon: Icon(Icons.calendar_view_week),
          enabled: widget.cuentasDisponibles,
        ),
        ButtonSegment<Transactions>(
          value: Transactions.enviar,
          label: const Text('Enviar'),
          icon: const Icon(Icons.calendar_view_month),
          enabled: widget.dosCuentasMin,
        ),
      ],
      selected: <Transactions>{transactionView},
      onSelectionChanged: (Set<Transactions> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          transactionView = newSelection.first;
        });
        widget.onSelectionChanged(transactionView); // <-- llamar al callback
      },
    );
  }
}
