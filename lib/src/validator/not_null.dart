import 'package:ift_form/ift_form.dart';

class VNotNull extends Validator {
  @override
  validate(FormBuilderState formState, Field field, value) {
    String valueStr = value == null ? null : (value.toString()??"").trim();
    if (valueStr == null || valueStr.isEmpty) {
      return field.label + "必填";
    }
    return null;
  }
}
