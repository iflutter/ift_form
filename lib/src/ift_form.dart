import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

abstract class FormFieldDecorator {
  Widget createWidgetByStringId(BuildContext context, String textId);

  Decorator decorateField(BuildContext context, Field field, FieldRow fieldRow);
}

typedef PickerBuilder = Widget Function(
    BuildContext context, FieldWidgetState fieldWidgetState);
typedef OnValueChanged = void Function(Field field, dynamic value);

class FormFormat {
  //
  static const pl_label = r'$label';
  final String tipsHintInput;
  final String tipsHintSelector;
  final String tipsHintOptions;
  final String tipsRequired;

  FormFormat(
      {this.tipsHintInput,
      this.tipsHintSelector,
      this.tipsHintOptions,
      this.tipsRequired});
}

typedef DataSourceFilter = List<Object> Function(String dataSourceId);
typedef SelectorHandlerFilter = SelectorHandler Function(String dataSourceId);
typedef CustomFieldFactory = CustomFieldBuilder Function(String dataSourceId);

class IftForm extends StatefulWidget {
  static const FieldTypeString = 'string';
  static const FieldTypeTextarea = 'textarea';
  static const FieldTypePwd = 'pwd';
  static const FieldTypeEmail = 'email';
  static const FieldTypeNumber = 'number';
  static const FieldTypePhone = 'phone';
  static const FieldTypeTelPhone = 'tel';
  static const FieldTypeMoney = 'money';
  static const FieldTypePassword = 'password';
  static const FieldTypeOptions = 'options';
  static const FieldTypeSelector = 'selector';
  static const FieldTypeDivider = 'divider';
  static const FieldTypeHint = 'hint';
  static const FieldTypeTitle = 'title';
  static const FieldTypeDate = 'date';
  static const FieldTypeRadioGroup = 'radio';
  static const FieldTypeCustom = 'custom';

  static const ReadonlyAll = '*readonly';

  final FormFormat format;
  final List<Field> fields;
  final OnValueChanged onValueChanged;
  final FormFieldDecorator fieldDecorator;
  final Map<String, Object> initData;
  final HashSet<String> readOnlyKeys;
  final Map<String, Object> optionsDataSource;
  final Map<String, Object> validators;
  final Map<String, SelectorHandler> selectorHandlerMap;
  final Map<String, PickerBuilder> pickerBuilderMap;
  final CustomFieldFactory customFieldFactory;
  final String formExpression;
  final DataSourceFilter dataSourceFilter;
  final SelectorHandlerFilter selectorHandlerFilter;
  final String defaultDateValueFormat;

  IftForm(
      {this.format,
      this.fields,
      this.fieldDecorator,
      this.onValueChanged,
      this.formExpression,
      this.initData,
      this.readOnlyKeys,
      this.optionsDataSource,
      this.validators,
      this.selectorHandlerMap,
      this.pickerBuilderMap,
      this.dataSourceFilter,
      this.selectorHandlerFilter,
      this.defaultDateValueFormat,
      this.customFieldFactory,
      Key key})
      : super(key: key) {
    assert(this.format != null);
    //print("FormBuilder create exp:$formExpression");
  }

  @override
  State<StatefulWidget> createState() {
    return IftFormState(fields: fields, formExpression: formExpression);
  }
}

class IftFormState extends State<IftForm> {
  final List<FieldWidget> fieldWidgets = List<FieldWidget>();
  String formExpression;
  List<Field> fields;
  final Map<String, Field> _fieldsMap = {};

  IftFormState({this.fields, this.formExpression}) {
    if (this.formExpression != null) {
      fields = FormParser.instance().parseForm(formExpression).fields;
    }
    if (fields != null) {
      for (var f in fields) {
        _fieldsMap[f.key] = f;
      }
    }
  }

