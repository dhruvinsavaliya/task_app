class TaskReqModel {
  String? description;
  String? status;

  TaskReqModel({this.description, this.status});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['status'] = status;
    return map;
  }
}
