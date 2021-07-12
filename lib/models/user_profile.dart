class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String? photoURL;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.photoURL,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        photoURL: json['photoURL']);
  }

  // String get title => this
  //     .name
  //     .split(" ")
  //     .map((e) => '${e[0].toUpperCase()}${e.substring(1)}')
  //     .join(" ");
}
