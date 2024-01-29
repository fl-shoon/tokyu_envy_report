import 'package:flutter/material.dart';

class PropertiesTable extends StatelessWidget {
  final List<String> properties;
  const PropertiesTable({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableHeader = ['表示する名前', '物件名'];

    return Container(
        width: 400,
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.4))),
        child: Table(
          border: TableBorder.all(color: theme.colorScheme.outline),
          columnWidths: const <int, TableColumnWidth>{
            // 0: IntrinsicColumnWidth(),
            // 1: FlexColumnWidth(),
            // 2: FixedColumnWidth(64),
            // 0: FixedColumnWidth(150),
            // 1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: tableHeader.map((e) {
                return TableCell(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: theme.colorScheme.surface,
                    child: Text(e, textAlign: TextAlign.center),
                  ),
                );
              }).toList(),
            ),
            ...List.generate(properties.length, (index) {
              return TableRow(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(vertical: BorderSide.none),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('物件${index + 1}'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(properties[index]),
                      ),
                    ),
                  ]);
            }),
          ],
        ));
  }
}
