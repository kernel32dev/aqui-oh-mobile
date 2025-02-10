class Mensagem {
  final String id;
  final String text;
  final DateTime dth;
  final String? image;
  final double? lat;
  final double? lng;
  final String userId;

  const Mensagem({
    required this.id,
    required this.text,
    required this.dth,
    required this.image,
    required this.lat,
    required this.lng,
    required this.userId,
  });

  static Mensagem cast(dynamic dyn) {
    final map = dyn as Map<String, dynamic>;
    return Mensagem(
      id: map['id'],
      text: map['text'],
      dth: DateTime.parse(map['dth']),
      image: map['image'],
      lat: map['lat'],
      lng: map['lng'],
      userId: map['userId'],      
    );
  }
}