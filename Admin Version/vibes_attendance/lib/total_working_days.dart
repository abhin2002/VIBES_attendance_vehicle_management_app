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
  Map<String, String> personWage = {};

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

    // for (final name in names) {
    //   personWage[name] = 0;
    // }
    int rowIndex = 1;
    final row = rows[rowIndex];

    for (int columnIndex = 1; columnIndex < row.length; columnIndex++) { // Exclude the first column
        final name = names[columnIndex - 1];
        final value = row[columnIndex];
        print(name);
        print(value);
        // int? valueInt = int.tryParse(value);
        // personWage[name] = value as int;
        personWage[name] = value;
        
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
          final wage = personWage[name];
          final totalWage = crossCount! * int.parse(wage!);

          return Card(
  elevation: 4, // Controls the shadow depth
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8), // Rounds the corners
  ),
  child: ListTile(
    leading: Text(
      name,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold, // Adds a bold font weight
      ),
    ),
    title: Text(
      'Total Present: ${crossCount ?? 0}',
      style: TextStyle(
        color: Colors.blue, // Changes the text color to blue
      ),
    ),
    subtitle: Text(
      'Wage : $wage',
      style: TextStyle(
        fontStyle: FontStyle.italic, // Adds an italic font style
      ),
    ),
    trailing: Text(
      'Total Wage : $totalWage',
      style: TextStyle(
        color: Colors.green, // Changes the text color to green
      ),
    ),
  ),
);

        },
      ),
    );
  }
}
