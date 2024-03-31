import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GrievanceListPage extends StatefulWidget {
  @override
  _GrievanceListPageState createState() => _GrievanceListPageState();
}

class _GrievanceListPageState extends State<GrievanceListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grievance List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final List<QueryDocumentSnapshot> chatRoomDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatRoomDocs.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRoomDocs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(chatRoom['senderName'] ?? ''),
                subtitle: Text(chatRoom['subject'] ?? ''),
                onTap: () async {
                  final user = _auth.currentUser; // Fetch the current user
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GrievanceReplyPage(
                          chatRoom: chatRoom,
                          user: user, // Pass the user object to GrievanceReplyPage
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GrievanceReplyPage extends StatefulWidget {
  final Map<String, dynamic> chatRoom;
  final User user; // User object from Firebase Authentication

  GrievanceReplyPage({required this.chatRoom, required this.user});

  @override
  _GrievanceReplyPageState createState() => _GrievanceReplyPageState();
}

class _GrievanceReplyPageState extends State<GrievanceReplyPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grievance Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatMessages(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoom['chatRoomId']) // Use the chat room ID
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final List<QueryDocumentSnapshot> messageDocs = snapshot.data!.docs;
        final List<ChatMessage> messages = messageDocs
            .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ListTile(
              title: Text(message.text),
              subtitle: Text(message.senderId),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String messageText) {
    if (messageText.trim().isNotEmpty) {
      _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoom['chatRoomId']) // Use the chat room ID
          .collection('messages')
          .add({
        'text': messageText,
        'senderId': widget.user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}

class ChatMessage {
  final String text;
  final String senderId;
  final Timestamp timestamp;

  ChatMessage({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> data) {
    return ChatMessage(
      text: data['text'],
      senderId: data['senderId'],
      timestamp: data['timestamp'],
    );
  }
}
