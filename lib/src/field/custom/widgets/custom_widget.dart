import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/custom/custom.dart';

class CustomWidget extends FieldWidget<CustomField> {
  final String customTypeId;

  CustomWidget(CustomField field, IftFormState formState, this.customTypeId,
      {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomFieldState();
  }
}

class CustomFieldState extends FieldWidgetState<CustomWidget> {
  CustomFieldBuilder cfb;

  @override
  void initState() {
    cfb = widget.formState.createCustomFieldBuilder(widget.customTypeId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.formState.isReadOnlyField(widget.field);
    return FieldRow(
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: cfb.buildContent(widget.formState, this, context),
      ),
      fieldWidget: widget,
      isReadOnly: isReadOnly,
      fieldWidgetState: this,
      isFocused: cfb.isFocused(),
      errorText: getErrorMsg(),
    );
  }

  @override
  getValue() {
    return cfb?.getValue();
  }

  @override
  void setValue(Object value) {
    cfb?.setValue(value);
  }
}
