import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paml_camrent/data/models/response/auth_response_model.dart';
import 'package:paml_camrent/repository/auth_repository.dart';

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final AuthRepository authRepository;

  ProfileBloc({required this.authRepository}) : super(ProfileBlocInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      final result = await authRepository.getProfile();
      result.fold(
        (error) => emit(ProfileFailure(error)),

        (profileData) => emit(ProfileSuccess(profileData)),
      );
    });
  }
}
