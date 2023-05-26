class TbFriend {
  final String userIdFriend;

  TbFriend({required this.userIdFriend});

  factory TbFriend.fromJson(Map<String, dynamic> json) {
    return TbFriend(
      userIdFriend: json['userIdFriend'],
    );
  }
}
