import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'attendance_list_page.dart';
import 'record_page.dart';
import 'total_working_days.dart';
import 'package:vibes_attendance/home_page.dart';

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


class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final TextEditingController _nameController = TextEditingController();
void _addNameToSheet() async {
  final gsheets = GSheets(_credentials);
  final ss = await gsheets.spreadsheet(_spreadSheetId);
  var sheet = ss.worksheetByTitle('Attendance');
  final name = _nameController.text;

  // Determine the next available column
  final rowData = await sheet?.values.row(1);
  final nextColumn = rowData?.length != null ? rowData!.length + 1 : 1;

  // Insert the name in the first row of the next column
  await sheet?.values.insertValue(name, column: nextColumn, row: 1);

  _nameController.clear();
}


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Employee'),
        backgroundColor: Color.fromRGBO(191, 7, 7, 0.858),
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Background image
          Align(
      alignment: Alignment(0, -0.5), // Align the image at the top
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("lib/Vibes logo open page.png"), // Replace with your image path
            fit: BoxFit.none,
          ),
        ),
      ),
    ),
          // Content
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(child: SizedBox()), // Empty space to push content to the bottom
                Column(
                  children: [
                    TextField(
  controller: _nameController,
  decoration: InputDecoration(
    labelText: 'Enter Employee Name',
    labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Set the label text color to red
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red), // Set the underline color to red
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red), // Set the underline color to red when the input field is focused
    ),
  ),
  style: TextStyle(color: Colors.red), // Set the input text color to red
),

                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _addNameToSheet,
                      style: ElevatedButton.styleFrom(primary: Color.fromRGBO(191, 7, 7, 0.858)),
                      child: Text('   Add   '),
                      
                      
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildDrawer() {
  final TextStyle optionTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18, // Adjust the font size as desired
  );

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
            image: DecorationImage(
              image: AssetImage("lib/Vibes logo.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: Text(
            '      Welcome to',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Add New Employee',
            style: optionTextStyle,
          ),
          onTap: () {
            Navigator.pop(context);
            // Handle option 1 tap
          },
        ),
        ListTile(
          title: Text(
            'Record',
            style: optionTextStyle,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordPage(credentials: _credentials, spreadsheetId: _spreadSheetId)),
            );
          },
        ),
        ListTile(
          title: Text(
            'Working Days & Wage',
            style: optionTextStyle,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TotalWorkingDaysPage(
                credentials: _credentials,
                spreadsheetId: _spreadSheetId,
              )),
            );
          },
        ),
        ListTile(
          title: Text(
            "Today's Attendance",
            style: optionTextStyle,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AttendanceListPage(credentials: _credentials, spreadSheetId: _spreadSheetId)),
            );
          },
        ),
        // Add more ListTile widgets for additional options
      ],
    ),
    backgroundColor: Color.fromRGBO(191, 7, 7, 0.858),
  );
}

}


void main() {
  runApp(MaterialApp(
    home: AttendancePage(),
  ));
}
