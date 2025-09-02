import 'package:spotify_b/core/constants/api_constants.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final String coverUrl;
  final String streamUrl;
  final int likeCount;
  final int duration;
  final bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.coverUrl,
    required this.streamUrl,
    required this.likeCount,
    required this.duration,
    this.isLiked = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      genre: json['genre'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      duration: json['duration'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genre': genre,
      'coverUrl': coverUrl,
      'streamUrl': streamUrl,
      'likeCount': likeCount,
      'duration': duration,
      'isLiked': isLiked,
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? genre,
    String? coverUrl,
    String? streamUrl,
    int? likeCount,
    int? duration,
    bool? isLiked,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      genre: genre ?? this.genre,
      coverUrl: coverUrl ?? this.coverUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      likeCount: likeCount ?? this.likeCount,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get fullCoverUrl => "${ApiConstants.baseUrl}/$coverUrl";
}
