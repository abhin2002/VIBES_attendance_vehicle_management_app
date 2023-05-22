import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class AttendanceListPage extends StatefulWidget {
  final String credentials;
  final String spreadSheetId;

  AttendanceListPage({required this.credentials, required this.spreadSheetId});

  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  List<AttendanceItem> attendanceItems = [];

  get columnLetter1 => null;

  @override
  void initState() {
    super.initState();
    _fetchNamesFromSheet();
  }

  void _fetchNamesFromSheet() async {
    final gsheets = GSheets(widget.credentials);
    final ss = await gsheets.spreadsheet(widget.spreadSheetId);
    var sheet = ss.worksheetByTitle('Attendance');

    final values = await sheet?.values.row(1); // Read the first row

    if (values != null) {
      setState(() {
        attendanceItems = values
            .sublist(1) // Exclude the first element (name column)
            .asMap() // Convert to a map to access the index
            .map((index, cell) => MapEntry(
                  index,
                  AttendanceItem(name: cell, isPresent: false, date: ""),
                ))
            .values
            .toList();
      });
    }
  }

  void _toggleAttendance(int index, bool value) async {
    setState(() {
      attendanceItems[index].isPresent = value;
      attendanceItems[index].date = value ? "✕" : "";
    });

    final gsheets = GSheets(widget.credentials);
    final ss = await gsheets.spreadsheet(widget.spreadSheetId);
    var sheet = ss.worksheetByTitle('Attendance');

    final currentDateRowIndex = await _findCurrentDateRowIndex(sheet!);

    final columnIndex = index + 2; // Assuming the date column starts at index 2

    await sheet.values.insertValue(
      attendanceItems[index].date,
      column: columnIndex,
      row: currentDateRowIndex,
    );
  }

  Future<int> _findCurrentDateRowIndex(Worksheet sheet) async {
    final currentDate = DateTime.now();
    final googleSheetsReferenceDate = DateTime(1899, 12, 30); // Google Sheets reference date

    final difference = currentDate.difference(googleSheetsReferenceDate).inDays;
    final formattedDate = difference.toString();

    final values = await sheet.values.column(1); // Read the values in the first column

    if (values != null) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] == formattedDate) {
          return i + 1; // Adding 1 to account for header row
        }
      }
    }

    return -1; // Return -1 if the current date is not found in the first column
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance List"),
        backgroundColor: Color.fromRGBO(191, 7, 7, 0.858),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('lib/Vibes logo open page.png'), // Replace with your PNG image path
            fit: BoxFit.none,
          ),
        ),
        child: ListView.builder(
          itemCount: attendanceItems.length,
          itemBuilder: (context, index) {
            final attendanceItem = attendanceItems[index];
            return ListTile(
              title: Text(attendanceItem.name,
              style: TextStyle(fontSize: 20),),
              
              textColor: Colors.white,
              trailing: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white, // Set the checkbox color to white
            ),
            child: Checkbox(
              value: attendanceItem.isPresent,
              onChanged: (value) {
                _toggleAttendance(index, value ?? false);
              },
            ),
          ),
        
            );
          },
        ),
      ),
    );
  }
}

class AttendanceItem {
  final String name;
  bool isPresent;
  String date;

  AttendanceItem({required this.name, required this.isPresent, required this.date});

  set date1(String value) {
    date = value;
  }
}
