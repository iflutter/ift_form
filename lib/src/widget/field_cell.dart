import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

class FieldRow extends StatelessWidget {
  final Widget child;
  final FieldWidget fieldWidget;
  final VoidCallback onTap;
  final bool isReadOnly;
  final FieldWidgetState fieldWidgetState;
  final bool enableStatusWrap;

  final String errorText;
  final bool isFocused;

  FieldRow(
      {this.child,
      this.fieldWidget,
      this.onTap,
      this.fieldWidgetState,
      this.isReadOnly,
      this.enableStatusWrap = true,
      this.errorText,
      this.isFocused});

  @override
  Widget build(BuildContext context) {
    Decorator decorator;
    if (fieldWidget.formState.widget.fieldDecorator != null) {
      decorator = fieldWidget.formState.widget.fieldDecorator
          .decorateField(context, fieldWidget.field, this);
    }
    //
    Widget prefix = fieldWidget.createPrefixWidget(context);
    Widget suffix = fieldWidget.createSuffixWidget(context);
    Widget picker = fieldWidget.createPicker(context, this.fieldWidgetState);
    var rowChildren = <Widget>[];
    if (decorator?.rootPrefix != null) {
      rowChildren.add(decorator.rootPrefix);
    }
    if (prefix != null) {
      rowChildren.add(prefix);
    }
    rowChildren.add(Text(fieldWidget.field.label));
    if (child is Flexible) {
      rowChildren.add(child);
    } else {
      rowChildren.add(Flexible(child: child));
    }
    if (suffix != null) {
      rowChildren.add(suffix);
    }
    if (picker != null) {
      rowChildren.add(picker);
    }
    if (decorator?.rootSuffix != null) {
      rowChildren.add(decorator.rootSuffix);
    }
    Widget root = ConstrainedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: rowChildren,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      constraints: BoxConstraints(minHeight: 52),
    );

    if (onTap != null && !isReadOnly) {
      root = InkWell(
        child: root,
        onTap: onTap,
      );
    }
    if (enableStatusWrap == true) {
      root = FieldWidgetBox(
        child: root,
        isFocused: isFocused,
        isReadOnly: isReadOnly,
      );
    }
    return root;
  }
}

class Decorator {
  Widget rootPrefix;
  Widget rootSuffix;

  Decorator({this.rootPrefix, this.rootSuffix});
}
