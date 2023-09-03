import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SchemePage(),
  ));
}

class Item {
  final String name;
  final String description;
  final String eligibility;
  final String applicationLink;

  Item({
    required this.name,
    required this.description,
    required this.eligibility,
    required this.applicationLink,
  });
}

class SchemePage extends StatelessWidget {
  final List<Item> items = [
    Item(
      name: 'Motorised Tricycle',
      description: 'Description for Motorised Tricycle...',
      eligibility: 'Eligibility criteria for Motorised Tricycle...',
      applicationLink: 'Link to apply for Motorised Tricycle',
    ),
    Item(
      name: 'Tricycle Conventional Hand Propelled (Hamrahi)',
      description: 'Description for Tricycle Conventional Hand Propelled...',
      eligibility: 'Eligibility criteria for Hamrahi...',
      applicationLink: 'Link to apply for Hamrahi',
    ),
    Item(
      name: 'Tricycle Conventional Right Hand Drive (Stuti)',
      description: 'Description for Tricycle Conventional Right Hand Drive...',
      eligibility: 'Eligibility criteria for Stuti...',
      applicationLink: 'Link to apply for Stuti',
    ),
    Item(
      name: 'Wheel Chair Folding Standard Model Adult Size (Saathi)',
      description: 'Description for Wheel Chair Folding Standard Model...',
      eligibility: 'Eligibility criteria for Saathi...',
      applicationLink: 'Link to apply for Saathi',
    ),
    Item(
      name: 'Wheel Chair Folding Child Size (MAMTA)',
      description: 'Description for Wheel Chair Folding Child Size...',
      eligibility: 'Eligibility criteria for MAMTA...',
      applicationLink: 'Link to apply for MAMTA',
    ),
    Item(
      name: 'Cerebral Palsy (CP) Chair',
      description: 'Description for Cerebral Palsy (CP) Chair...',
      eligibility: 'Eligibility criteria for CP Chair...',
      applicationLink: 'Link to apply for CP Chair',
    ),
    Item(
      name: 'Crutch Elbow Adjustable (ALUMINIUM) Size I',
      description: 'Description for Crutch Elbow Adjustable (ALUMINIUM) Size I...',
      eligibility: 'Eligibility criteria for Crutch Elbow (Size I)...',
      applicationLink: 'Link to apply for Crutch Elbow (Size I)',
    ),
    Item(
      name: 'Crutch Elbow Adjustable (ALUMINIUM) Size II',
      description: 'Description for Crutch Elbow Adjustable (ALUMINIUM) Size II...',
      eligibility: 'Eligibility criteria for Crutch Elbow (Size II)...',
      applicationLink: 'Link to apply for Crutch Elbow (Size II)',
    ),
    Item(
      name: 'Crutch Axilla Adjustable (ALUMINIUM) Extra Small',
      description: 'Description for Crutch Axilla Adjustable (ALUMINIUM) Extra Small...',
      eligibility: 'Eligibility criteria for Crutch Axilla (Extra Small)...',
      applicationLink: 'Link to apply for Crutch Axilla (Extra Small)',
    ),
    Item(
      name: 'Crutch Axilla Adjustable (ALUMINIUM) Small',
      description: 'Description for Crutch Axilla Adjustable (ALUMINIUM) Small...',
      eligibility: 'Eligibility criteria for Crutch Axilla (Small)...',
      applicationLink: 'Link to apply for Crutch Axilla (Small)',
    ),
    Item(
      name: 'Crutch Axilla Adjustable (ALUMINIUM) Medium',
      description: 'Description for Crutch Axilla Adjustable (ALUMINIUM) Medium...',
      eligibility: 'Eligibility criteria for Crutch Axilla (Medium)...',
      applicationLink: 'Link to apply for Crutch Axilla (Medium)',
    ),
    Item(
      name: 'Crutch Axilla Adjustable (ALUMINIUM) Large',
      description: 'Description for Crutch Axilla Adjustable (ALUMINIUM) Large...',
      eligibility: 'Eligibility criteria for Crutch Axilla (Large)...',
      applicationLink: 'Link to apply for Crutch Axilla (Large)',
    ),
    Item(
      name: 'WALKING STICK',
      description: 'Description for WALKING STICK...',
      eligibility: 'Eligibility criteria for WALKING STICK...',
      applicationLink: 'Link to apply for WALKING STICK',
    ),
    Item(
      name: 'Braille Cane Folding For Visually Handicapped (DELUXE)',
      description: 'Description for Braille Cane Folding (DELUXE)...',
      eligibility: 'Eligibility criteria for Braille Cane (DELUXE)...',
      applicationLink: 'Link to apply for Braille Cane (DELUXE)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  items[index].name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  items[index].description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ItemDetailsPage(item: items[index]),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('Apply', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ItemDetailsPage extends StatelessWidget {
  final Item item;

  ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              item.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              'Eligibility: ${item.eligibility}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement link opening using url_launcher package
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Apply Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
