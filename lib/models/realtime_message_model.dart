class RealtimeMessageModel {
  String? id;
  String? text;

  RealtimeMessageModel({
    required this.id,
    required this.text,
  });
  RealtimeMessageModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'text': text,
      };
}
