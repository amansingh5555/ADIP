import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:phirapply/pages/schemes_page.dart';
import 'applied_schemes_page.dart';
import 'grievance_page.dart';
import 'help_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  // Store user data
  final List<String> images = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
  ];

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  Timer? _timer;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    startTimer();
    // Fetch user data when the widget is initialized
    _fetchUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPageIndex < images.length - 1) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _fetchUserData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        userData = docSnapshot.data() as Map<String, dynamic>;
      });
    }
  }

  void _navigateToPage(String pageTitle) {
    _speak(pageTitle);
    if (pageTitle == 'Grievance Page') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GrievancePage(),
        ),
      );
    } else if (pageTitle == 'Schemes Page') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SchemePage(),
        ),
      );
    } else if (pageTitle == 'Applied Schemes') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppliedSchemesPage(),
        ),
      );
    } else if (pageTitle == 'Need Help') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HelpPage(),
        ),
      );
    }
    // Add more navigation conditions for other pages here
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String pageTitle,
  }) {
    return GestureDetector(
      onTap: () {
        _speak(title);
        _navigateToPage(pageTitle);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: Icon(
            icon,
            color: iconColor,
            size: 40,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              _speak(title);
            },
            child: Icon(
              Icons.volume_up,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.indigo,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/user_avatar.jpg'),
                      radius: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      userData?['Full Name'] ?? 'Name not available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user!.email ?? 'Email not available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userData?['Phone Number'] ?? 'Phone Number not available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userData?['Address'] ?? 'Address not available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userData?['Pincode'] ?? 'Pincode not available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Schemes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToPage('Schemes Page');
                },
              ),
              ListTile(
                title: Text(
                  'Applied Schemes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToPage('Applied Schemes');
                },
              ),
              ListTile(
                title: Text(
                  'Grievance',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToPage('Grievance Page');
                },
              ),
              ListTile(
                title: Text(
                  'Need Help',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToPage('Need Help');
                },
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              Container(
                color: Colors.indigo,
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();

                  },
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          _buildOptionCard(
            icon: Icons.assignment,
            iconColor: Colors.green,
            title: 'Schemes',
            pageTitle: 'Schemes Page',
          ),
          SizedBox(height: 16.0),
          _buildOptionCard(
            icon: Icons.event_available_outlined,
            iconColor: Colors.blueGrey,
            title: 'Applied Schemes',
            pageTitle: 'Applied Schemes',
          ),
          SizedBox(height: 24.0),
          _buildOptionCard(
            icon: Icons.message_outlined,
            iconColor: Colors.purple,
            title: 'Grievance',
            pageTitle: 'Grievance Page',
          ),
          SizedBox(height: 16.0),
          _buildOptionCard(
            icon: Icons.help,
            iconColor: Colors.brown,
            title: 'Need Help',
            pageTitle: 'Need Help',
          ),
          // Add more option cards here
        ],
      ),
    );
  }
}
