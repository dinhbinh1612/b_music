import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/playlist/playlist_state.dart';
import 'package:spotify_b/data/providers/playlist_service.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistState(playlists: [], loading: true));

  Future<void> loadPlaylists() async {
    emit(state.copyWith(loading: true));
    try {
      final playlists = await PlaylistService.getPlaylists();
      emit(PlaylistState(playlists: playlists, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<bool> removeSong(String playlistId, String songId) async {
    try {
      final success = await PlaylistService.removeSongFromPlaylist(
        playlistId,
        songId,
      );

      if (success) {
        final updatedPlaylists =
            state.playlists.map((playlist) {
              if (playlist['id'] == playlistId) {
                final updatedSongs = List.from(playlist['songs'] ?? [])
                  ..removeWhere((song) => song['id'] == songId);
                return {...playlist, 'songs': updatedSongs};
              }
              return playlist;
            }).toList();

        emit(state.copyWith(playlists: updatedPlaylists));
        return true;
      }
      return false;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  Future<bool> deletePlaylist(String playlistId) async {
    try {
      final success = await PlaylistService.deletePlaylist(playlistId);
      if (success) {
        final updatedPlaylists =
            state.playlists
                .where((playlist) => playlist['id'] != playlistId)
                .toList();
        emit(state.copyWith(playlists: updatedPlaylists));
        return true;
      }
      return false;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  Future<bool> updatePlaylistName(String playlistId, String newName) async {
    try {
      final success = await PlaylistService.updatePlaylistName(
        playlistId,
        newName,
      );
      if (success) {
        final updatedPlaylists =
            state.playlists.map((playlist) {
              if (playlist['id'] == playlistId) {
                return {...playlist, 'name': newName};
              }
              return playlist;
            }).toList();

        emit(state.copyWith(playlists: updatedPlaylists));
        return true;
      }
      return false;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }
}
