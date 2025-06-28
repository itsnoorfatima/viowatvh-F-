import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viowatch/model/violation.dart';
import 'violation_snapshot_screen.dart';

class ViolationsScreen extends StatefulWidget {
  final String filter;

  const ViolationsScreen({super.key, required this.filter});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  List<Violation> allViolations = [];
  List<Violation> filteredViolations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchViolations();
  }

  Future<void> fetchViolations() async {
    const String apiUrl = 'http://10.0.2.2:8000/violations';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> data = decoded['violations'];

        setState(() {
          allViolations = data.map((e) => Violation.fromJson(e)).toList();
          filteredViolations = _applyFilter(widget.filter, allViolations);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load violations. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  List<Violation> _applyFilter(String filter, List<Violation> violations) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    return violations.where((violation) {
      final String dateStr = violation.date;
      final parsedDate = DateTime.tryParse(dateStr);
      if (parsedDate == null) return false;

      final onlyDate = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
      );

      switch (filter) {
        case 'today':
          return onlyDate == today;
        case 'this week':
          return onlyDate.isAfter(
            startOfWeek.subtract(const Duration(days: 1)),
          );
        case 'this month':
          return onlyDate.isAfter(
            startOfMonth.subtract(const Duration(days: 1)),
          );
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Violations - ${widget.filter.toUpperCase()}',  style: TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),),
        backgroundColor: const Color.fromARGB(255, 17, 55, 101),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : filteredViolations.isEmpty
                ? const Center(child: Text('No violations found.'))
                : ListView.builder(
                  itemCount: filteredViolations.length,
                  itemBuilder: (context, index) {
                    final violation = filteredViolations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ViolationSnapshotScreen(
                                  violation: violation,
                                ),
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
                                child: Image.memory(
                                  base64Decode(violation.imageBase64),
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
    );
  }
}
