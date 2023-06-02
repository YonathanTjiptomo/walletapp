class TbFriend {
  final String userIdFriend;
  final String friendEmail;

  TbFriend({required this.userIdFriend, required this.friendEmail});

  factory TbFriend.fromJson(Map<String, dynamic> json) {
    return TbFriend(
      friendEmail: json['friendEmail'],
      userIdFriend: json['userIdFriend'],
    );
  }
}
