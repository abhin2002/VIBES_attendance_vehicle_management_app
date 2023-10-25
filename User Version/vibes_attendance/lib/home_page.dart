import 'package:flutter/material.dart';
import 'package:vibes_attendance/attendance_page.dart'; // Import the AttendancePage widget
import 'package:vibes_attendance/vehicle_page.dart'; // Import the VehiclePage widget
import 'package:vibes_attendance/vehicle_home_page.dart'; // Import the VehicleHomePage widget

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AttendancePage(),
    VehiclePage(),
  ];

  void _onTabTapped(int index) {
    if (index == 1) {
      // If "Vehicle" tab is tapped (index 1), navigate to the VehicleHomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VehicleHome()),
      );
    } else {
      // For other tabs, just update the current index to switch the page
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehicle',
          ),
        ],
        backgroundColor: Color.fromRGBO(152, 29, 29, 1),
        selectedItemColor: Colors.white,
      ),
    );
  }
}
