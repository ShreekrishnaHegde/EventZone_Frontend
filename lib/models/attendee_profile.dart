class AttendeeProfile{
  final String email;
  final String role;
  final String fullname;
  final String branchName;
  final String USN;
  final String collegeName;
  AttendeeProfile({
    required this.email,
    required this.role,
    required this.fullname,
    required this.branchName,
    required this.collegeName,
    required this.USN
  });

  factory AttendeeProfile.fromJson(Map<String,dynamic> json){
    return AttendeeProfile(
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        fullname: json['fullname'] ?? '',
        branchName: json['branchName'] ?? '',
        collegeName: json['collegeName'] ?? '',
        USN: json['USN'] ?? ''
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'email':email,
      'role':role,
      'fullname':fullname,
      'collegeName':collegeName,
      'branchName':branchName,
      'USN':USN
    };
  }
}