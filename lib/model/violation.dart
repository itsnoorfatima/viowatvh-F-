const Map<String, int> fineRates = {
  'without helmet': 1000,
  'triple riding': 1200,
  'Signal Jump': 1500,
  'Overspeed': 1200,
};

class Violation {
  final String imageBase64;
  final String type;
  final String date;
  final String time;
  final List<String> violationTypes;
  final int totalFine;
  final String numberPlate; 

  Violation({
    required this.imageBase64,
    required this.type,
    required this.date,
    required this.time,
    required this.violationTypes,
    required this.totalFine,
    required this.numberPlate,
  });

  factory Violation.fromJson(Map<String, dynamic> json) {
    final List<String> types =
        List<String>.from(json['violation_type'] as List<dynamic>);

    int totalFine = 0;
    for (var t in types) {
      totalFine += fineRates[t] ?? 0;
    }

    return Violation(
      imageBase64: json['image_base64'],
      type: types.join(', '),
      violationTypes: types,
      date: json['date'],
      time: json['time'],
      totalFine: totalFine,
      numberPlate: json['number_plate'] ?? 'Unknown', 
    );
  }
}
