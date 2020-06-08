import 'package:ift_form/ift_form.dart';

class VFieldEqual extends Validator {
  final String fieldId;
  final String tips;

  VFieldEqual(this.fieldId, this.tips);

  @override
  validate(IftFormState formState, Field field, value) {
    final confirmField = formState.getFieldByKey(fieldId);
    var confirmValueHash = confirmField.getValue()?.hashCode;
    if (value?.hashCode != confirmValueHash) {
      if (this.tips != null) {
        return this.tips;
      }
      return '${field.label}和${confirmField.label}不一致';
    }
    return null;
  }
}
