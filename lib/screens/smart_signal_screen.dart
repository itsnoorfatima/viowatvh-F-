// --- Import ---
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(VioWatchProApp());

// --- App Wrapper ---
class VioWatchProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viowatch Smart Signal Pro Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: SmartSignalController(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Signal Enum ---
enum SignalState { red, yellow, green }

// --- Junction Model ---
class Junction {
  final String name;
  int vehicleCount;
  SignalState signal;
  double greenProgress;

  Junction({
    required this.name,
    this.vehicleCount = 0,
    this.signal = SignalState.red,
    this.greenProgress = 0.0,
  });
}

// --- Main Stateful Widget ---
class SmartSignalController extends StatefulWidget {
  @override
  _SmartSignalControllerState createState() => _SmartSignalControllerState();
}

class _SmartSignalControllerState extends State<SmartSignalController>
    with TickerProviderStateMixin {
  final List<Junction> junctions = [
    Junction(name: 'A'),
    Junction(name: 'B'),
    Junction(name: 'C'),
    Junction(name: 'D'),
  ];

  int currentGreenIndex = 0;
  Timer? vehicleUpdateTimer;
  late AnimationController progressController;
  final Random random = Random();

  final int greenDurationSeconds = 10;
  final int yellowDurationSeconds = 3;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: greenDurationSeconds),
    )..addListener(() {
      setState(() {
        junctions[currentGreenIndex].greenProgress = progressController.value;
      });
    });

    vehicleUpdateTimer = Timer.periodic(
      Duration(seconds: 5),
      (_) => _updateVehicleCounts(),
    );

    _updateVehicleCounts();
    _startSignalCycle();
  }

  @override
  void dispose() {
    vehicleUpdateTimer?.cancel();
    progressController.dispose();
    super.dispose();
  }

  void _updateVehicleCounts() {
    setState(() {
      for (var junc in junctions) {
        junc.vehicleCount = random.nextInt(11); // 0–10 vehicles
      }
    });
  }

  Future<void> _startSignalCycle() async {
    while (true) {
      int nextIndex = -1;
      for (int i = 0; i < junctions.length; i++) {
        int idx = (currentGreenIndex + i) % junctions.length;
        if (junctions[idx].vehicleCount > 0) {
          nextIndex = idx;
          break;
        }
      }

      if (nextIndex == -1) {
        setState(() {
          for (var junc in junctions) {
            junc.signal = SignalState.red;
            junc.greenProgress = 0.0;
          }
        });
        await Future.delayed(Duration(seconds: 5));
        continue;
      }

      currentGreenIndex = nextIndex;
      setState(() {
        for (int i = 0; i < junctions.length; i++) {
          junctions[i].signal =
              (i == currentGreenIndex) ? SignalState.green : SignalState.red;
          junctions[i].greenProgress = 0.0;
        }
      });

      await progressController.forward(from: 0.0);

      setState(() {
        junctions[currentGreenIndex].signal = SignalState.yellow;
      });
      await Future.delayed(Duration(seconds: yellowDurationSeconds));

      setState(() {
        junctions[currentGreenIndex].signal = SignalState.red;
        junctions[currentGreenIndex].greenProgress = 0.0;
      });

      currentGreenIndex = (currentGreenIndex + 1) % junctions.length;
    }
  }

  Widget _lightCircle(Color color, bool isOn) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: isOn ? 28 : 20,
      height: isOn ? 28 : 20,
      decoration: BoxDecoration(
        color: isOn ? color : color.withOpacity(0.3),
        shape: BoxShape.circle,
        boxShadow:
            isOn
                ? [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
                : [],
      ),
    );
  }

  Widget _buildTrafficLight(SignalState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lightCircle(Colors.red, state == SignalState.red),
        SizedBox(height: 8),
        _lightCircle(Colors.yellow, state == SignalState.yellow),
        SizedBox(height: 8),
        _lightCircle(Colors.green, state == SignalState.green),
      ],
    );
  }

  Widget _buildJunctionCard(Junction junc) {
    bool isActive = junc.signal == SignalState.green;
    int highestCount = junctions.map((j) => j.vehicleCount).reduce(max);
    bool isNext =
        junc.vehicleCount == highestCount && junc.signal == SignalState.red;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
                isActive ? Colors.greenAccent.withOpacity(0.5) : Colors.black54,
            blurRadius: isActive ? 18 : 8,
            spreadRadius: isActive ? 2 : 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Junction ${junc.name}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 12),
          _buildTrafficLight(junc.signal),
          SizedBox(height: 12),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: junc.vehicleCount),
            duration: Duration(milliseconds: 500),
            builder:
                (context, value, _) => Text(
                  'Vehicles: $value',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
          ),
          SizedBox(height: 8),
          if (junc.signal == SignalState.green)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: junc.greenProgress,
                minHeight: 10,
                backgroundColor: Colors.green.shade900,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.greenAccent.shade400,
                ),
              ),
            )
          else
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            
          if (isNext)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Next in Line',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Viowatch Smart Signal Pro Demo'),
  //       centerTitle: true,
  //       backgroundColor: Colors.black,
  //     ),
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: LayoutBuilder(
  //             builder: (context, constraints) {
  //               return Column(
  //                 children: [
  //                   ConstrainedBox(
  //                     constraints: BoxConstraints(
  //                       maxHeight: constraints.maxHeight,
  //                     ),
  //                     child: GridView.builder(
  //                       itemCount: junctions.length,
  //                       shrinkWrap: true,
  //                       physics: NeverScrollableScrollPhysics(),
  //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                         crossAxisCount: 2,
  //                         mainAxisSpacing: 16,
  //                         crossAxisSpacing: 16,
  //                         childAspectRatio: 0.9,
  //                       ),
  //                       itemBuilder: (context, index) {
  //                         return _buildJunctionCard(junctions[index]);
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Viowatch Smart Signal Pro Demo'),
      centerTitle: true,
      backgroundColor: Colors.black,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ROAD TITLE WITH ICON ---
                  Row(
                    children: [
                      Icon(Icons.traffic, color: Colors.amberAccent, size: 28),
                      SizedBox(width: 8),
                      Text(
                        "Panjagutta Junction Monitor",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey[700],
                    thickness: 1,
                    endIndent: 20,
                  ),
                  SizedBox(height: 12),

                  // --- JUNCTION GRID ---
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                    ),
                    child: GridView.builder(
                      itemCount: junctions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        return _buildJunctionCard(junctions[index]);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

}
