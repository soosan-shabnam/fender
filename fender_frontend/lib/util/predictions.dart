class Predictions {
  final List<dynamic> scores;
  final List<dynamic> pred_classes;
  final List<dynamic> pred_boxes;
  final List<dynamic> classes;

  const Predictions({
    required this.scores,
    required this.pred_classes,
    required this.pred_boxes,
    required this.classes
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
        scores: json['scores'],
        pred_classes: json['pred_classes'],
        pred_boxes: json['pred_boxes'],
        classes: json['classes']
    );
  }
}