import 'package:ift_form/ift_form.dart';

class VRange extends Validator {
  final double rangeStart;
  final double rangeEnd;

  VRange({this.rangeStart, this.rangeEnd});

  @override
  validate(FormBuilderState formState, Field field, value) {
    if (rangeEnd == null && rangeEnd == null) {
      return null;
    }
    if (value == null) {
      return onBadFormat(field);
    }
    double numValue;
    if (value is int) {
      numValue = value.toDouble();
    } else if (value is double) {
      numValue = value;
    } else {
      try {
        numValue = double.parse(value.toString());
      } catch (error) {
        print(error);
        return onBadFormat(field);
      }
    }
    if (rangeStart == rangeEnd && rangeStart != numValue) {
      return '${field.label}期望的内容是"$rangeEnd"';
    } else if (rangeStart == null) {
      if (numValue > rangeEnd) {
        return '${field.label}不能超过最大范围$rangeEnd';
      } else {
        return null;
      }
    } else if (rangeEnd == null) {
      if (numValue < rangeStart) {
        return '${field.label}不能超过最小范围$rangeStart';
      } else {
        return null;
      }
    } else {
      if (numValue < rangeStart || numValue > rangeEnd) {
        return '${field.label}不能超过($rangeStart~$rangeEnd)';
      }
    }
    return null;
  }
}
