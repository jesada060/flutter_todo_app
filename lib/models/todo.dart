class ToDo {
  final String id;
  final String todoText;
  String todoDetail;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.todoDetail = '',
    this.isDone = false,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      todoDetail: json['todoDetail'],
      isDone: json['isDone'],
    );
  }
}
