import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:intl/intl.dart';

class DateWidget extends FieldWidget<DateField> {
  DateWidget(DateField field, FormBuilderState formState, {Key key})
      : super(field, formState, key: key);

  @override
  State<StatefulWidget> createState() {
    return DateFieldState();
  }
}

class DateFieldState extends FieldWidgetState<DateWidget> {
  DateTime curValue;

//yyyyMMdd
  static const dateFormatDef = 'yyyyMMdd';

  String _getDateFormatStr() {
    return widget.formState.getDateValueFomratDefault() ?? dateFormatDef;
  }

  @override
  void initState() {
    var initValue = widget.formState.getInitValue(widget.field);
    if (initValue is DateTime) {
      curValue = initValue;
    } else if (initValue != null && initValue is String) {
      try {
        //输入的是yyyyMMdd
        String t = initValue as String;
        String dateFormat = _getDateFormatStr();
        if (dateFormat == dateFormatDef) {
          if (t.length >= 6) {
            t = "${t.substring(0, 4)},${t.substring(4, 6)},${t.substring(6, 8)}";
          }
          curValue = DateFormat('yyyy,MM,dd').parse(t);
        } else {
          curValue = DateFormat(dateFormat).parse(t);
        }
      } catch (error) {
        print(error);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateStr;
    if (curValue != null) {
      try {
        dateStr = DateFormat('yyyy年MM月dd日').format(curValue);
      } catch (error) {
        print(error);
      }
    }
    final isReadOnly = widget.formState.isReadOnlyField(widget.field);
    var root = Container(
      alignment: Alignment.centerRight,
      child: Text(
        valueOrHint(dateStr),
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
    if (curValue == null) {
      return null;
    }
    return DateFormat(_getDateFormatStr()).format(curValue);
  }

  void _onTap() async {
    var initData = curValue;
    if (initData == null) {
      initData = DateTime.now();
    }
    DateTime lastDate;
    if (widget.field.lastDate != null) {
      if (widget.field.lastDate == '-1') {
        lastDate = DateTime.parse('9999-12-31');
      } else {
        lastDate = DateTime.tryParse(widget.field.lastDate);
      }
    }
    if (lastDate == null) {
      lastDate = DateTime.now();
    }
    var result = await showDatePicker(
        context: context,
        initialDate: initData,
        firstDate: DateTime(1988, 1, 19),
        lastDate: lastDate);
    if (result != null) {
      setState(() {
        curValue = result;
        notifyValueChanged();
      });
    }
  }
}
