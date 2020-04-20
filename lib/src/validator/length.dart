import 'package:ift_form/ift_form.dart';

class VLength extends Validator {
  final int max;
  final int min;

  VLength({this.max, this.min});

  @override
  validate(IftFormState formState, Field field, value) {
    if (min == null && max == null) {
      return null;
    }
    String valueStr = value == null ? '' : value.toString();
    if (min == max && min != valueStr.length) {
      return '${field.label}期望的长度是"$max"位';
    } else if (min == null) {
      if (valueStr.length > max) {
        return '${field.label}最大长度为$max';
      } else {
        return null;
      }
    } else if (max == null) {
      if (valueStr.length < min) {
        return '${field.label}最小长度为$min';
      } else {
        return null;
      }
    } else {
      if (valueStr.length < min || valueStr.length > max) {
        return '${field.label}长度范围不正确($min~$max)';
      }
    }
    return null;
  }
}
