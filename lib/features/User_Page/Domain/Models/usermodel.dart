class Usermodel {
  final String uid;
  final String username;
  final String profilePictureUrl;
  final bool isBlocked;

  Usermodel({
    required this.uid,

    required this.username,
    required this.profilePictureUrl,
    required this.isBlocked,
  });

  factory Usermodel.fromMap(Map<String, dynamic> data, String id) {
    return Usermodel(
      uid: id,
      username: data['username'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      isBlocked: data['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'isBlocked': isBlocked,
    };
  }
}
