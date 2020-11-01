import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'dart:math';

class InputWidget extends FieldWidget<InputField> {
  InputWidget(InputField field, IftFormState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return InputFieldState();
  }
}

class InputFieldState extends FieldWidgetState<InputWidget> {
  bool isFocused = false;
  FocusNode _focusNode = FocusNode();
  String _initValue;
  final TextEditingController _controller = TextEditingController();
  int _maxLengthFromValidator;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
    var value = widget.formState.getInitValue(widget.field);
    if (value != null) {
      if (widget.field.textInputType == TextInputType.number) {
        if (value == 0 || value == '0') {
          value = null;
        }
      }
    }
    _initValue = value == null ? null : value.toString();
    if (widget.field.maxLength == null) {
      //maybe move this auto length to form parse is better?
      var vs = widget.field.validators;
      if (vs != null && vs.isNotEmpty) {
        for (var v in vs) {
          if (v is VLength) {
            _maxLengthFromValidator = v.max;
            break;
          } else if (v is VRange) {
            if (v.rangeStart == null && v.rangeEnd == null) {
              continue;
            } else {
              String s = v.rangeStart?.toString() ?? '';
              String e = v.rangeEnd?.toString() ?? '';
              _maxLengthFromValidator = max(s.length, e.length);
              break;
            }
          }
        }
      }
    }
    _controller.text = _initValue;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minLines = widget.field.minLines ?? 1;
    int maxLines = widget.field.maxLines ?? 1;
    if (maxLines < minLines) {
      maxLines = minLines;
    }
    final isReadOnly = widget.formState.isReadOnlyField(widget.field);
    return FieldRow(
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !(isReadOnly ?? false),
          autovalidate: getErrorMsg() != null,
          keyboardType: widget.field.textInputType,
          maxLength: isReadOnly
              ? null
              : (_maxLengthFromValidator ?? widget.field.maxLength),
          minLines: widget.field.minLines ?? widget.field.maxLines ?? 1,
          maxLines: isReadOnly?null:(widget.field.maxLines ?? 1),
          validator: (String value) {
            this.validate(isInUIBuildLife: true);
            //print("do valid $value");
            return null;
          },
          style: TextStyle(color: isReadOnly ? Colors.grey : Colors.black),
          textAlign: TextAlign.right,
          obscureText: widget.field.obscureText ?? false,
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: widget.formState.obtainHint(widget.field),
          ),
        ),
      ),
      fieldWidget: widget,
      isReadOnly: isReadOnly,
      fieldWidgetState: this,
      isFocused: isFocused,
      errorText: getErrorMsg(),
    );
  }

  @override
  getValue() {
    return _controller.text;
  }

  @override
  void setValue(Object value) {
    _initValue = value?.toString();
    _controller.text = _initValue;
  }
}
