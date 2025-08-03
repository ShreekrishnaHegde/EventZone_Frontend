class AuthResponse{
  final String token;
  final String role;
  final String email;

  AuthResponse({
    required this.token,
    required this.role,
    required this.email,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      role: json['role'],
      email: json['email'],
    );
  }
}