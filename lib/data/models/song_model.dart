class Song {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String streamUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.streamUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
    );
  }
}
