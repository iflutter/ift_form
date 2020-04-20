import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

class OptionsWidget extends FieldWidget<OptionsField> {
  OptionsWidget(OptionsField field, IftFormState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return OptionsFieldState();
  }
}

class OptionsFieldState extends FieldWidgetState<OptionsWidget> {
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
      child: Text(
        valueOrHint(curValue),
        style: TextStyle(color: isReadOnly ? Colors.grey : Colors.black),
      ),
    );
    return FieldRow(
      child: root,
      onTap: isReadOnly ? null : () => _showOptionsDialog(widget.field.label),
      fieldWidget: widget,
      isReadOnly: isReadOnly,
      fieldWidgetState: this,
      isFocused: false,
      errorText: getErrorMsg(),
    );
  }

  void _showOptionsDialog(String title) async {
    Object result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => true, //false,表示拒绝关闭
            child: SimpleDialog(
              children: _optionsToMenu(),
            ),
          );
        });
    if (result != null) {
      setState(() {
        curValue = result;
        notifyValueChanged();
      });
    }
  }

  List<Widget> _optionsToMenu() {
    var menus = List<Widget>();
    List<Object> dataSource = _getDataSource();
    if (dataSource != null) {
      for (var item in dataSource) {
        menus.add(_OptionsItem(item));
      }
    }
    return menus;
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

class _OptionsItem<T> extends StatelessWidget {
  T value;

  _OptionsItem(this.value);

  @override
  Widget build(BuildContext context) {
    String title;
    if (value is String) {
      title = value as String;
    } else {
      title = value.toString();
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(value);
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
