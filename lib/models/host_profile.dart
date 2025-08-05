class HostProfile{
  final String email;
  final String role;
  final String clubName;
  final String clubDescription;
  final String clubLogo;
  final String phoneNumber;
  final String website;
  final String instagram;
  final String linkedin;
  HostProfile({
    required this.email,
    required this.role,
    required this.clubName,
    required this.clubDescription,
    required this.clubLogo,
    required this.phoneNumber,
    required this.website,
    required this.instagram,
    required this.linkedin,
  });

  factory HostProfile.fromJson(Map<String,dynamic> json){
    return HostProfile(
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      clubName: json['clubName'] ?? '',
      clubDescription: json['clubDescription'] ?? '',
      clubLogo: json['clubLogo'] ?? '',
      phoneNumber: json['contactNumber'] ?? '',
      website: json['website'] ?? '',
      instagram: json['instagramUsername'] ?? '',
      linkedin: json['linkedinUsername'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'clubName': clubName,
      'clubDescription': clubDescription,
      'clubLogo': clubLogo,
      'phoneNumber': phoneNumber,
      'website': website,
      'instagramUsername': instagram,
      'linkedinUsername': linkedin,
    };
  }
}