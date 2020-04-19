import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/options/widgets/options_widget.dart';

class OptionsField extends Field {
  List<dynamic> options;
  String optionsDataSourceId;

  OptionsField(
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
      this.options,
      this.optionsDataSourceId})
      : super(
            key: key,
            label: label,
            hint: hint,
            suffixId: suffixId,
            suffixText: suffixText,
            suffixTextStyle: suffixTextStyle,
            validators: validators);

  @override
  getValue() {
    if (key == null) {
      return null;
    } else {
      return _key.currentState.getValue();
    }
  }

  OptionsWidget _widget;
  GlobalKey<OptionsFieldState> _key;

  @override
  FieldWidget build(FormBuilderState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<OptionsFieldState>();
    }
    _widget = OptionsWidget(this, formState, key: _key);
    return _widget;
  }
}
