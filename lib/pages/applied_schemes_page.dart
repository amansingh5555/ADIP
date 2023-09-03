import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';



class AppliedSchemesPage extends StatefulWidget {
  @override
  _AppliedSchemesPageState createState() => _AppliedSchemesPageState();
}

class _AppliedSchemesPageState extends State<AppliedSchemesPage> {
  FlutterTts flutterTts = FlutterTts();

  List<SchemeInfo> schemes = [
    SchemeInfo(
      schemeName: 'Scheme 1',
      schemeId: '123',
      dateOfAppointment: '2023-08-20',
      address: '123 Main St, City',
      pincode: '12345',
      description: 'This is the description for Scheme 1.',
    ),
    SchemeInfo(
      schemeName: 'Scheme 2',
      schemeId: '456',
      dateOfAppointment: '2023-08-21',
      address: '456 Elm St, Town',
      pincode: '67890',
      description: 'This is the description for Scheme 2.',
    ),
    // Add more schemes here
  ];

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applied Schemes'),
      ),
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          return SchemeExpansionTile(
            schemeInfo: schemes[index],
            flutterTts: flutterTts,
          );
        },
      ),
    );
  }
}

class SchemeInfo {
  final String schemeName;
  final String schemeId;
  final String dateOfAppointment;
  final String address;
  final String pincode;
  final String description;

  SchemeInfo({
    required this.schemeName,
    required this.schemeId,
    required this.dateOfAppointment,
    required this.address,
    required this.pincode,
    required this.description,
  });
}

class SchemeExpansionTile extends StatelessWidget {
  final SchemeInfo schemeInfo;
  final FlutterTts flutterTts;

  SchemeExpansionTile({required this.schemeInfo, required this.flutterTts});

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _speakDetails() async {
    String details = '${schemeInfo.schemeName}, Scheme ID: ${schemeInfo.schemeId}, '
        'Date of Appointment: ${schemeInfo.dateOfAppointment}, '
        'Address: ${schemeInfo.address}, Pincode: ${schemeInfo.pincode}, '
        'Description: ${schemeInfo.description}';

    await _speak(details);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              schemeInfo.schemeName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24, // Increased font size
                color: Colors.indigo,
              ),
            ),
            IconButton(
              onPressed: () {
                _speakDetails();
              },
              icon: Icon(
                Icons.volume_up,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Increased vertical spacing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.indigo,
                ),
                SizedBox(height: 12), // Increased spacing
                Text(
                  'Scheme ID: ${schemeInfo.schemeId}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increased font size
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8), // Increased spacing
                Text(
                  'Date of Appointment: ${schemeInfo.dateOfAppointment}',
                  style: TextStyle(fontSize: 18), // Increased font size
                ),
                SizedBox(height: 8), // Increased spacing
                Text(
                  'Address: ${schemeInfo.address}',
                  style: TextStyle(fontSize: 18), // Increased font size
                ),
                SizedBox(height: 8), // Increased spacing
                Text(
                  'Pincode: ${schemeInfo.pincode}',
                  style: TextStyle(fontSize: 18), // Increased font size
                ),
                SizedBox(height: 16), // Increased spacing
                Divider(
                  thickness: 2,
                  color: Colors.indigo,
                ),
                SizedBox(height: 12), // Increased spacing
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increased font size
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8), // Increased spacing
                Text(
                  schemeInfo.description,
                  style: TextStyle(fontSize: 18), // Increased font size
                ),
                SizedBox(height: 12), // Increased spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}
