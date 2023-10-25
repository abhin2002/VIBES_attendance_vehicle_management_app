import 'package:flutter/material.dart';
import 'package:vibes_attendance/attendance_page.dart'; // Import the AttendancePage widget
import 'package:vibes_attendance/vehicle_page.dart';
import 'package:vibes_attendance/vehicle_second.dart'; // Import the VehiclePage widget

class VehicleHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle the action when the first button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehiclePage(), // Navigate to the AttendancePage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Button background color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Button border radius
                ),
                elevation: 4.0, // Button elevation
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Button padding
              ),
              child: Text('Vehicle 1'), // Button text
            ),
            SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              onPressed: () {
                // Handle the action when the second button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleSecondPage(), // Navigate to the VehiclePage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red[900], // Button background color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Button border radius
                ),
                elevation: 4.0, // Button elevation
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Button padding
              ),
              child: Text('Vehicle 2'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}
