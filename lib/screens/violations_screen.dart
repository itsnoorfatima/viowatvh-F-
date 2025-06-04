import 'package:flutter/material.dart';
import 'violation_snapshot_screen.dart';
import 'package:viowatch/violations.dart';

// Sample data
final List<Violation> violations = [
  Violation(
    type: 'Helmetless Riding',
    time: '2:35 PM',
    location: 'MG Bus Station Rd, Hyderabad',
    fine: '₹500',
    numberPlate: 'TG-02-ZY-3456',
  ),
  Violation(
    type: 'Helmetless Riding',
    time: '2:35 PM',
    location: 'MG Bus Station Rd, Hyderabad',
    fine: '₹500',
    numberPlate: 'TG-02-ZY-3456',
  ),
  Violation(
    type: 'Signal Jumping',
    time: '1:20 PM',
    location: 'NMDC Lakdikapul, Hyderabad',
    fine: '₹1000',
    numberPlate: 'TS-02-ZY-3456',
  ),
  Violation(
    type: 'Signal Jumping',
    time: '1:20 PM',
    location: 'NMDC Lakdikapul, Hyderabad',
    fine: '₹1000',
    numberPlate: 'TG-02-ZY-3456',
  ),
  Violation(
    type: 'Triple Riding',
    time: '4:10 PM',
    location: 'Banjara Hills Road No. 2, Hyderabad',
    fine: '₹1200',
    numberPlate: 'TG-02-ZY-3456',
  ),
];

class ViolationsScreen extends StatelessWidget {
  const ViolationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Violation Monitor'),
        backgroundColor: Color.fromARGB(255, 17, 55, 101),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Violations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 17, 55, 101),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Sample items
                itemBuilder: (context, index) {
                  final violation = violations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ViolationSnapshotScreen(violation: violation),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/violation.jpeg',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Violation ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${violation.type} Detected - ${violation.time}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
