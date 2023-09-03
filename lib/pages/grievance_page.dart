import 'package:flutter/material.dart';

class GrievancePage extends StatefulWidget {
  @override
  _GrievancePageState createState() => _GrievancePageState();
}

class _GrievancePageState extends State<GrievancePage> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isButtonAnimating = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitGrievance(BuildContext context) async {
    String subject = _subjectController.text;
    String description = _descriptionController.text;

    if (subject.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _isButtonAnimating = true;
      });

      // Simulate processing for 2 seconds
      await Future.delayed(Duration(seconds: 2));

      // Show a SnackBar indicating successful submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grievance submitted successfully!'),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _isButtonAnimating = false;
      });

      // Navigate back to previous screen
      Navigator.pop(context);
    } else {
      // Show an error message if subject or description is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in both subject and description.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grievance Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please submit your grievance here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Grievance Subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Grievance Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Builder( // Wrap the ElevatedButton with Builder widget
                builder: (context) {
                  return ElevatedButton(
                    onPressed: _isButtonAnimating ? null : () => _submitGrievance(context),
                    child: _isButtonAnimating
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                      '        Submit        ',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      elevation: 5,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


