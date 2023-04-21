class TimeBoxModel {
  String? status;
  Data? data;

  TimeBoxModel({this.status, this.data});

  TimeBoxModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? timeboxDate;
  String? topPriorities;
  String? brainDump;
  String? taskList;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? timeboxFulltime;
  List<Tasklist>? tasklist;

  Data(
      {this.id,
      this.userId,
      this.timeboxDate,
      this.topPriorities,
      this.brainDump,
      this.taskList,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.timeboxFulltime,
      this.tasklist});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    timeboxDate = json['timebox_date'];
    topPriorities = json['top_priorities'];
    brainDump = json['brain_dump'];
    taskList = json['task_list'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    timeboxFulltime = json['timebox_fulltime'];
    if (json['tasklist'] != null) {
      tasklist = <Tasklist>[];
      json['tasklist'].forEach((v) {
        tasklist!.add(new Tasklist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['timebox_date'] = this.timeboxDate;
    data['top_priorities'] = this.topPriorities;
    data['brain_dump'] = this.brainDump;
    data['task_list'] = this.taskList;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['timebox_fulltime'] = this.timeboxFulltime;
    if (this.tasklist != null) {
      data['tasklist'] = this.tasklist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasklist {
  String? time;
  String? task;
  String? fulltime;

  Tasklist({this.time, this.task, this.fulltime});

  Tasklist.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    task = json['task'];
    fulltime = json['fulltime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['task'] = this.task;
    data['fulltime'] = this.fulltime;
    return data;
  }
}