  bool validate({ScrollController scrollController}) {
    bool isOk = true;
    double firstFailedCellOffsetY = -1;
    for (var f in fieldWidgets) {
      if (f.key is GlobalKey<FieldWidgetState>) {
        GlobalKey<FieldWidgetState> fs = f.key;
        isOk = fs.currentState.validate() && isOk;
        if (!isOk && firstFailedCellOffsetY < 0) {
          final RenderBox box = fs.currentContext.findRenderObject();
          //final size = box.size;
          final topLeftPosition = box.localToGlobal(_getSelfGlobalTopOffset());
          firstFailedCellOffsetY = topLeftPosition.dy;
        }
      }
    }
//    if (callback != null) {
//      callback(isOk, firstFailedCellOffsetY, null);
//    }
    if (scrollController != null && !isOk && firstFailedCellOffsetY > 0) {
      scrollController.jumpTo(firstFailedCellOffsetY);
    }
    return isOk;
  }

  bool validateFieldByKey(String key, {ScrollController scrollController}) {
    bool isOk = true;
    double firstFailedCellOffsetY = -1;
    for (var f in fieldWidgets) {
      if (f.field.key == key) {
        if (f.key is GlobalKey<FieldWidgetState>) {
          GlobalKey<FieldWidgetState> fs = f.key;
          isOk = fs.currentState.validate() && isOk;
          if (!isOk && firstFailedCellOffsetY < 0) {
            final RenderBox box = fs.currentContext.findRenderObject();
            //final size = box.size;
            final topLeftPosition = box.localToGlobal(
                _getSelfGlobalTopOffset());
            firstFailedCellOffsetY = topLeftPosition.dy;
          }
        }
        break;
      }
    }
    if (scrollController != null && !isOk && firstFailedCellOffsetY > 0) {
      scrollController.jumpTo(firstFailedCellOffsetY);
    }
    return isOk;
  }

  Map<String, Object> save({
    bool keepNullValue = false,
    bool ignoreLocalKey = false,
  }) {
    var out = <String, Object>{};
    if (fields == null) {
      return out;
    }
    for (Field fw in fields) {
      String key = fw.key;
      if (key == null) {
        continue;
      }
      if (ignoreLocalKey) {
        if (key.startsWith('#')) {
          continue;
        }
      }
      var value = fw.getValue();
      if (!keepNullValue) {
        if (value == null) {
          continue;
        }
        if (value is String && value.isEmpty) {
          continue;
        }
      }
      if (value is OptionItem) {
        out[key] = value.value;
      } else {
        out[key] = value;
      }
    }
    return out;
  }

  @override
  void didUpdateWidget(IftForm oldWidget) {
    setState(() {
      //是否需要自己检车对比数据一致性
      if (widget.formExpression == null) {
        this.formExpression = null;
        this.fields = widget.fields;
      } else {
        if (this.formExpression != widget.formExpression) {
          this.fields = FormParser.instance()
              .parseForm(widget
                  .formExpression) //use new form expression parse and update form fields
              .fields;
          if (fields != null) {
            _fieldsMap.clear();
            for (var f in fields) {
              _fieldsMap[f.key] = f;
            }
          }
          this.formExpression = widget.formExpression;
        }
      }
    });
    //print("old fields:${oldWidget.fields?.length},${widget.fields?.length}");
    super.didUpdateWidget(oldWidget);
  }

