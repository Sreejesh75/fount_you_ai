class WorkerModel {
  final String id;
  final String name;
  final String photoUrl;
  final String? faceData;
  final String jobRole;
  final String place;
  final String contactNumber;
  final double dailyWage;

  WorkerModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.faceData,
    required this.jobRole,
    required this.place,
    required this.contactNumber,
    required this.dailyWage,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      faceData: json['faceData'],
      jobRole: json['jobRole'] ?? '',
      place: json['place'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      dailyWage: (json['dailyWage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'jobRole': jobRole,
      'place': place,
      'contactNumber': contactNumber,
      'dailyWage': dailyWage,
      'faceData': faceData,
    };
  }
}
