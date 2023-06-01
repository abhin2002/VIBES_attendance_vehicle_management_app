import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class VehicleReport extends StatefulWidget {
  final String credentials;
  final String spreadsheetId;

  VehicleReport({required this.credentials, required this.spreadsheetId});

  @override
  State<VehicleReport> createState() => _VehicleReportState();
}

class _VehicleReportState extends State<VehicleReport> {

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
    _worksheet = spreadsheet.worksheetByTitle('Vehicle');
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

    // Get the indices of the first and fourth columns
    final firstColumnIndex = 0;
    final fourthColumnIndex = 3;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text(_headers[firstColumnIndex].toString())),
            DataColumn(label: Text(_headers[fourthColumnIndex].toString())),
          ],
          rows: dataWithoutHeader.map((row) {
            final cells = [
              DataCell(_buildCellWidget(row[firstColumnIndex],0)),
              DataCell(_buildCellWidget(row[fourthColumnIndex],3)),
            ];
            return DataRow(cells: cells);
          }).toList(),
        ),
      ),
    );
  }
}


Widget _buildCellWidget(dynamic cellData, int columnIndex) {
  if (columnIndex == 3) {
    // Display the cell data in the fourth column as it is
    return Text(cellData.toString());
  }

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

