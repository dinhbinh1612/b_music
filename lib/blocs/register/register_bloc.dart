import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/data/providers/auth_provider.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthProvider authProvider;

  RegisterBloc(this.authProvider) : super(RegisterInitial()) {
    on<SubmitRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authProvider.registerUser(event.user);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure( e is String ? e : "Lỗi không xác định"));
      }
    });
  }
}
