import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'attendance_list_page.dart';
import 'attendance_page.dart';


const _credentials = r'''
{
  "type": "service_account",
  "project_id": "vibes-387319",
  "private_key_id": "1218cd57864fdbd118607580b936217f5b2005dd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDNU0+oAkxbsnak\ng3NRI8i6IU+8ZP6Of2Cv10Adesdu9kkGMzeW7KOaQb0Vi94n5tED1gux2LLGBiCj\nSl5fPYRj8GI4t6rGaVGgI4i3B+5BtcuNCvC63sdqDBic+w6viEjsE7VXoReLXdFL\nV8ogJbJSlVhDQvzP+1HM47Hr80d4lgwprZvVtuQgb1kgyYyj6H6dKV31GozlOZ4a\n57MLsfBSAihMibdpZbWSmrjJ9UTWzkverD4fjIgRDOGT8R0JhTRCNeux8Zq7zqzB\n/mVF7KXwIKENl7bGQ3NqF6f8OGHn2Z+mWN00Hxvh1Hr9pW26WqEqNblRkLkGVvNO\n/72OVdNHAgMBAAECggEADBqCtpRGY8H6tnOq+dyATDwDUyK6rjQHwzXYICS//uRi\npVWiJx+VanqcJrVuvq8fjtPneEtndnXEAnwzYWR1Y5USd3iY0CJDOouP+72O8Paw\nEhdmS3JT7iraYAMvipP7YHvSpheeOdUXQBNRd6o8pBufE6JAju4V3aVl6y6ntKAX\ngm21xnHqqSi31K7zBtfeeqc53yX5pDrOfAw7p/YCBqSXmfiMhZH6lCTctTmFnw7t\nwcfA36RBDmbUlq7DodoRPkToOnu0xH/3aeU8EJK4fiSJkWZnwnRfH9CBTUTEgdcF\newIROGxntixG6RdnuZ7xHSp9HM0kYOdXQeR0gf7HoQKBgQD0GRBtMFFD7E/d7Eqc\n8n9V5jdb6lPY44rcnk48z6CadIKrdWQXPfaqJvt/MHDzbPGowuQkaw7nftY+2tGM\nXsMNGTYDTlxFSvPovekP2hihXQuBzKcqqYd10Jc1JCIa5rPWdTVrEZoVUApevqoD\nm6PbY2edvneVnCN9uHm6rwqgdwKBgQDXVkWuIR1rI67hCXd3s32mwOxtBokx5WyT\nf8U+opLCzw8CtJWqcTmMr3xeuwqGJAxtJBGcbcmC0nW/sbdUHe/oQxHStqVabOpL\n28oKX/PeMoOClE/h4xz0W4fkFjXfROuhqIVXe5hMvlbSquqCngfhHi2O1lcTF3u0\nqoavajtnsQKBgQCxcGbYeH8aePW1xMaYQE8AClHDpxs8Vmvi49DLs8JzhK5YJQWV\nP53HIn8/fd8dlNw2aTWeo5Q6A6GKH1akS15Obz0sOhIo7MtRLHv24ft1kUWEHViH\nUqT9p5vDLXj9RScFhj5Gjo0LYRuos8CyzrjWCfSQXpxfTRkfkrIqWoPHEQKBgQC4\n//V9VBXiJhXoYCmzPRGGYdi9EhBsPZ66WdsrpKBRnXJX8K1kcUHwDBPdjvPLqszC\nN2qp6ehl7EodFqFaMx4ZfQWi8ie9ODVSVtGNeEIbc2polOLMPkJx7PEik7JUzvFh\nQVbNgfGmfSA6fXxcG0jJrxOU07CbRmGRJa/wpGPFAQKBgQDmJU/lMzGLSYLhsQfl\nyBt0mUZ2Yp4Tfd1ttIN66dnaMz3RkATEDIngh14e1R+jaO2ZJuad4n4ixnk+ao+N\nweR/vvSPOiCRXAKIi0ulDscfWFbBzHuGql7Epz6pCE2Y2cOKF8/Wpn00cScCHRT6\nIBg8XK+xcTGNwBETFldohdcehQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "vibes-attendance-app@vibes-387319.iam.gserviceaccount.com",
  "client_id": "108811484370089265341",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/vibes-attendance-app%40vibes-387319.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';

const _spreadSheetId = '1Z3pyd8D1YlFun-VRYPita556mJtDAy1TuKICjmTPI0g';


class VehiclePage extends StatefulWidget {
  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final TextEditingController _vehicleNumberController = TextEditingController();

  final TextEditingController _endController = TextEditingController();

  final TextEditingController _fuelRefill1Controller = TextEditingController();

  final TextEditingController _fuelRefill2Controller = TextEditingController();

  final TextEditingController _fuelRefill3Controller = TextEditingController();

  Future<String> _getExistingData(int columnIndex) async {
  final gsheets = GSheets(_credentials);
  final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);
  final sheet = spreadsheet.sheets[1];

  final currentDateRowIndex = await _findCurrentDateRowIndex(sheet);
  if (currentDateRowIndex == -1) {
    return ''; // Return empty string if the current date is not found
  }

  final values = await sheet.values.row(currentDateRowIndex);

  print(values[6]);
  print(values[6].runtimeType);

  return values[columnIndex-1];

// Return empty string if the data is not found in the specified column
}

  Future<void> writeToGoogleSheet(BuildContext context) async {
    // Create a GSheets instance
    final gsheets = GSheets(_credentials);

    // Load the spreadsheet using its ID
    final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);

    // Access the first sheet in the spreadsheet
    final sheet = spreadsheet.sheets[1];

    // Get the vehicle number entered by the user
    final vehicleNumber = _vehicleNumberController.text;

    final currentDateRowIndex = await _findCurrentDateRowIndex(sheet);
    print(currentDateRowIndex);

    final data = vehicleNumber;
    print(data);

    // Append the data to the sheet
    await sheet.values.insertValue(data,column: 2,row: currentDateRowIndex);
  }

  Future<void> writeToGoogleSheet2(BuildContext context) async {
    // Create a GSheets instance
    final gsheets = GSheets(_credentials);

    // Load the spreadsheet using its ID
    final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);

    // Access the first sheet in the spreadsheet
    final sheet = spreadsheet.sheets[1];

    // Get the vehicle number entered by the user
    final vehicleNumber = _endController.text;

    final currentDateRowIndex = await _findCurrentDateRowIndex(sheet);
    print(currentDateRowIndex);

    final data = vehicleNumber;
    print(data);

    // Append the data to the sheet
    await sheet.values.insertValue(data,column: 3,row: currentDateRowIndex);
  }

  Future<void> writeToGoogleSheet3(BuildContext context) async {
    // Create a GSheets instance
    final gsheets = GSheets(_credentials);

    // Load the spreadsheet using its ID
    final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);

    // Access the first sheet in the spreadsheet
    final sheet = spreadsheet.sheets[1];

    // Get the vehicle number entered by the user
    final vehicleNumber = _fuelRefill1Controller.text;

    final currentDateRowIndex = await _findCurrentDateRowIndex(sheet);
    print(currentDateRowIndex);

    final data = vehicleNumber;
    print(data);

    // Append the data to the sheet
    await sheet.values.insertValue(data,column: 5,row: currentDateRowIndex);
  }

Future<void> writeToGoogleSheet4(BuildContext context) async {
    // Create a GSheets instance
    final gsheets = GSheets(_credentials);

    // Load the spreadsheet using its ID
    final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);

    // Access the first sheet in the spreadsheet
    final sheet = spreadsheet.sheets[1];

    // Get the vehicle number entered by the user
    final vehicleNumber = _fuelRefill2Controller.text;

    final currentDateRowIndex = await _findCurrentDateRowIndex(sheet);
    print(currentDateRowIndex);

    final data = vehicleNumber;
    print(data);

    // Append the data to the sheet
    await sheet.values.insertValue(data,column: 6,row: currentDateRowIndex);
  }

  Future<void> writeToGoogleSheet5(BuildContext context) async {
    // Create a GSheets instance
    final gsheets = GSheets(_credentials);

    // Load the spreadsheet using its ID
    final spreadsheet = await gsheets.spreadsheet(_spreadSheetId);

    // Access the first sheet in the spreadsheet
    final sheet = spreadsheet.sheets[1];

    // Get the vehicle number entered by the user
    final vehicleNumber = _fuelRefill3Controller.text;

    final currentDateRowIndex = await _findCurrentDateRowIndex(sheet);
    print(currentDateRowIndex);

    final data = vehicleNumber;
    print(data);

    // Append the data to the sheet
    await sheet.values.insertValue(data,column: 7,row: currentDateRowIndex);
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
          return i+1; // Adding 1 to account for header row
          print(i+1);
        }
      }
    }

    return -1; // Return -1 if the current date is not found in the first column
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('  Vehicle Page'),
      automaticallyImplyLeading: false,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getExistingData(2), // Pass the column index as an argument
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _vehicleNumberController.text = snapshot.data!;
                    }
                    return TextField(
                      controller: _vehicleNumberController,
                      decoration: InputDecoration(
                        labelText: 'Start',
                      ),
                      enabled: snapshot.hasData && snapshot.data != "" ? false : true,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () async {
        await writeToGoogleSheet(context);
        setState(() {
          _vehicleNumberController.clear();
        });
      },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getExistingData(3), // Use the appropriate column index
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _endController.text = snapshot.data!;
                    }
                    return TextField(
                      controller: _endController,
                      decoration: InputDecoration(
                        labelText: 'End',
                      ),
                      enabled: snapshot.hasData && snapshot.data != "" ? false : true,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () async {
        await writeToGoogleSheet2(context);
        setState(() {
          _endController.clear();
        });
      },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getExistingData(5), // Use the appropriate column index
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _fuelRefill1Controller.text = snapshot.data!;
                    }
                    return TextField(
                      controller: _fuelRefill1Controller,
                      decoration: InputDecoration(
                        labelText: 'Fuel Refill 1',
                      ),
                      enabled: snapshot.hasData && snapshot.data != "" ? false : true,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () async {
        await writeToGoogleSheet3(context);
        setState(() {
          _fuelRefill1Controller.clear();
        });
      },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getExistingData(6), // Use the appropriate column index
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _fuelRefill2Controller.text = snapshot.data!;
                    }
                    return TextField(
                      controller: _fuelRefill2Controller,
                      decoration: InputDecoration(
                        labelText: 'Fuel Refill 2',
                      ),
                      enabled: snapshot.hasData && snapshot.data != "" ? false : true,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
               onPressed: () async {
        await writeToGoogleSheet4(context);
        setState(() {
          _fuelRefill2Controller.clear();
        });
      },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getExistingData(7), // Use the appropriate column index
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _fuelRefill3Controller.text = snapshot.data!;
                    }
                    return TextField(
                      controller: _fuelRefill3Controller,
                      decoration: InputDecoration(
                        labelText: 'Fuel Refill 3',
                      ),
                      enabled: snapshot.hasData && snapshot.data != "" ? false : true,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () async {
        await writeToGoogleSheet5(context);
        setState(() {
          _fuelRefill3Controller.clear();
        });
      },
                child: Text('Submit'),
              ),
            ],
          ),
          
        ],
      ),
    ),
  );
}
}

