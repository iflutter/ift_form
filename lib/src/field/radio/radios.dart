import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/options/widgets/options_widget.dart';
import 'package:ift_form/src/field/radio/widgets/radios_widget.dart';

class RadiosField extends Field {
  List<dynamic> options;
  String optionsDataSourceId;

  RadiosField(
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

  RadiosWidget _widget;
  GlobalKey<RadiosFieldState> _key;

  @override
  FieldWidget build(IftFormState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<RadiosFieldState>();
    }
    _widget = RadiosWidget(this, formState, key: _key);
    return _widget;
  }
}
