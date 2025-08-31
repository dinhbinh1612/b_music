part of 'trending_cubit.dart';

abstract class TrendingState {}

class TrendingInitial extends TrendingState {}

class TrendingLoading extends TrendingState {}

class TrendingLoaded extends TrendingState {
  final List<Song> songs;
  TrendingLoaded(this.songs);
}

class TrendingError extends TrendingState {
  final String message;
  TrendingError(this.message);
}