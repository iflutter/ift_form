import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/selector/widgets/selector_widget.dart';

typedef SelectorHandler = Future<Object> Function(FormBuilderState form,SelectorField selectorField);

class SelectorField extends Field {
  SelectorHandler handler;
  String selectorHandlerId;

  SelectorField(
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
      SelectorHandler handler,
      this.selectorHandlerId})
      : super(
            key: key,
            label: label,
            hint: hint,
            suffixId: suffixId,
            suffixText: suffixText,
            suffixTextStyle: suffixTextStyle,
            validators: validators) {
    this.handler = handler;
  }

  @override
  dynamic getValue() {
    return _key?.currentState?.getValue();
  }

  SelectorWidget _widget;
  GlobalKey<SelectorFieldState> _key;

  @override
  FieldWidget build(FormBuilderState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<SelectorFieldState>();
    }
    _widget = SelectorWidget(this, formState, key: _key);
    return _widget;
  }
}
