class AttendeeProfile{
  final String email;
  final String role;
  AttendeeProfile({
    required this.email,
    required this.role,
  });

  factory AttendeeProfile.fromJson(Map<String,dynamic> json){
    return AttendeeProfile(
        email: json['email'] ?? '',
        role: json['role'] ?? ''
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'email':email,
      'role':role,
    };
  }
}