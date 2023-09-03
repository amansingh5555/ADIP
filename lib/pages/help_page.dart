import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpPage extends StatefulWidget {
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline,
                  size: 50,
                  color: Colors.blue,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Department of Empowerment of Persons with Disabilities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                _buildInfoRow(Icons.location_on, 'Address', [
                  'B-I Block, Antyodaya Bhawan, CGO Complex,',
                  'Lodhi Road, New Delhi - 110003 (India)',
                ]),
                SizedBox(height: 32.0),
                _buildInfoRow(Icons.email, 'Email', [
                  'adipsection-depwd@gov.in',
                ], onTap: () => _launchEmail()),
                SizedBox(height: 32.0),
                _buildInfoRow(Icons.phone, 'Phone Numbers', [
                  '011 24369027',
                  '011 24365053',
                  '011 24369054',
                ]),
                SizedBox(height: 32.0),
                _buildInfoRow(Icons.phone_in_talk, 'ALIMCO Toll-Free Number', [
                  '18001805129',
                ]),
                SizedBox(height: 32.0), // Add more space if needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String title,
      List<String> items, {
        VoidCallback? onTap,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 32,
            ),
            SizedBox(width: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: InkWell(
                onTap: onTap,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 18,
                    color: onTap != null ? Colors.blue : null,
                    decoration: onTap != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  void _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'adipsection-depwd@gov.in',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
