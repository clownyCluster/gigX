class TaskModel {
  String? status;
  List<TaskData>? data;

  TaskModel({this.status, this.data});

  TaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskData>[];
      json['data'].forEach((v) {
        data!.add(new TaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskData {
  int? id;
  int? parentId;
  int? category;
  int? projectId;
  String? title;
  String? startDate;
  String? endDate;
  int? assignBy;
  String? description;
  int? userId;
  String? cssIconClass;
  String? percentDone;
  int? status;
  int? assignTo;
  int? priority;
  int? createdBy;
  int? updatedBy;
  String? fleets;
  String? attachment;
  String? icon;
  String? createdAt;
  String? updatedAt;

  TaskData(
      {this.id,
      this.parentId,
      this.category,
      this.projectId,
      this.title,
      this.startDate,
      this.endDate,
      this.assignBy,
      this.description,
      this.userId,
      this.cssIconClass,
      this.percentDone,
      this.status,
      this.assignTo,
      this.priority,
      this.createdBy,
      this.updatedBy,
      this.fleets,
      this.attachment,
      this.icon,
      this.createdAt,
      this.updatedAt});

  TaskData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    category = json['category'];
    projectId = json['project_id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    assignBy = json['assign_by'];
    description = json['description'];
    userId = json['user_id'];
    cssIconClass = json['css_icon_class'];
    percentDone = json['percent_done'];
    status = json['status'];
    assignTo = json['assign_to'];
    priority = json['priority'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    fleets = json['fleets'];
    attachment = json['attachment'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['category'] = this.category;
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['assign_by'] = this.assignBy;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['css_icon_class'] = this.cssIconClass;
    data['percent_done'] = this.percentDone;
    data['status'] = this.status;
    data['assign_to'] = this.assignTo;
    data['priority'] = this.priority;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['fleets'] = this.fleets;
    data['attachment'] = this.attachment;
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}