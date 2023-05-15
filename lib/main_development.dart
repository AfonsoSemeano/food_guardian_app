import 'package:food_control_app/app/app.dart';
import 'package:food_control_app/bootstrap.dart';

void main() {
  bootstrap((authRepository) => App(authenticationRepository: authRepository));
}
