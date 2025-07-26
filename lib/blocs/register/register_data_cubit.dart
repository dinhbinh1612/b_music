import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/data/models/register_data_temp.dart';

class RegisterDataCubit extends Cubit<RegisterDataTemp> {
  RegisterDataCubit() : super(RegisterDataTemp());

  void updateEmail(String email) => emit(state..email = email);
  void updatePassword(String password) => emit(state..password = password);
  void updateBirthdate(String birthdate) => emit(state..birthdate = birthdate);
  void updateGender(String gender) => emit(state..gender = gender);
  void updateUsername(String username) => emit(state..username = username);
}
