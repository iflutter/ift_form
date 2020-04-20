import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/divider/widgets/divider_widget.dart';

class DividerField extends Field {
  DividerField() : super();

  @override
  getValue() {
    return null;
  }

  @override
  FieldWidget build(IftFormState formState, BuildContext context) {
    return DividerWidget(this, formState);
  }
}
