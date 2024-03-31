import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phirapply/pages/grievance_admin.dart';
import 'package:phirapply/pages/manage_page.dart';
import 'package:phirapply/pages/grievance_admin.dart';
import 'package:phirapply/pages/slot_allot.dart';
import 'package:phirapply/pages/userdatabase.dart';


class AdminPage extends StatelessWidget {
  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text(
              'Logout',
              style:
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold, // You can adjust the font weight
                fontSize: 16, // You can adjust the font size
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildOptionCard(
              context,
              'Manage Schemes',
              'Add or remove assistance schemes.',
              Icons.extension,
              Colors.purple,
            ),
            buildOptionCard(
              context,
              'User Database',
              'View and manage user accounts.',
              Icons.people,
              Colors.teal,
            ),
            buildOptionCard(
              context,
              'Slot Allotting',
              'View and allot slot to user accounts.',
              Icons.line_axis_sharp,
              Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String routeName) {
    if (routeName == 'Manage Schemes') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManageSchemesPage()),
      );
    }
     if (routeName == 'Slot Allotting') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SlotAllotPage()),
      );
    }
     if (routeName == 'User Database') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserDatabasePage()),
      );
    }
    // Add navigation logic for other options here if needed
  }

  Widget buildOptionCard(BuildContext context, String title, String description, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        _navigateToPage(context, title);
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, size: 32.0, color: color),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text(description),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
