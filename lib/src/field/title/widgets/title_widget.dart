import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/title/title.dart';

class TitleWidget extends FieldWidget<TitleField> {
  TitleWidget(TitleField field, FormBuilderState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return TitleFieldState();
  }
}

class TitleFieldState extends FieldWidgetState<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 12.5, right: 5, top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Text(
        widget.field.label,
        style: TextStyle(color: Colors.black,fontSize: 16),
      ),
    );
  }

  @override
  getValue() {
    return 'title'; //如果不返回值的话，因为他is not required，不会被执行任何校验
  }
}
