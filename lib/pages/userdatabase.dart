import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabasePage extends StatefulWidget {
  @override
  _UserDatabasePageState createState() => _UserDatabasePageState();
}

class _UserDatabasePageState extends State<UserDatabasePage> {
  final TextEditingController _searchController = TextEditingController();
  late List<DocumentSnapshot> users = [];

  @override
  void initState() {
    super.initState();
    // Fetch users data when the widget is initialized
    _fetchUsersData();
  }

  Future<void> _fetchUsersData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      users = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Database',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the app bar color
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  // This will trigger a rebuild with the updated search query
                });
              },
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;

        // Filter users based on search query
        String searchQuery = _searchController.text.toLowerCase();
        String userName = userData['Full Name']?.toLowerCase() ?? '';

        if (userName.contains(searchQuery)) {
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Colors.indigo, // Change the card color
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink, // Change the avatar color
                child: Text(
                  userData['Full Name']?[0] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                userData['Full Name'] ?? '',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                userData['Email'] ?? '',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.white70,
                ),
              ),
              onTap: () {
                // Navigate to a detailed user profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(userData, onDelete: () {
                      // Callback to refresh the user list after deletion
                      _fetchUsersData();
                      Navigator.pop(context); // Close the UserDetailsPage after deletion
                    }),
                  ),
                );
              },
            ),
          );
        } else {
          // If the user doesn't match the search criteria, return an empty container
          return Container();
        }
      },
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onDelete;

  UserDetailsPage(this.userData, {required this.onDelete});

  Future<void> _deleteUser(BuildContext context) async {
    try {
      // Delete the user document from the collection
      await FirebaseFirestore.instance.collection("users").doc(userData['uid']).delete();
      onDelete(); // Trigger the callback to refresh the user list
      Navigator.pop(context); // Close the UserDetailsPage after deletion
    } catch (e) {
      // Handle delete error
      print('Delete error: $e');
      // You can show an error message or take other actions as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the app bar color
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Show a confirmation dialog before deletion
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Delete User',
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                  content: Text(
                    'Are you sure you want to delete this user?',
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteUser(context);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.pink, // Change the avatar color
              child: Text(
                userData['Full Name']?[0] ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Full Name: ${userData['Full Name']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            Text(
              'Phone Number: ${userData['Phone Number']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                color: Colors.indigo,
              ),
            ),
            Text(
              'Address: ${userData['Address']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                color: Colors.indigo,
              ),
            ),
            Text(
              'Pincode: ${userData['Pincode']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                color: Colors.indigo,
              ),
            ),
            Text(
              'Email: ${userData['Email']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
