import 'package:flutter/material.dart';
import 'package:taal/constants.dart';

class SamplingTable extends StatefulWidget {
  @override
  _SamplingTableState createState() => _SamplingTableState();
}

class _SamplingTableState extends State<SamplingTable> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notes Table"),
          backgroundColor: primary,
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: DataTable(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              rows: List.generate(freqModels.length, (i) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text('${freqModels[i].freq}'),
                    ),
                    DataCell(
                      Text('${freqModels[i].low}'),
                    ),
                    DataCell(
                      Text('${freqModels[i].high}'),
                    ),
                  ],
                );
              }),
              columns: [
                DataColumn(
                  label: Text(
                    'Notes',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Lower',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Upper',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
