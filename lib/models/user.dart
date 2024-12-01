
class User {
  String? message;
  String? userId;
  String? userFullName;
  String? userBirthDate;
  String? userName;
  String? userPassword;
  String? userImage;

  User(
      {this.message,
      this.userId,
      this.userFullName,
      this.userBirthDate,
      this.userName,
      this.userPassword,
      this.userImage});

  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['userId'];
    userFullName = json['userFullName'];
    userBirthDate = json['userBirthDate'];
    userName = json['userName'];
    userPassword = json['userPassword'];
    userImage = json['userImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['userFullName'] = this.userFullName;
    data['userBirthDate'] = this.userBirthDate;
    data['userName'] = this.userName;
    data['userPassword'] = this.userPassword;
    data['userImage'] = this.userImage;
    return data;
  }
}