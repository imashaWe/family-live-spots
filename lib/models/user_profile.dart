class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String? photoURL;
  final List<Member> members;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.members,
    this.photoURL,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      photoURL: json['photoURL'],
      members: List<Member>.from(
          json['members'].map((e) => Member.fromJson(e)).toList()),
    );
  }

  // String get title => this
  //     .name
  //     .split(" ")
  //     .map((e) => '${e[0].toUpperCase()}${e.substring(1)}')
  //     .join(" ");
}

class Member {
  final String uid;
  final bool isParent;

  Member({
    required this.uid,
    required this.isParent,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      uid: json['uid'],
      isParent: json['isParent'],
    );
  }
}
