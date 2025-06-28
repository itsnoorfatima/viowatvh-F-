import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:viowatch/model/violation.dart';

class ViolationSnapshotScreen extends StatelessWidget {
  final Violation violation;

  const ViolationSnapshotScreen({super.key, required this.violation});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 17, 55, 101);

    // Decode base64 image
    final imageBytes = base64Decode(violation.imageBase64);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Violation Snapshot',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),

                          const SizedBox(height: 32),

                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoRow(
                                    title: 'Type of Violation',
                                    value: violation.type,
                                    titleFontSize: 20,
                                    valueFontSize: 18,
                                  ),
                                  InfoRow(
                                    title: 'Number Plate',
                                    value: violation.numberPlate,
                                  ),
                                  InfoRow(title: 'Date', value: violation.date),
                                  InfoRow(title: 'Time', value: violation.time),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fine Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  ...violation.violationTypes.map((type) {
                                    final fine = fineRates[type] ?? 0;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            type,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            '₹$fine',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                  const Divider(thickness: 1.2, height: 30),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Fine',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '₹${violation.totalFine}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final double titleFontSize;
  final double valueFontSize;

  const InfoRow({
    required this.title,
    required this.value,
    this.titleFontSize = 18,
    this.valueFontSize = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 17, 55, 101);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: valueFontSize, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
