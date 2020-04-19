import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/title/widgets/title_widget.dart';

class TitleField extends Field {
  TitleField({String label}) : super(label: label);

  @override
  getValue() {
    return null;
  }

  GlobalKey<FieldWidgetState> _key;

  @override
  FieldWidget build(FormBuilderState formState, BuildContext context) {
    if (_key == null) {
      _key = GlobalKey<FieldWidgetState>();
    }
    return TitleWidget(this, formState, key: _key,);
  }
}
