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
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString() ?? '',
      faceData: json['faceData']?.toString(),
      jobRole: json['jobRole']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      dailyWage: double.tryParse(json['dailyWage']?.toString() ?? '0') ?? 0.0,
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
