import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/date/widgets/date_widget.dart';

class DateField extends Field {
  String dateFormat;
  String lastDate;

  DateField({String key,
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
    this.dateFormat,
    this.lastDate,
  })
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
    return _key?.currentState?.getValue();
  }

  DateWidget _widget;
  GlobalKey<DateFieldState> _key;

  @override
  FieldWidget build(FormBuilderState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<DateFieldState>();
    }
    _widget = DateWidget(this, formState, key: _key);
    return _widget;
  }
}
