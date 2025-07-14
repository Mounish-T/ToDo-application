class DataModel {
  final String? task_name;

  DataModel({this.task_name});

  Map<String, dynamic> toJson() {
    return {
      'task_name': task_name
      };
  }
}
