import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SchemePage(),
    theme: ThemeData(
      primaryColor: Colors.blue,
      hintColor: Colors.lightBlueAccent,
    ),
  ));
}

class Scheme {
  final String schemeId;
  final String schemeName;
  final String schemeDescription;

  Scheme({
    required this.schemeId,
    required this.schemeName,
    required this.schemeDescription,
  });
}

class SchemePage extends StatelessWidget {
  final GoogleTranslator translator = GoogleTranslator();

  Future<String> translateToMarathi(String text) async {
    try {
      Translation translation = await translator.translate(text, to: 'mr');
      return translation.text!;
    } catch (e) {
      print('Translation Error: $e');
      return text; // Return the original text if translation fails
    }
  }

  Widget buildSchemeCard(
      Color backgroundColor,
      String schemeName,
      String schemeDescription,
      int schemeNumber,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                  size: 25,
                ),
                SizedBox(width: 4),
                Text(
                  'Scheme #$schemeNumber',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              schemeName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            FutureBuilder<String>(
              future: translateToMarathi(schemeDescription),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error translating: ${snapshot.error}');
                } else {
                  final marathiDescription =
                      snapshot.data ?? schemeDescription;
                  return Container(
                    height: 100,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text(
                          marathiDescription,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // You can add buttons or actions here as needed.
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schemes'),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('schemes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final schemeDocs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: schemeDocs.length,
            itemBuilder: (context, index) {
              final schemeData =
              schemeDocs[index].data() as Map<String, dynamic>;

              final backgroundColor =
              index % 2 == 0 ? Colors.white : Colors.grey[200];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchemeDetailsPage(
                        scheme: Scheme(
                          schemeId: schemeData['schemeId'],
                          schemeName: schemeData['schemeName'],
                          schemeDescription:
                          schemeData['schemeDescription'],
                        ),
                      ),
                    ),
                  );
                },
                child: buildSchemeCard(
                  backgroundColor!,
                  schemeData['schemeName'],
                  schemeData['schemeDescription'],
                  index + 1,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SchemeDetailsPage extends StatefulWidget {
  final Scheme scheme;

  SchemeDetailsPage({required this.scheme});

  @override
  _SchemeDetailsPageState createState() => _SchemeDetailsPageState();
}

class _SchemeDetailsPageState extends State<SchemeDetailsPage> {
  late String userEmail;
  late String userName;
  late String userAddress;
  late String userPincode;
  bool applied = false;

  @override
  void initState() {
    super.initState();
    userEmail = '';
    userName = '';
    userAddress = '';
    userPincode = '';
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: userEmail)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          userName = userData['Full Name'] ?? '';
          userAddress = userData['Address'] ?? '';
          userPincode = userData['Pincode'] ?? '';
        });
      }
    });

    checkIfApplied();
  }

  void checkIfApplied() {
    FirebaseFirestore.instance
        .collection('applications')
        .where('schemeId', isEqualTo: widget.scheme.schemeId)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          applied = true;
        });
      }
    });
  }

  void applyNow() async {
    if (applied) {
      return;
    }

    String name = userName;
    String email = userEmail;
    String phone = '';
    String address = userAddress;
    String pincode = userPincode;

    if (name.isEmpty || email.isEmpty || address.isEmpty || pincode.isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('applications').add({
        'schemeId': widget.scheme.schemeId,
        'schemeName': widget.scheme.schemeName,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'pincode': pincode,
      });

      setState(() {
        applied = true;
      });
    } catch (e) {
      print('Error submitting application: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheme Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.scheme.schemeName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.scheme.schemeDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'User Email: $userEmail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Full Name: $userName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Address: $userAddress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Pincode: $userPincode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  if (!applied)
                    ElevatedButton(
                      onPressed: applyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Apply Now',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  if (applied)
                    Text(
                      'Applied',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  Spacer(),
                  SchemeTTSButton(
                    schemeDescription: widget.scheme.schemeDescription,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchemeTTSButton extends StatefulWidget {
  final String schemeDescription;

  SchemeTTSButton({required this.schemeDescription});

  @override
  _SchemeTTSButtonState createState() => _SchemeTTSButtonState();
}

class _SchemeTTSButtonState extends State<SchemeTTSButton> {
  final FlutterTts flutterTts = FlutterTts();
  bool isMuted = false;

  Future<void> speakDescription() async {
    if (isMuted) {
      return;
    }

    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(widget.schemeDescription);
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      if (isMuted) {
        flutterTts.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (isMuted) {
              toggleMute();
            } else {
              speakDescription();
            }
          },
          child: Icon(
            isMuted ? Icons.volume_off : Icons.volume_up,
            color: isMuted ? Colors.grey : Colors.green,
            size: 32,
          ),
        ),
        SizedBox(width: 8.0),
        GestureDetector(
          onTap: toggleMute,
          child: Icon(
            isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.red,
            size: 32,
          ),
        ),
      ],
    );
  }
}
