import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GrievancePage extends StatefulWidget {
  final String userId; // Unique user ID

  GrievancePage({required this.userId});

  @override
  _GrievancePageState createState() => _GrievancePageState();
}

class _GrievancePageState extends State<GrievancePage> {
  TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? userName; // Store user's name
  String? userEmail; // Store user's email

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      userEmail = user!.email; // Store user's email
      // Retrieve user's name from Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId) // Use the unique user ID
          .get()
          .then((docSnapshot) {
        if (docSnapshot.exists) {
          final userData = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            userName = userData['Full Name'] ?? '';
          });
        }
      });
    }

    // Create chat room collection for the user
    _createChatRoomCollection();
  }

  Future<void> _createChatRoomCollection() async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.userId)
        .set({'messages': []});
  }

  Future<void> _sendMessage() async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      final userDocRef =
      FirebaseFirestore.instance.collection('chat_rooms').doc(widget.userId);

      // Get the current messages array
      DocumentSnapshot docSnapshot = await userDocRef.get();
      List<Map<String, dynamic>> messages =
      List<Map<String, dynamic>>.from(docSnapshot.get('messages'));

      // Add a new message to the array
      messages.add({
        'senderId': user!.uid,
        'senderName': userName, // Add user name
        'senderEmail': userEmail, // Add user email
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the messages array in Firestore
      await userDocRef.update({'messages': messages});

      // Clear the message input field
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grievance Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(widget.userId) // Use the unique user ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text('No messages yet.'),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final messages = userData['messages'] ?? [];

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> messageData = messages[index];
                    return ListTile(
                      title: Text(messageData['message']),
                      subtitle: Text(
                        'Sent by: ${messageData['senderName']} (${messageData['senderEmail']})',
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: Text('Send Message'),
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
}
