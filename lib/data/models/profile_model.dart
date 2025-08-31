class Profile {
  final String id;
  final String email;
  final String username;
  final String avatar;
  final String? gender;
  final String? birthdate;

  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    this.gender,
    this.birthdate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      avatar: json['avatar'],
      gender: json['gender'] ?? '',
      birthdate: json['birthdate'] ?? '',
    );
  }

  copyWith({required String avatar}) {}
}
