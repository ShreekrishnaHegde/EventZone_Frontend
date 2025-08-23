class AttendeeProfile{
  final String email;
  final String fullName;
  final String branchName;
  final String usn;
  final String collegeName;
  final String imagePublicid;
  AttendeeProfile({
    required this.email,
    required this.fullName,
    required this.branchName,
    required this.collegeName,
    required this.usn,
    required this.imagePublicid
  });

  factory AttendeeProfile.fromJson(Map<String,dynamic> json){
    return AttendeeProfile(
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        branchName: json['branchName'] ?? '',
        collegeName: json['collegeName'] ?? '',
        usn: json['USN'] ?? '',
        imagePublicid: json['imagePublicId'] ?? ''
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'email':email,
      'fullName':fullName,
      'collegeName':collegeName,
      'branchName':branchName,
      'USN':usn
    };
  }
}