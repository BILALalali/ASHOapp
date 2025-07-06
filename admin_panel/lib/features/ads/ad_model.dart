// نموذج بيانات الإعلان
enum AdDuration { day, week, twoWeeks, month }

class AdModel {
  final String id;
  final String imageUrl;
  final String? link;
  final DateTime startDate;
  final AdDuration duration;

  AdModel({
    required this.id,
    required this.imageUrl,
    this.link,
    required this.startDate,
    required this.duration,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      link: json['link'],
      startDate:
          DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      duration: AdDuration.values.firstWhere(
        (e) => e.toString() == 'AdDuration.${json['duration']}',
        orElse: () => AdDuration.day,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'link': link,
      'startDate': startDate.toIso8601String(),
      'duration': duration.toString().split('.').last,
    };
  }

  AdModel copyWith({
    String? id,
    String? imageUrl,
    String? link,
    DateTime? startDate,
    AdDuration? duration,
  }) {
    return AdModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      link: link ?? this.link,
      startDate: startDate ?? this.startDate,
      duration: duration ?? this.duration,
    );
  }
}
