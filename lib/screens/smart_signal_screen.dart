import 'package:flutter/material.dart';

class SmartSignalScreen extends StatelessWidget {
  const SmartSignalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Smart Signal'),
        backgroundColor: Color.fromARGB(255, 17, 55, 101),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Center(child: _SignalCrossWidget()),
            const SizedBox(height: 30),
            Row(
              children: const [
                Icon(Icons.directions_car, color: Colors.grey),
                SizedBox(width: 10),
                Text("No vehicle detected", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 30),
            _DirectionStatus(title: 'North', status: 'No vehicle detected'),
            const SizedBox(height: 20),
            _DirectionStatus(title: 'East', status: 'SC', time: '28 s'),
          ],
        ),
      ),
    );
  }
}

class _SignalCrossWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 40, height: 160, color: Colors.grey.shade300),
          Container(width: 160, height: 40, color: Colors.grey.shade300),
          Positioned(top: 0, child: _Light(color: Colors.red)),
          Positioned(bottom: 0, child: _Light(color: Colors.black)),
          Positioned(
            right: 0,
            child: Row(
              children: [
                _Light(color: Colors.green),
                const SizedBox(width: 6),
                _Light(color: Colors.green),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 70,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Light extends StatelessWidget {
  final Color color;
  const _Light({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DirectionStatus extends StatelessWidget {
  final String title;
  final String status;
  final String? time;

  const _DirectionStatus({
    required this.title,
    required this.status,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 14, color: Colors.black),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(status, style: const TextStyle(color: Colors.grey)),
        if (time != null) ...[
          const SizedBox(width: 10),
          Text(time!, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ],
    );
  }
}
