import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/custom/widgets/custom_widget.dart';

class CustomField extends Field {
  final customTypeId;

  CustomField(
    this.customTypeId, {
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

  CustomWidget _widget;
  GlobalKey<CustomFieldState> _key;

  void setValue(String value) {
    if (_key != null) {
      _key.currentState.setValue(value);
    }
  }

  @override
  FieldWidget build(FormBuilderState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<CustomFieldState>();
    }
    _widget = CustomWidget(this, formState, this.customTypeId, key: _key);
    return _widget;
  }
}

abstract class CustomFieldBuilder {
  void setValue(Object value);

  Object getValue();

  bool isFocused() {
    //如果不是输入框，永远返回false
    return false;
  }

  Widget buildContent(FormBuilderState form, CustomFieldState customField,
      BuildContext context);
}
