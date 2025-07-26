import 'package:spotify_b/data/models/user_register_model.dart';

abstract class RegisterEvent {
  
}

class SubmitRegisterEvent extends RegisterEvent {
  final UserRegisterModel user;

  SubmitRegisterEvent(this.user);
}