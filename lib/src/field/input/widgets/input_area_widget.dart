import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

class InputAreaWidget extends FieldWidget<InputArea> {
  InputAreaWidget(InputArea field, IftFormState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return InputAreaState();
  }
}

class InputAreaState extends FieldWidgetState<InputAreaWidget> {
  String _errorText;
  bool isFocused = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.formState.isReadOnlyField(widget.field);
    return FieldRow(
      child: TextFormField(
        //focusNode: _focusNode,
        maxLines: widget.field.maxLines,
        autovalidate: false,
        validator: (String value) {
          setState(() {
            _errorText = widget.field.label;
          });
          return null;
        },
        textAlign: TextAlign.right,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: widget.formState.obtainHint(widget.field)),
      ),
      fieldWidget: widget,
      isReadOnly: isReadOnly,
      fieldWidgetState: this,
      isFocused: isFocused,
      errorText: _errorText,
    );
  }

  @override
  getValue() {
    // TODO: implement getValue
    return null;
  }
}
