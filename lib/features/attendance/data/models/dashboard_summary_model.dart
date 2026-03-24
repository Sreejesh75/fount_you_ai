class DashboardSummaryModel {
  final TodayStats today;
  final List<TrendData> trends;
  final List<RecentActivity> recentActivity;

  DashboardSummaryModel({
    required this.today,
    required this.trends,
    required this.recentActivity,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      today: TodayStats.fromJson(json['today']),
      trends: (json['trends'] as List).map((i) => TrendData.fromJson(i)).toList(),
      recentActivity: (json['recentActivity'] as List).map((i) => RecentActivity.fromJson(i)).toList(),
    );
  }
}

class TodayStats {
  final int totalWorkers;
  final int presentCount;
  final double totalEstimatedWage;

  TodayStats({
    required this.totalWorkers,
    required this.presentCount,
    required this.totalEstimatedWage,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) {
    return TodayStats(
      totalWorkers: json['totalWorkers'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      totalEstimatedWage: (json['totalEstimatedWage'] ?? 0).toDouble(),
    );
  }
}

class TrendData {
  final String date;
  final String day;
  final int count;

  TrendData({
    required this.date,
    required this.day,
    required this.count,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      date: json['date'],
      day: json['day'],
      count: json['count'],
    );
  }
}

class RecentActivity {
  final String id;
  final String workerName;
  final String? photoUrl;
  final String jobRole;
  final String time;
  final String date;

  RecentActivity({
    required this.id,
    required this.workerName,
    this.photoUrl,
    required this.jobRole,
    required this.time,
    required this.date,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'],
      workerName: json['workerName'],
      photoUrl: json['photoUrl'],
      jobRole: json['jobRole'],
      time: json['time'],
      date: json['date'],
    );
  }
}
