import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/radio/radios.dart';

class RadiosWidget extends FieldWidget<RadiosField> {
  RadiosWidget(RadiosField field, IftFormState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return RadiosFieldState();
  }
}

class RadiosFieldState extends FieldWidgetState<RadiosWidget> {
  Object curValue;

  @override
  void initState() {
    var v = widget.formState.getInitValue(widget.field);
    if (v != null && v is String) {
      v = (v.toString() ?? "").trim(); //FIXME 不应该在这个地方容错
    }
    curValue = _getOptionItemDataByValue(v);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.formState.isReadOnlyField(widget.field);
    var root = Container(
      alignment: Alignment.centerRight,
      child: Wrap(
        children: _buildRadios(),
        spacing: 5,
      ),
    );
    return FieldRow(
      child: root,
      onTap: isReadOnly ? null : () {},
      fieldWidget: widget,
      isReadOnly: isReadOnly,
      fieldWidgetState: this,
      isFocused: false,
      errorText: getErrorMsg(),
    );
  }

  List<Widget> _buildRadios() {
    var menus = List<Widget>();
    List<Object> dataSource = _getDataSource();
    if (dataSource != null) {
      for (var item in dataSource) {
        menus.add(buildItem(item));
      }
    }
    return menus;
  }

  Widget buildItem(value) {
    final root = Radio(
      groupValue: curValue,
      toggleable: true,
      value: value,
      onChanged: (value) {
        setState(() {
          curValue = value;
          notifyValueChanged();
        });
      },
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [ root, Container(
        child: GestureDetector(
          child: Text(valueOrHint(value),),
          onTap: () {
            curValue = value;
            notifyValueChanged();
          },
        ),
      ),
      ],
    );
  }

  List<Object> _getDataSource() {
    if (widget.field.optionsDataSourceId != null) {
      return widget.formState
          .getDataSourceById(widget.field.optionsDataSourceId);
    } else {
      return widget.field.options;
    }
  }

  Object _getOptionItemDataByValue(Object optionValue) {
    if (optionValue is OptionItem) {
      return optionValue;
    }
    List<Object> dataSource = _getDataSource();
    if (dataSource == null || dataSource.isEmpty) {
      return null;
    }
    for (Object d in dataSource) {
      if (d is OptionItem) {
        if (d.value is String || optionValue is String) {
          if (d.value.toString() == optionValue.toString()) {
            return d;
          }
        } else {
          if (d.value == optionValue) {
            return d;
          }
        }
      } else {
        return optionValue;
      }
    }
  }

  @override
  getValue() {
    if (curValue == null) {
      return null;
    }
    if (curValue is OptionItem) {
      return (curValue as OptionItem).value;
    }
    return curValue;
  }
}
