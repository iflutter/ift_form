import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/input/widgets/input_widget.dart';

class InputField extends Field {
  int minLines;
  int maxLines;
  int maxLength;
  TextInputType textInputType;
  final bool obscureText;

  InputField({
    String key,
    String label,
    String hint,
    String prefixId,
    String suffixId,
    String prefixText,
    AppendedTextStyle prefixTextStyle,
    String suffixText,
    AppendedTextStyle suffixTextStyle,
    List<Validator> validators,
    String validatorsExp,
    this.obscureText = false,
  }) : super(
          key: key,
          label: label,
          hint: hint,
          suffixId: suffixId,
          suffixText: suffixText,
          suffixTextStyle: suffixTextStyle,
          validators: validators,
        );

  @override
  getValue() {
    return _key?.currentState?.getValue();
  }

  InputWidget _widget;
  GlobalKey<InputFieldState> _key;

  void setValue(String value) {
    if (_key != null) {
      _key.currentState.setValue(value);
    }
  }

  @override
  FieldWidget build(IftFormState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<InputFieldState>();
    }
    _widget = InputWidget(this, formState, key: _key);
    return _widget;
  }
}
