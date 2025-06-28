import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:viowatch/screens/violations_screen.dart';

class ViolationStatsScreen extends StatelessWidget {
  final int todayViolations;
  final int weekViolations;
  final int monthViolations;
  final int overallViolations;
  final Map<String, int> violationTypeDistribution;

  const ViolationStatsScreen({
    super.key,
    required this.todayViolations,
    required this.weekViolations,
    required this.monthViolations,
    required this.overallViolations,
    required this.violationTypeDistribution,
  });

  @override
  Widget build(BuildContext context) {
    final entries = violationTypeDistribution.entries.toList();

    final List<Color> pieColors = [
      Colors.redAccent.shade400,
      Colors.blueAccent.shade400,
    ];

    final total = violationTypeDistribution.values.fold(0, (a, b) => a + b);

    final List<PieChartSectionData> pieChartSections =
        entries.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value.value;
          final color = pieColors[index % pieColors.length];

          return PieChartSectionData(
            color: color,
            value: value.toDouble(),
            title:
                total == 0
                    ? ''
                    : '${((value / total) * 100).toStringAsFixed(1)}%',
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Colors.black54,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          );
        }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Violation Statistics',
          style: TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 17, 55, 101),
        elevation: 3,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Violation Count Summary',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15, 
                children: [
                  _buildStatCard(
                    context,
                    'Today',
                    todayViolations,
                    Colors.redAccent.shade400,
                    Icons.today,
                    'today',
                  ),
                  _buildStatCard(
                    context,
                    'This Week',
                    weekViolations,
                    Colors.orangeAccent.shade400,
                    Icons.date_range,
                    'this week',
                  ),
                  _buildStatCard(
                    context,
                    'This Month',
                    monthViolations,
                    Colors.blueAccent.shade400,
                    Icons.calendar_month,
                    'this month',
                  ),
                  _buildStatCard(
                    context,
                    'Overall',
                    overallViolations,
                    Colors.green.shade600,
                    Icons.bar_chart,
                    'overall',
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Text(
                'Violation Type Distribution',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 320,
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    centerSpaceRadius: 45,
                    sectionsSpace: 4,
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(touchCallback: (_, __) {}),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 500),
                  swapAnimationCurve: Curves.easeInOut,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children:
                    entries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value.key;
                      final value = entry.value.value;
                      return _buildLegendItem(
                        pieColors[index % pieColors.length],
                        label,
                        value,
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    int count,
    Color color,
    IconData icon,
    String filterType,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViolationsScreen(filter: filterType),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
        shadowColor: Colors.black45,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.7),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$label : $count',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


// //black theme
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/services.dart';
// import 'package:viowatch/screens/violations_screen.dart';

// class ViolationStatsScreen extends StatelessWidget {
//   final int todayViolations;
//   final int weekViolations;
//   final int monthViolations;
//   final int overallViolations;
//   final Map<String, int> violationTypeDistribution;

//   const ViolationStatsScreen({
//     super.key,
//     required this.todayViolations,
//     required this.weekViolations,
//     required this.monthViolations,
//     required this.overallViolations,
//     required this.violationTypeDistribution,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final entries = violationTypeDistribution.entries.toList();

//     final List<Color> pieColors = [
//       Color(0xFFEF4444), // Red-500
//       Color(0xFF3B82F6), // Blue-500
//       Color(0xFFF59E0B), // Amber-500
//       Color(0xFF10B981), // Emerald-500
//       Color(0xFF8B5CF6), // Violet-500
//     ];

//     final total = violationTypeDistribution.values.fold(0, (a, b) => a + b);

//     final List<PieChartSectionData> pieChartSections = entries.asMap().entries.map((entry) {
//       final idx = entry.key;
//       final value = entry.value.value;
//       final color = pieColors[idx % pieColors.length];

//       return PieChartSectionData(
//         color: color,
//         value: value.toDouble(),
//         title: total == 0 ? '' : '${((value / total) * 100).toStringAsFixed(1)}%',
//         radius: 70,
//         titleStyle: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w700,
//           color: Colors.white,
//           shadows: [Shadow(blurRadius: 2, color: Colors.black54, offset: Offset(0, 1))],
//         ),
//       );
//     }).toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Violation Statistics',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//             letterSpacing: 1.3,
//           ),
//         ),
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Summary Header
//               const Text(
//                 'Summary',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Summary Cards Grid
//               GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1.2,
//                 children: [
//                   _buildSummaryCard(context, 'Today', todayViolations, Color(0xFFEF4444), Icons.today, 'today'),
//                   _buildSummaryCard(context, 'This Week', weekViolations, Color(0xFFF59E0B), Icons.date_range, 'week'),
//                   _buildSummaryCard(context, 'This Month', monthViolations, Color(0xFF3B82F6), Icons.calendar_month, 'month'),
//                   _buildSummaryCard(context, 'Overall', overallViolations, Color(0xFF10B981), Icons.bar_chart, 'overall'),
//                 ],
//               ),

//               const SizedBox(height: 40),

//               // Violation Type Distribution Header
//               const Text(
//                 'Violation Types',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Pie Chart Container
//               Center(
//                 child: Container(
//                   width: 320,
//                   height: 320,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1E1E1E),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.8),
//                         blurRadius: 20,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(24),
//                   child: PieChart(
//                     PieChartData(
//                       sections: pieChartSections,
//                       centerSpaceRadius: 55,
//                       sectionsSpace: 5,
//                       borderData: FlBorderData(show: false),
//                       pieTouchData: PieTouchData(touchCallback: (_, __) {}),
//                     ),
//                     swapAnimationDuration: const Duration(milliseconds: 450),
//                     swapAnimationCurve: Curves.easeInOutCubic,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // Legend
//               Wrap(
//                 spacing: 20,
//                 runSpacing: 20,
//                 children: entries.asMap().entries.map((entry) {
//                   final idx = entry.key;
//                   final label = entry.value.key;
//                   final value = entry.value.value;
//                   final color = pieColors[idx % pieColors.length];
//                   return _buildLegendItem(color, label, value);
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// Widget _buildSummaryCard(
//   BuildContext context,
//   String title,
//   int count,
//   Color color,
//   IconData icon,
//   String filterType,
// ) {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       // Set max height to avoid overflow and control sizing
//       double maxHeight = constraints.maxHeight > 0 ? constraints.maxHeight : 150;

//       return InkWell(
//         borderRadius: BorderRadius.circular(18),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ViolationsScreen(filter: filterType)),
//           );
//         },
//         splashColor: color.withOpacity(0.3),
//         child: Container(
//           constraints: BoxConstraints(
//             minHeight: 140,
//             maxHeight: maxHeight,
//           ),
//           decoration: BoxDecoration(
//             color: Color.alphaBlend(color.withOpacity(0.15), Colors.black),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(color: color.withOpacity(0.7), width: 1.3),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.25),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 36, color: color),
//               const SizedBox(height: 12),
//               Flexible(
//                 child: Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: color.withOpacity(0.9),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Flexible(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     count.toString(),
//                     style: const TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 1.3,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }


//   Widget _buildLegendItem(Color color, String label, int count) {
//     return Container(
//       width: 160,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF222222),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black87,
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 22,
//             height: 22,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(5),
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.6),
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Text(
//             count.toString(),
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
