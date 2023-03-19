// Class to hold each user Data to access easily

class UserModel
{
  String? fname;
  String? lname;
  String? email;
  String? phone;
  String? id;
  bool? visibility;
  double? lat;
  double? lng;

  UserModel({
    required this.email,
    required this.fname,
    required this.lname,
    required this.phone,
    required this.id,
    required this.visibility,
    required this.lat,
    required this.lng,
  });

  UserModel.fromJson(Map<String,dynamic> json)
  {
    email = json['email'];
    fname = json['fname'];
    lname = json['lname'];
    phone = json['phone'];
    id = json['id'];
    visibility = json['visibility'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String,dynamic> toMap()
  {
    return{
      'fname' : fname,
      'lname' : lname,
      'email' : email,
      'phone' : phone,
      'id' : id,
      'visibility' : visibility,
      'lat' : lat,
      'lng' : lng,
    };
  }
}