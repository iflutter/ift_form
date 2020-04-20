import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/hint/widgets/hint_widget.dart';

class HintField extends Field {
  HintField({String label, String hint}) : super(label: label, hint: hint);

  @override
  getValue() {
    return null;
  }

  GlobalKey<FieldWidgetState> _key;

  @override
  FieldWidget build(IftFormState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<FieldWidgetState>();
    }
    return HintWidget(this, formState, key: _key,);
  }
}
