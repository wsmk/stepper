class StepperModel {
  final String title;
  final String content;

  StepperModel({required this.title, required this.content});

  factory StepperModel.fromJson(Map<String, dynamic> json) {
    return StepperModel(title: json['title'], content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
