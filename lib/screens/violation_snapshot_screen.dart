import 'package:flutter/material.dart';
import 'package:viowatch/violations.dart';

class ViolationSnapshotScreen extends StatelessWidget {
  final Violation violation;

  const ViolationSnapshotScreen({super.key, required this.violation});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 17, 55, 101);

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Violation Snapshot'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
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
                          // Header
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

                          // Image card
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 90,
                                    color: Colors.grey,
                                  ),
                                ),
                                // Replace this Container with your actual Image widget.
                                // Example:
                                // child: Image.asset('assets/images/violation_photo.jpg', fit: BoxFit.cover),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Details card (bigger)
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
                                    titleFontSize: 20,
                                    valueFontSize: 18,
                                  ),
                                  InfoRow(
                                    title: 'Time of Occurrence',
                                    value: violation.time,
                                    titleFontSize: 20,
                                    valueFontSize: 18,
                                  ),
                                  InfoRow(
                                    title: 'Location',
                                    value: violation.location,
                                    titleFontSize: 20,
                                    valueFontSize: 18,
                                  ),
                                  InfoRow(
                                    title: 'Fine Amount',
                                    value: violation.fine,
                                    titleFontSize: 20,
                                    valueFontSize: 18,
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
