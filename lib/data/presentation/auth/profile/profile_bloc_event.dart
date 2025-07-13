part of 'profile_bloc_bloc.dart';

@immutable
sealed class ProfileBlocEvent {}

class FetchProfile extends ProfileBlocEvent {}