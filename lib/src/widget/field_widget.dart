import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

abstract class FieldWidget<T extends Field> extends StatefulWidget {
  final T field;
  final IftFormState formState;

  FieldWidget(this.field, this.formState, {Key key}) : super(key: key);

  Widget createPrefixWidget(BuildContext context, [String defaultStringId]) {
    Widget result = _createStringWidgetInner(
        context, field.prefixId, field.prefixText, field.prefixTextStyle);
    if (result == null && defaultStringId != null) {
      result = formState.createStringWidget(context, defaultStringId);
    }
    return result;
  }

  Widget createSuffixWidget(BuildContext context, [String defaultStringId]) {
    Widget result = _createStringWidgetInner(
        context, field.suffixId, field.suffixText, field.suffixTextStyle);
    if (result == null && defaultStringId != null) {
      result = formState.createStringWidget(context, defaultStringId);
    }
    return result;
  }

  Widget createPicker(BuildContext context, FieldWidgetState fieldWidgetState) {
    return formState.createPicker(context, field.pickerId, fieldWidgetState);
  }

  Widget _createStringWidgetInner(BuildContext context, String strId,
      String text, AppendedTextStyle style) {
    if (strId != null && strId.isNotEmpty && formState != null) {
      return formState.createStringWidget(context, strId);
    }
    if (text != null && text.isNotEmpty) {
      TextStyle textStyle;
      if (style != null) {
        textStyle =
            TextStyle(fontSize: style.fontSize, color: Color(style.color));
      }
      return Text(
        text,
        style: textStyle,
      );
    }
    return null;
  }
}

abstract class FieldWidgetState<T extends FieldWidget> extends State<T> {
  String _errorMsg;
  Object initValue;

  @override
  void initState() {
    initValue = widget.formState.getInitValue(widget.field);
    super.initState();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    var newInitValue = widget.formState.getInitValue(widget.field);
    if (newInitValue != initValue) {
      initValue = newInitValue;
      setValue(initValue);
      //print("on find new init value:$initValue");
    }
    super.didUpdateWidget(oldWidget);
  }

  void setErrorMsg(String msg, {bool isInUIBuildLife = false}) {
    if (isInUIBuildLife) {
      _errorMsg = msg;
    } else {
      setState(() {
        _errorMsg = msg;
      });
    }
  }

  String getErrorMsg() {
    return _errorMsg;
  }

  dynamic getValue();

  void setValue(Object value) {}

  void setValueAndRefresh(Object value) {
    setState(() {
      setValue(value);
    });
  }

  bool validate({bool isInUIBuildLife = false}) {
    var validators = widget.field.validators;
    if (validators == null || validators.isEmpty) {
      return true;
    }
    if (widget.formState.isReadOnlyField(widget.field)) {
      return true;
    }
    var value = getValue();
    if (widget.field.isRequired == null || !widget.field.isRequired) {
      if (value == null) {
        return true;
      }
      if (value is String && value.isEmpty) {
        return true;
      }
    }
    for (var v in validators) {
      String error = v.validate(widget.formState, widget.field, value);
      if (error != null) {
        setErrorMsg(error, isInUIBuildLife: isInUIBuildLife);
        return false;
      }
    }
    var fTypeValidator =
        widget.formState.getValidatorById('#${widget.field.rawTypeName}');
    String error = VCmd.checkValidator(
        widget.formState, fTypeValidator, value, widget.field);
    if (error != null) {
      setErrorMsg(error, isInUIBuildLife: isInUIBuildLife);
      return false;
    }
    //
    setErrorMsg(null, isInUIBuildLife: isInUIBuildLife);
    return true;
  }

  String valueOrHint(Object value) {
    String result;
    if (value == null) {
      result = widget.formState.obtainHint(widget.field);
    } else {
      if (value is String) {
        result = value;
      } else {
        result = value.toString();
      }
    }
    return result ?? "";
  }

  void notifyValueChanged() {
    setErrorMsg(null); //clear error tips
    widget.formState.notifyValueChanged(widget.field, getValue());
   }
}

typedef StringWidgetBuilder = Widget Function(
    BuildContext context, String textId);
