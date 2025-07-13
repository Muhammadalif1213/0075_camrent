part of 'profile_bloc_bloc.dart';

@immutable
sealed class ProfileBlocState {}

class ProfileSuccess extends ProfileBlocState {
  final AuthResponseModel profile;

  ProfileSuccess(this.profile);
}

class ProfileFailure extends ProfileBlocState {
  final String error;

  ProfileFailure(this.error);
}

class ProfileLoading extends ProfileBlocState {}

class ProfileBlocInitial extends ProfileBlocState {}