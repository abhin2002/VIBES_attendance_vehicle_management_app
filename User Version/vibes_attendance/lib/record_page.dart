import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class RecordPage extends StatefulWidget {
  final String credentials;
  final String spreadsheetId;

  RecordPage({
    required this.credentials,
    required this.spreadsheetId,
  });

  @override
  _RecordPageState createState() => _RecordPageState();
}
class _RecordPageState extends State<RecordPage> {
  late GSheets _gsheets;
  Worksheet? _worksheet;
  List<dynamic> _headers = [];
  List<List<dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _gsheets = GSheets(widget.credentials);
    _loadData();
  }

  Future<void> _loadData() async {
    final spreadsheet = await _gsheets.spreadsheet(widget.spreadsheetId);
    _worksheet = spreadsheet.worksheetByTitle('Attendance');
    _headers = (await _worksheet?.values.row(1))!.cast<dynamic>();
    _data = (await _worksheet?.values.allRows())!.cast<List<dynamic>>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Page'),
      ),
      body: _buildDataTable(),
    );
  }

 Widget _buildDataTable() {
  if (_data.isEmpty) {
    return Center(child: CircularProgressIndicator());
  } else {
    // Remove the first row from the data
    final List<List<dynamic>> dataWithoutHeader = _data.sublist(1);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: _headers.map((header) => DataColumn(label: Text(header.toString()))).toList(),
          rows: dataWithoutHeader.map((row) {
            final cells = List<DataCell>.generate(
              _headers.length,
              (index) {
                final cellData = row.length > index ? row[index] : '';
                return DataCell(
                  _buildCellWidget(cellData),
                );
              },
            );
            return DataRow(cells: cells);
          }).toList(),
        ),
      ),
    );
  }
}

Widget _buildCellWidget(dynamic cellData) {

  // print(cellData.runtimeType);
  // print(cellData);

  final intValue = int.tryParse(cellData);
  
  if (intValue != null) {
    // print(intValue);
    // Convert the integer date to yyyy-MM-dd format
    final googleSheetsReferenceDate = DateTime(1899, 12, 30);
    final date = googleSheetsReferenceDate.add(Duration(days: intValue));
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    // print(formattedDate);
    
    return Text(formattedDate);
  } else if (cellData == 'X') {
    // Display a cross mark
    return Icon(Icons.close);
  } else {
    // Display the cell data as text
    return Text(cellData.toString());
  }
}


}
