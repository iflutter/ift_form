import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

class SelectorWidget extends FieldWidget<SelectorField> {
  SelectorWidget(SelectorField field, IftFormState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectorFieldState();
  }
}

class SelectorFieldState extends FieldWidgetState<SelectorWidget> {
  Object curValue;

  @override
  void initState() {
    curValue = widget.formState.getInitValue(widget.field);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.formState.isReadOnlyField(widget.field);
    var root = Container(
      alignment: Alignment.centerRight,
      child: Text(
        valueOrHint(curValue),
        style: TextStyle(color: isReadOnly ? Colors.grey : Colors.black),
      ),
    );
    return FieldRow(
      child: root,
      onTap: _onTap,
      fieldWidget: widget,
      isReadOnly: isReadOnly,
      fieldWidgetState: this,
      isFocused: false,
      errorText: getErrorMsg(),
    );
  }

  @override
  getValue() {
    return curValue;
  }

  @override
  void setValue(Object value) {
    setState(() {
      curValue = value;
      //print("ttt set value $value");
    });
  }

  void _onTap() async {
    SelectorField selectorField = widget.field;
    SelectorHandler handler;
    if (selectorField.selectorHandlerId != null) {
      handler = widget.formState
          .getSelectorHandlerById(selectorField.selectorHandlerId);
    }
    if (handler == null) {
      handler = selectorField.handler;
    }
    if (handler != null) {
      var result = await handler(widget.formState, selectorField);
      if (result != null && result != curValue) {
        setState(() {
          curValue = result;
          notifyValueChanged();
        });
      }
    }
  }
}
