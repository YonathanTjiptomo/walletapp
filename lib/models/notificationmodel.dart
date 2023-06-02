class TbNotification {
  final String pesanNotif;

  TbNotification({required this.pesanNotif});

  factory TbNotification.fromJson(Map<String, dynamic> json) {
    return TbNotification(
      pesanNotif: json['pesanNotif'],
    );
  }
}
