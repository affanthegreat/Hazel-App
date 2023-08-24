class UserDetails {
  String? userId;
  String? userFullName;
  String? userPhoneNumber;
  String? userAddress;
  String? userPhoneId;
  String? userCity;
  String? userState;
  String? userCountry;
  String? userRegion;
  String? userGender;
  String? userBio;
  int? userAge;

  UserDetails(
      {this.userId,
        this.userFullName,
        this.userPhoneNumber,
        this.userAddress,
        this.userPhoneId,
        this.userCity,
        this.userState,
        this.userCountry,
        this.userRegion,
        this.userGender,
        this.userAge,
        this.userBio
      });

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userFullName = json['user_full_name'];
    userPhoneNumber = json['user_phone_number'];
    userAddress = json['user_address'];
    userPhoneId = json['user_phone_id'];
    userCity = json['user_city'];
    userState = json['user_state'];
    userCountry = json['user_country'];
    userRegion = json['user_region'];
    userGender = json['user_gender'];
    userAge = json['user_age'];
    userBio = json['user_bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_full_name'] = this.userFullName;
    data['user_phone_number'] = this.userPhoneNumber;
    data['user_address'] = this.userAddress;
    data['user_phone_id'] = this.userPhoneId;
    data['user_city'] = this.userCity;
    data['user_state'] = this.userState;
    data['user_country'] = this.userCountry;
    data['user_region'] = this.userRegion;
    data['user_gender'] = this.userGender;
    data['user_age'] = this.userAge;
    data['user_bio'] = this.userBio;
    return data;
  }
}