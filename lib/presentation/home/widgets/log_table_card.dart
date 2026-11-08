import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/widgets.dart';

/// Data table card rendering system telemetry using BsTable.
/// Conforms to RULE-UI-006 and RULE-UI-001.
class LogTableCard extends StatelessWidget {
  const LogTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BsCard(
      header: const BsCardHeader(child: Text('Live Event Stream')),
      body: BsCardBody(
        children: const [
          BsTable(
            small: true,
            striped: true,
            hover: true,
            head: BsTableHead(
              rows: [
                BsTableRow(
                  children: [
                    BsTableCell.header(child: Text('Service')),
                    BsTableCell.header(child: Text('Target')),
                    BsTableCell.header(child: Text('Status')),
                  ],
                ),
              ],
            ),
            children: [
              BsTableRow(
                children: [
                  BsTableCell(child: Text('Core')),
                  BsTableCell(child: Text('Darwin/Win32')),
                  BsTableCell(child: Text('Active')),
                ],
              ),
              BsTableRow(
                children: [
                  BsTableCell(child: Text('Web')),
                  BsTableCell(child: Text('WASM/Mobile')),
                  BsTableCell(child: Text('Ready')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