  void notifyValueChanged(Field field, dynamic value) {
    if (widget.onValueChanged != null) {
      widget.onValueChanged(field, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkBuildForm(context);
    //print('form state invoke build');
    return Form(
      child: Column(
        children: fieldWidgets,
      ),
    );
  }

  String obtainHint(Field field) {
    if (field.hint != null) {
      return field.hint;
    }
    String formatStr;
    switch (field.runtimeType) {
      case InputField:
        formatStr = widget.format?.tipsHintInput;
        break;
      case OptionsField:
        formatStr = widget.format?.tipsHintOptions;
        break;
      case SelectorField:
      case DateField:
        formatStr = widget.format?.tipsHintSelector;
        break;
    }
    String result = formatStr?.replaceAll(FormFormat.pl_label, field.label);
    return result ?? '';
  }

  List<Object> getDataSourceById(String id) {
    if (widget.dataSourceFilter != null) {
      var result = widget.dataSourceFilter(id);
      if (result != null) {
        return result;
      }
    }
    if (widget.optionsDataSource == null) {
      return null;
    } else {
      return widget.optionsDataSource[id];
    }
  }

  dynamic getValidatorById(String id) {
    if (widget.validators != null) {
      return widget.validators[id];
    }
    return null;
  }

  SelectorHandler getSelectorHandlerById(String id) {
    if (widget.selectorHandlerFilter != null) {
      var result = widget.selectorHandlerFilter(id);
      if (result != null) {
        return result;
      }
    }
    if (widget.selectorHandlerMap == null) {
      return null;
    } else {
      return widget.selectorHandlerMap[id];
    }
  }

  CustomFieldBuilder createCustomFieldBuilder(String id) {
    if (widget.customFieldFactory == null) {
      return null;
    }
    return widget.customFieldFactory(id);
  }

  String obtainRequieredTips(Field field) {
    String result = widget.format?.tipsRequired
        ?.replaceAll(FormFormat.pl_label, field.label);
    return result ?? '';
  }

  Object getInitValue(Field field) {
    if (widget.initData == null) {
      return null;
    } else {
      return widget.initData[field.key];
    }
  }

  String getDateValueFomratDefault() {
    return widget.defaultDateValueFormat;
  }

  bool isReadOnlyField(Field field) {
    if (field == null) {
      return false;
    }
    if (field.isReadOnly) {
      return true;
    }
    if (widget.readOnlyKeys != null) {
      if (widget.readOnlyKeys.contains(IftForm.ReadonlyAll)) {
        return true;
      }
      return widget.readOnlyKeys.contains(field.key);
    }
    return false;
  }

  bool isReadOnly(String key) {
    return isReadOnlyField(_fieldsMap[key]);
  }

  Field getFieldByKey(String key) {
    return _fieldsMap[key];
  }

  Widget createStringWidget(BuildContext context, String strId) {
    return widget.fieldDecorator?.createWidgetByStringId(context, strId);
  }

  Widget createPicker(BuildContext context, String pickerId,
      FieldWidgetState fieldWidgetState) {
    if (widget.pickerBuilderMap == null) {
      return null;
    }
    var pickerBuilder = widget.pickerBuilderMap[pickerId];
    if (pickerBuilder == null) {
      return null;
    }
    return pickerBuilder(context, fieldWidgetState);
  }

  bool ignoreEmptyReadOnly = false;

  _checkBuildForm(BuildContext context) {
    if (fieldWidgets.isNotEmpty) {
      fieldWidgets.clear();
    }
    if (fields == null || fields.isEmpty) {
      return;
    }
    for (Field f in fields) {
      if (ignoreEmptyReadOnly) {
        if (isReadOnlyField(f)) {
          if (getInitValue(f) == null) {
            continue;
          }
        }
      }
      var w = f.build(this, context);
      if (w != null) {
        //print('create field:${f.label}');
        fieldWidgets.add(w);
      }
    }
  }

  Offset _getSelfGlobalTopOffset() {
    if (widget.key == null) {
      return Offset.zero;
    }
    BuildContext currentContext;
    if (widget.key is GlobalKey) {
      currentContext = (widget.key as GlobalKey).currentContext;
    } else if (widget.key is LabeledGlobalKey) {
      currentContext = (widget.key as LabeledGlobalKey).currentContext;
    }
    if (currentContext == null) {
      return Offset.zero;
    }
    final RenderBox box = currentContext.findRenderObject();
    return Offset(0, -box.localToGlobal(Offset.zero).dy);
  }
}
