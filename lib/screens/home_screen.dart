import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viowatch/screens/violation_stats.dart';
import 'smart_signal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int todayViolations = 0;
  int weekViolations = 0;
  int monthViolations = 0;
  int overallViolations = 0;
  Map<String, int> violationTypeDistribution = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchViolationStats();
  }

  Future<void> fetchViolationStats() async {
    final String apiUrl = 'http://10.0.2.2:8000/violations';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> data = decoded['violations'];
        int overallCount = data.length;

        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime startOfWeek = today.subtract(
          Duration(days: today.weekday - 1),
        );
        DateTime startOfMonth = DateTime(today.year, today.month, 1);

        int todayCount = 0;
        int weekCount = 0;
        int monthCount = 0;
        Map<String, int> typeCounts = {};

        for (var item in data) {
          List<String> types;
          if (item['violation_type'] is List) {
            types = List<String>.from(item['violation_type']);
          } else if (item['violation_type'] is String) {
            types = [item['violation_type']];
          } else {
            types = [];
          }

          DateTime vDate = DateTime.parse(item['date']);

          for (var type in types) {
            typeCounts[type] = (typeCounts[type] ?? 0) + 1;
          }

          if (isSameDate(vDate, today)) todayCount++;
          if (vDate.isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
            weekCount++;
          }
          if (vDate.isAfter(startOfMonth.subtract(const Duration(days: 1)))) {
            monthCount++;
          }
        }

        setState(() {
          todayViolations = todayCount;
          weekViolations = weekCount;
          monthViolations = monthCount;
          overallViolations = overallCount;
          violationTypeDistribution = typeCounts;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error loading stats. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : errorMessage.isNotEmpty
                  ? Text(errorMessage)
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png'),
                        const Text(
                          'VIOWATCH',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 17, 55, 101),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'AI for Safer Roads',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Violations Button
                        TextButton.icon(
                          icon: const Icon(
                            Icons.report_problem,
                            color: Colors.orange,
                          ),
                          label: const Text(
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
                                builder:
                                    (context) => ViolationStatsScreen(
                                      todayViolations: todayViolations,
                                      weekViolations: weekViolations,
                                      monthViolations: monthViolations,
                                      overallViolations: overallViolations,
                                      violationTypeDistribution:
                                          violationTypeDistribution,
                                    ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Smart Signal Monitor Button
                        TextButton.icon(
                          icon: const Icon(
                            Icons.traffic,
                            color: Color.fromARGB(255, 17, 55, 101),
                          ),
                          label: const Text(
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
                                builder: (context) =>  VioWatchProApp(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),

                        const SizedBox(height: 20),
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
