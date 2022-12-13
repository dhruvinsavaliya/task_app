class TaskappResModel {
  TaskappResModel({
    this.id,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  TaskappResModel.fromJson(dynamic json) {
    id = json['id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? description;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['description'] = description;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
