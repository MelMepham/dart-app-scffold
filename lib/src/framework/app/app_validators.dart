
import 'package:angular_forms/angular_forms.dart';
import 'package:validate/validate.dart';

class AppValidators {

  static Map<String, dynamic> validateEmail(AbstractControl c) {
    Map<String, dynamic>  r;

    try {
      Validate.isEmail(c.value);
    } catch (e) {
      r = {'validateEmail': false};
    }

    return r;
  }

}
