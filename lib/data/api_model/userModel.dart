class UserModel {
  String? status;
  List<Data>? data;

  UserModel({this.status, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  String? username;
  String? email;
  String? userType;
  int? fleetID;
  String? token;
  String? profilePic;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.username,
      this.email,
      this.userType,
      this.fleetID,
      this.token,
      this.profilePic,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    userType = json['userType'];
    fleetID = json['fleetID'];
    token = json['token'];
    profilePic = json['ProfilePic'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['userType'] = this.userType;
    data['fleetID'] = this.fleetID;
    data['token'] = this.token;
    data['ProfilePic'] = this.profilePic;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}