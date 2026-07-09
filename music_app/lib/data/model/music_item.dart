class MusicItem {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final bool isLocal;
  final String? previewUrl;
  final int durationMillis;

  MusicItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    this.isLocal = false,
    this.previewUrl,
    this.durationMillis = 0,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['trackId'] ?? json['collectionId'] ?? DateTime.now().millisecondsSinceEpoch,
      title: json['trackName'] ?? json['collectionName'] ?? 'Unknown Title',
      subtitle: json['artistName'] ?? 'Unknown Artist',
      description: json['collectionName'] ?? 'No description available',
      imageUrl: json['artworkUrl100'] ?? '',
      isLocal: false,
      previewUrl: json['previewUrl'],
      durationMillis: json['trackTimeMillis'] ?? 0,
    );
  }

  factory MusicItem.fromMap(Map<String, dynamic> map) {
    return MusicItem(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isLocal: map['isLocal'] == 1,
      previewUrl: map['previewUrl'],
      durationMillis: map['durationMillis'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imageUrl': imageUrl,
      'isLocal': isLocal ? 1 : 0,
      'previewUrl': previewUrl,
      'durationMillis': durationMillis,
    };
  }
}
