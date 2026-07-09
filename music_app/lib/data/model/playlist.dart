class Playlist {
  final int? id;
  final int userId;
  final String name;

  Playlist({
    this.id,
    required this.userId,
    required this.name,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
    };
  }
}
