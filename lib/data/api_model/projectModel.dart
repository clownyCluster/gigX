class ProjectModels {
  String? status;
  List<Data>? data;

  ProjectModels({this.status, this.data});

  ProjectModels.fromJson(Map<String, dynamic> json) {
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
  int? fleetId;
  int? parentId;
  String? title;
  String? startDate;
  String? endDate;
  String? image;
  String? logo;
  String? colorCode;
  String? description;
  int? status;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? logoUrl;

  Data(
      {this.id,
      this.fleetId,
      this.parentId,
      this.title,
      this.startDate,
      this.endDate,
      this.image,
      this.logo,
      this.colorCode,
      this.description,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.logoUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fleetId = json['fleet_id'];
    parentId = json['parent_id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    logo = json['logo'];
    colorCode = json['color_code'];
    description = json['description'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    logoUrl = json['logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fleet_id'] = this.fleetId;
    data['parent_id'] = this.parentId;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['logo'] = this.logo;
    data['color_code'] = this.colorCode;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['logo_url'] = this.logoUrl;
    return data;
  }
}