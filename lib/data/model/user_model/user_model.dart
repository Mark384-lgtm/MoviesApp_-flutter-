class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime? createdAt;
  final int wishListCount;
  final int historyCount;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.createdAt,
    this.wishListCount = 0,
    this.historyCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'wishListCount': wishListCount,
      'historyCount': historyCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      wishListCount: map['wishListCount'] ?? 0,
      historyCount: map['historyCount'] ?? 0,
    );
  }

  UserModel copyWith({
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    int? wishListCount,
    int? historyCount,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      wishListCount: wishListCount ?? this.wishListCount,
      historyCount: historyCount ?? this.historyCount,
    );
  }
}
