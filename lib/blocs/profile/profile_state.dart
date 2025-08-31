// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final int avatarVersion;
  ProfileLoaded({required this.profile, this.avatarVersion = 0});
  ProfileLoaded copyWith({Profile? profile, int? avatarVersion}) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      avatarVersion: avatarVersion ?? this.avatarVersion,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileUnauthorized extends ProfileState {
  final String message;
  ProfileUnauthorized(this.message);
}
