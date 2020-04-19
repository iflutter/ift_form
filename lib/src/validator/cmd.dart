import 'package:ift_form/ift_form.dart';

class VCmd extends Validator {
  final List<String> cmdIds;

  VCmd(this.cmdIds);

  @override
  validate(FormBuilderState formState, Field field, value) {
    String result;
    if (cmdIds != null && cmdIds.isNotEmpty) {
      for (var id in cmdIds) {
        var validator = formState.getValidatorById(id);
        result = checkValidator(formState, validator, value, field);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  static String checkValidator(
      FormBuilderState formState, Object validator, Object value, Field field) {
    String valueStr = value == null ? '' : value.toString();
    String result;
    if (validator is String) {
      result = _checkReg(field, validator, valueStr);
    } else if (validator is Validator) {
      result = validator.validate(formState, field, value);
    } else if (validator is ValidatorFunc) {
      result = validator(formState, field, value);
    }
    return result;
  }

  static _checkReg(Field field, String reg, String valueStr) {
    if (RegExp(reg).hasMatch(valueStr)) {
      return null;
    } else {
      return _onBadFormat(field);
    }
  }

  static String _onBadFormat(Field field) {
    return "${field.label}格式不正确";
  }
}
