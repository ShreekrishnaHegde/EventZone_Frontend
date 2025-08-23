class HostProfile{
  final String email;
  final String name;
  final String description;
  final String logoUrl;
  final String phoneNumber;
  final String website;
  final String instagram;
  final String linkedin;
  final String twitter;
  HostProfile({
    required this.email,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.phoneNumber,
    required this.website,
    required this.instagram,
    required this.linkedin,
    required this.twitter,
  });

  factory HostProfile.fromJson(Map<String,dynamic> json){
    return HostProfile(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      phoneNumber: json['contactNumber'] ?? '',
      website: json['website'] ?? '',
      instagram: json['instagramUsername'] ?? '',
      linkedin: json['linkedinUsername'] ?? '',
      twitter: json['twitter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clubName': name,
      'clubDescription': description,
      'phoneNumber': phoneNumber,
      'website': website,
      'instagramUsername': instagram,
      'linkedinUsername': linkedin,
      'twitter':twitter
    };
  }
}