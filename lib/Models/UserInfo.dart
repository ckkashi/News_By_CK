class UserInfo {
  String? sId;
  String? userId;
  String? username;
  String? userContact;
  String? userAddress;
  String? userProfileUrl;
  String? userPaymentDetail;
  int? iV;

  UserInfo(
      {this.sId,
      this.userId,
      this.username,
      this.userContact,
      this.userAddress,
      this.userProfileUrl,
      this.userPaymentDetail,
      this.iV});

  UserInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    username = json['username'];
    userContact = json['userContact'];
    userAddress = json['userAddress'];
    userProfileUrl = json['userProfileUrl'];
    userPaymentDetail = json['userPaymentDetail'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['userContact'] = this.userContact;
    data['userAddress'] = this.userAddress;
    data['userProfileUrl'] = this.userProfileUrl;
    data['userPaymentDetail'] = this.userPaymentDetail;
    data['__v'] = this.iV;
    return data;
  }
}
