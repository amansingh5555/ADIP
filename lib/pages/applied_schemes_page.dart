import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AppliedSchemesPage extends StatefulWidget {
  @override
  _AppliedSchemesPageState createState() => _AppliedSchemesPageState();
}

class _AppliedSchemesPageState extends State<AppliedSchemesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  String generateSchemeDetails(DocumentSnapshot slot) {
    final schemeName = slot['schemeName'] ?? 'N/A';
    final schemeId = slot['schemeId'] ?? 'N/A';
    final slotDate = slot['slotDate'] ?? 'N/A';
    final slotPlace = slot['slotPlace'] ?? 'N/A';

    return "Scheme Name: $schemeName. Scheme ID: $schemeId. Slot Date: $slotDate. Slot Place: $slotPlace.";
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // Handle the case where the user is not authenticated.
      return Scaffold(
        body: Center(
          child: Text(
            'User not authenticated.',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Applied Schemes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('alloted_slots')
            .where('applicantId', isEqualTo: _user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
                strokeWidth: 4.0,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Icon(
                Icons.error,
                size: 100.0,
                color: Colors.red,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No allotted slots found.',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final slot = snapshot.data!.docs[index];
              final schemeDetails = generateSchemeDetails(slot);

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(
                    Icons.assignment,
                    size: 40.0,
                    color: Colors.teal,
                  ),
                  title: Text(
                    slot['schemeName'],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        'Scheme ID: ${slot['schemeId']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Slot Date: ${slot['slotDate']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Slot Place: ${slot['slotPlace']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () async {
                      await speakText(schemeDetails);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
