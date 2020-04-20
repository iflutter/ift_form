import 'package:ift_form/ift_form.dart';

class VReg extends Validator {
  final String reg;

  VReg({this.reg});

  @override
  validate(IftFormState formState, Field field, value) {
    String valueStr = value == null ? '' : value.toString();
    if (RegExp(reg).hasMatch(valueStr)) {
      return null;
    } else {
      return onBadFormat(field);
    }
  }
}
