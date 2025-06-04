import 'package:flutter/material.dart';
import 'violations_screen.dart';
import 'smart_signal_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),

                // App Title
                Text(
                  'VIOWATCH',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 17, 55, 101),
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'AI for Safer Roads',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

                SizedBox(height: 40),

                // Violations Button
                TextButton.icon(
                  icon: Icon(Icons.report_problem, color: Colors.orange),
                  label: Text(
                    "Violations",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 17, 55, 101),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViolationsScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 17, 55, 101),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),

                SizedBox(height: 16),

                // Smart Signal Monitor Button
                TextButton.icon(
                  icon: Icon(
                    Icons.traffic,
                    color: Color.fromARGB(255, 17, 55, 101),
                  ),
                  label: Text(
                    "Smart Signal Monitor",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 17, 55, 101),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmartSignalScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 17, 55, 101),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),

                SizedBox(height: 20),

                // Quote
                Text(
                  'Obey rules. Save lives.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
