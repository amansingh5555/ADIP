import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: SlotAllotPage(),
    theme: ThemeData(
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      fontFamily: 'Roboto',
    ),
  ));
}

class SlotAllotPage extends StatefulWidget {
  @override
  _SlotAllotPageState createState() => _SlotAllotPageState();
}

class _SlotAllotPageState extends State<SlotAllotPage> {
  // Function to retrieve all applicants
  Future<List<QueryDocumentSnapshot>> getApplicants() async {
    QuerySnapshot applicantsSnapshot = await FirebaseFirestore.instance
        .collection('applications')
        .get();

    return applicantsSnapshot.docs;
  }

  // Function to allocate a slot to an applicant and save all user details
  Future<void> allocateSlot(
    String applicantId,
    String schemeId,
    String slotDate,
    String slotPlace,
    String schemeName,
    Map<String, dynamic> applicantData,
  ) async {
    // Create a document reference for the allocated slot
    DocumentReference slotReference =
        FirebaseFirestore.instance.collection('alloted_slots').doc();

    // Create a map containing all the data to be stored
    Map<String, dynamic> slotData = {
      'applicantId': applicantId,
      'schemeId': schemeId,
      'slotDate': slotDate,
      'slotPlace': slotPlace,
      'schemeName': schemeName, // Add schemeName
      'name': applicantData['name'],
      'email': applicantData['email'],
      // Add more fields as needed
    };

    // Save the data to the allocated slot document
    await slotReference.set(slotData);

    // Navigate back to the previous page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants List'),
      ),
      body: FutureBuilder(
        future: getApplicants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<QueryDocumentSnapshot> applicants =
              snapshot.data as List<QueryDocumentSnapshot>;

          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> applicantData =
                  applicants[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    'Name: ${applicantData['name']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Email: ${applicantData['email']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // When tapped, navigate to a new page to show detailed applicant information and allow slot allotment
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicantDetailsPage(
                          applicantData: applicantData,
                          allocateSlot: allocateSlot,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ApplicantDetailsPage extends StatefulWidget {
  final Map<String, dynamic> applicantData;
  final Function(String, String, String, String, String, Map<String, dynamic>) allocateSlot;

  ApplicantDetailsPage(
      {required this.applicantData, required this.allocateSlot});

  @override
  _ApplicantDetailsPageState createState() => _ApplicantDetailsPageState();
}

class _ApplicantDetailsPageState extends State<ApplicantDetailsPage> {
  String slotDate = '';
  String slotPlace = '';
  bool isSlotAllocated = false;

  @override
  void initState() {
    super.initState();
    checkSlotAllocation();
  }

  // Function to check if slots have already been allocated for this user and scheme
  void checkSlotAllocation() async {
    QuerySnapshot slotSnapshot = await FirebaseFirestore.instance
        .collection('alloted_slots')
        .where('applicantId', isEqualTo: widget.applicantData['userId'])
        .where('schemeId', isEqualTo: widget.applicantData['schemeId'])
        .get();

    setState(() {
      isSlotAllocated = slotSnapshot.docs.isNotEmpty;
      if (isSlotAllocated) {
        slotDate = slotSnapshot.docs[0]['slotDate'];
        slotPlace = slotSnapshot.docs[0]['slotPlace'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Applicant Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'Name: ${widget.applicantData['name']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                'Email: ${widget.applicantData['email']}',
                style: TextStyle(fontSize: 16),
              ),
              // Add more applicant details here
              SizedBox(height: 20),
              Text(
                'Applied Scheme Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'Applied Scheme: ${widget.applicantData['schemeName']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              // Display slot details if allocated
              if (isSlotAllocated)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slot Allotment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(height: 1, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Slot Date: $slotDate',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Slot Place: $slotPlace',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slot Allotment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(height: 1, color: Colors.grey),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          slotDate = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Place',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          slotPlace = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isSlotAllocated
                          ? null // Disable button if slot is already allocated
                          : () {
                              if (slotDate.isNotEmpty && slotPlace.isNotEmpty) {
                                // Allocate slot and save all user details
                                widget.allocateSlot(
                                  widget.applicantData['userId'],
                                  widget.applicantData['schemeId'],
                                  slotDate,
                                  slotPlace,
                                  widget.applicantData['schemeName'], // Pass schemeName
                                  widget.applicantData,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please fill in all slot details.'),
                                  ),
                                );
                              }
                            },
                      child: Text(isSlotAllocated ? 'Slot Allocated' : 'Allocate Slot'),
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
