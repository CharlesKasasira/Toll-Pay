class UserData {
  String username;
  String email;
  String? avatarUrl;
  UserData(
      {this.username = "",
      this.email = "",
      this.avatarUrl,});
  factory UserData.fromJson(var json) {
    return UserData(
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }
}