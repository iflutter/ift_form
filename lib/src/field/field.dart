import 'package:flutter/cupertino.dart';
import 'package:ift_form/ift_form.dart';

abstract class Field {
  List<Validator> validators;
  String key;
  String label;
  String hint;
  String prefixId;
  String suffixId;
  String prefixText;
  AppendedTextStyle prefixTextStyle;
  String suffixText;
  AppendedTextStyle suffixTextStyle;
  bool isRequired = false;
  bool isReadOnly = false;
  String rawTypeName;
  String pickerId;

  Field(
      {String key,
      String label,
      String hint,
      bool isRequired,
      String prefixId,
      String suffixId,
      String prefixText,
      AppendedTextStyle prefixTextStyle,
      String suffixText,
      AppendedTextStyle suffixTextStyle,
      List<Validator> validators}) {
    this.key = key;
    this.label = label;
    this.hint = hint;
    this.isRequired = isRequired;
    this.prefixId = prefixId;
    this.suffixId = suffixId;
    this.prefixText = prefixText;
    this.prefixTextStyle = this.prefixTextStyle;
    this.suffixText = suffixText;
    this.suffixTextStyle = suffixTextStyle;
    this.validators = validators;
  }

  dynamic getValue();

  FieldWidget build(IftFormState formState, BuildContext context);
}

class AppendedTextStyle {
  double fontSize = double.nan;
  int color = -1;
}
