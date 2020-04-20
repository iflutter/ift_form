import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/input/widgets/input_area_widget.dart';

class InputArea extends Field {
  int maxLines;

  InputArea(
      {String key,
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
      int maxLines = 3})
      : super(
            key: key,
            label: label,
            hint: hint,
            suffixId: suffixId,
            suffixText: suffixText,
            suffixTextStyle: suffixTextStyle,
            validators: validators) {
    this.maxLines = maxLines;
  }

  @override
  getValue() {
    return _key?.currentState?.getValue();
  }

  InputAreaWidget _widget;
  GlobalKey<InputAreaState> _key;

  @override
  FieldWidget build(IftFormState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<InputAreaState>();
    }
    _widget = InputAreaWidget(this, formState, key: _key);
    return _widget;
  }
}
