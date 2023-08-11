class CommentModels {
  String? status;
  List<Data>? data;

  CommentModels({this.status, this.data});

  CommentModels.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? todoId;
  int? parentId;
  String? comment;
  String? percentDone;
  int? assignBy;
  int? assignTo;
  int? createdBy;
  int? updatedBy;
  int? status;
  String? attachment;
  String? createdAt;
  String? updatedAt;
  String? attachmentUrl;
  List<Null>? childcomments;

  Data(
      {this.id,
      this.todoId,
      this.parentId,
      this.comment,
      this.percentDone,
      this.assignBy,
      this.assignTo,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.attachment,
      this.createdAt,
      this.updatedAt,
      this.attachmentUrl,
      this.childcomments});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todoId = json['todo_id'];
    parentId = json['parent_id'];
    comment = json['comment'];
    percentDone = json['percent_done'];
    assignBy = json['assign_by'];
    assignTo = json['assign_to'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    status = json['status'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attachmentUrl = json['attachment_url'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo_id'] = this.todoId;
    data['parent_id'] = this.parentId;
    data['comment'] = this.comment;
    data['percent_done'] = this.percentDone;
    data['assign_by'] = this.assignBy;
    data['assign_to'] = this.assignTo;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attachment_url'] = this.attachmentUrl;
    
    return data;
  }
}