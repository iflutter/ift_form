import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/hint/hint.dart';

class HintWidget extends FieldWidget<HintField> {
  HintWidget(HintField field, FormBuilderState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return InfoFieldState();
  }
}

class InfoFieldState extends FieldWidgetState<HintWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Text(
        getErrorMsg() ?? widget.field.hint ?? '',
        style: TextStyle(
            color: getErrorMsg() == null ? Colors.grey[500] : Colors.orange),
      ),
    );
  }

  @override
  getValue() {
    return 'hint'; //如果不返回值的话，因为他is not required，不会被执行任何校验
  }
}
