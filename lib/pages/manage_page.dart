import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ManageSchemesPage(),
    theme: ThemeData.dark(),
  ));
}

class Scheme {
  final String schemeId;
  final String schemeName;
  final String schemeDescription;
  Scheme(this.schemeId, this.schemeName, this.schemeDescription);
}

class ManageSchemesPage extends StatefulWidget {
  @override
  _ManageSchemesPageState createState() => _ManageSchemesPageState();
}

class _ManageSchemesPageState extends State<ManageSchemesPage> {
  TextEditingController schemeIdController = TextEditingController();
  TextEditingController schemeNameController = TextEditingController();
  TextEditingController schemeDescriptionController = TextEditingController();

  bool isAddingScheme = false;

  void toggleAddingScheme() {
    setState(() {
      isAddingScheme = !isAddingScheme;
      if (!isAddingScheme) {
        schemeIdController.clear();
        schemeNameController.clear();
        schemeDescriptionController.clear();
      }
    });
  }

  void addScheme(String schemeId, String schemeName, String schemeDescription) async {
    final newScheme = Scheme(schemeId, schemeName, schemeDescription);

    try {
      // Reference to the Firestore collection where you want to store schemes.
      CollectionReference schemesCollection = FirebaseFirestore.instance.collection('schemes');

      // Add the scheme data to Firestore.
      await schemesCollection.add({
        'schemeId': newScheme.schemeId,
        'schemeName': newScheme.schemeName,
        'schemeDescription': newScheme.schemeDescription,
      });

      final snackBar = SnackBar(content: Text('Scheme added successfully'));

      // Check if the context is not null before showing the snackbar.
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      toggleAddingScheme();
    } catch (e) {
      // Handle any errors that might occur during Firestore data writing.
      print("Error adding scheme to Firestore: $e");
    }
  }

  bool _validateInput() {
    if (schemeIdController.text.isEmpty || schemeIdController.text.length != 5) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Scheme ID'),
            content: Text('Scheme ID should be 5 alphanumeric characters.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Schemes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Icon(
                    Icons.extension,
                    size: 64,
                    color: Colors.blue,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: toggleAddingScheme,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAddingScheme ? Colors.red : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  isAddingScheme ? 'Cancel' : 'Add Scheme',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16.0),
              if (isAddingScheme) ...[
                TextFormField(
                  controller: schemeIdController,
                  decoration: InputDecoration(
                    labelText: 'Scheme ID (5 alphanumeric characters)',
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: schemeNameController,
                  decoration: InputDecoration(
                    labelText: 'Scheme Name',
                    prefixIcon: Icon(Icons.label, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: schemeDescriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Scheme Description',
                    prefixIcon: Icon(Icons.description, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_validateInput()) {
                      addScheme(
                        schemeIdController.text,
                        schemeNameController.text,
                        schemeDescriptionController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Add Scheme',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExistingSchemesPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'View/Manage Existing Schemes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExistingSchemesPage extends StatefulWidget {
  @override
  _ExistingSchemesPageState createState() => _ExistingSchemesPageState();
}

class _ExistingSchemesPageState extends State<ExistingSchemesPage> {
  Future<void> _deleteScheme(String schemeId) async {
    try {
      CollectionReference schemesCollection =
          FirebaseFirestore.instance.collection('schemes');

      await schemesCollection.doc(schemeId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scheme deleted successfully'),
        ),
      );
    } catch (e) {
      print("Error deleting scheme from Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Schemes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('schemes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Widget> schemeWidgets = [];
          snapshot.data!.docs.forEach((DocumentSnapshot doc) {
            var schemeData = doc.data() as Map<String, dynamic>;
            var scheme = Scheme(
              schemeData['schemeId'],
              schemeData['schemeName'],
              schemeData['schemeDescription'],
            );
            schemeWidgets.add(
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(scheme.schemeName),
                  subtitle: Text(scheme.schemeDescription),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete this scheme?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteScheme(scheme.schemeId);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          });

          return ListView(
            children: schemeWidgets,
          );
        },
      ),
    );
  }
}
