import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class TotalWorkingDaysPage extends StatefulWidget {
  final String credentials;
  final String spreadsheetId;

  TotalWorkingDaysPage({required this.credentials, required this.spreadsheetId});

  @override
  _TotalWorkingDaysPageState createState() => _TotalWorkingDaysPageState();
}

class _TotalWorkingDaysPageState extends State<TotalWorkingDaysPage> {
  List<String> names = [];
  Map<String, int> personCrossCounts = {};

  @override
  void initState() {
    super.initState();
    fetchSheetData();
  }

  Future<void> fetchSheetData() async {
    final gsheets = GSheets(widget.credentials);
    final spreadsheet = await gsheets.spreadsheet(widget.spreadsheetId);

    final sheet = spreadsheet.sheets[0]; // Assuming the data is on the first sheet
    final rows = await sheet.values.allRows();

    // Fetch names from the first row
    final firstRow = rows[0];
    names = List<String>.from(firstRow.sublist(1)); // Exclude the first column

    // Initialize personCrossCounts with 0 counts for each person
    for (final name in names) {
      personCrossCounts[name] = 0;
    }

    // Calculate the total number of crosses in each person's column
    for (int rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      for (int columnIndex = 1; columnIndex < row.length; columnIndex++) { // Exclude the first column
        final name = names[columnIndex - 1];
        final value = row[columnIndex];
        if (value != null && value == '✕') {
          personCrossCounts[name] = personCrossCounts[name]! + 1;
        }
      }
    }

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Working Days'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          final name = names[index];
          final crossCount = personCrossCounts[name];

          return ListTile(
            title: Text(name),
            subtitle: Text('Total Present: ${crossCount ?? 0}'),
          );
        },
      ),
    );
  }
}
