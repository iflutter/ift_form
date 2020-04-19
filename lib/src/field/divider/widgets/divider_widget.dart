import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

class DividerWidget extends FieldWidget<DividerField> {
  DividerWidget(DividerField field, FormBuilderState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return DividerFieldState();
  }
}

class DividerFieldState extends FieldWidgetState<DividerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  @override
  getValue() {
    return null;
  }
}
