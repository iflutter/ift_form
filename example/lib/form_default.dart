import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';

class VIds {
  static const phone = '#phone';
  static const number = '#number';
  static const int = '#int';
  static const email = '#email';
}

class FieldConstraint {
  static const keyMappingValidators = {
    VIds.phone: r"^1\d{10}$",
    VIds.number: r"^\d*(\.\d{1,2})?$",
    VIds.int: r"^\d*$",
    VIds.email:
        r"^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$",
  };
}

class DefaultForm extends IftForm {
  DefaultForm(
      {Key key,
      FormFormat format,
      List<Field> fields,
      OnValueChanged onValueChanged,
      String formExpression,
      FormFieldDecorator fieldDecorator,
      Map<String, Object> initData,
      HashSet<String> readOnlyKeys,
      Map<String, Object> optionsDataSource,
      Map<String, SelectorHandler> selectorHandlerMap,
      Map<String, PickerBuilder> pickerBuilderMap,
      DataSourceFilter dataSourceFilter,
      CustomFieldFactory customFieldFactory,
      SelectorHandlerFilter selectorHandlerFilter})
      : super(
            key: key,
            format: format == null ? FormBuilderConfig.format : format,
            fields: fields,
            onValueChanged: onValueChanged,
            fieldDecorator: FormBuilderConfig.fieldsDecorator,
            formExpression: formExpression,
            initData: initData,
            readOnlyKeys: readOnlyKeys,
            validators: FieldConstraint.keyMappingValidators,
            optionsDataSource: optionsDataSource,
            selectorHandlerMap: selectorHandlerMap,
            pickerBuilderMap: pickerBuilderMap,
            dataSourceFilter: dataSourceFilter,
            customFieldFactory: customFieldFactory,
            selectorHandlerFilter: selectorHandlerFilter);
}

class FormBuilderConfig {
  FormBuilderConfig._();

  static final format = FormFormat(
    tipsHintInput: '请输入${FormFormat.pl_label}',
    tipsRequired: "${FormFormat.pl_label}为必填选项",
  );
  static final fieldsDecorator = FieldsDecorator();
}

class FieldsDecorator extends FormFieldDecorator {
  static const String ic_add = 'id::+';
  static const String ic_arrow_right = 'id::>';
  static const String ic_required = 'id::*';
  static Map<String, StringWidgetBuilder> _defaultFactory = {
    ic_add: (BuildContext context, String strId) {
      return Icon(Icons.add);
    },
    ic_arrow_right: (BuildContext context, String strId) {
      return Icon(Icons.arrow_right);
    },
    ic_required: (BuildContext context, String strId) {
      return Text(
        '*',
        style: TextStyle(color: Colors.red),
      );
    }
  };

  @override
  Widget createWidgetByStringId(BuildContext context, String textId) {
    var func = _defaultFactory[textId];
    return func == null ? null : func(context, textId);
  }

  @override
  Decorator decorateField(
      BuildContext context, Field field, FieldRow fieldRow) {
    if (fieldRow.isReadOnly != null && fieldRow.isReadOnly) {
      return null;
    }
    Decorator result;
    if (field.isRequired != null && field.isRequired) {
      if (result == null) {
        result = Decorator();
      }
      result.rootPrefix = Text(
        '*',
        style: TextStyle(color: Colors.red),
      );
    }
    switch (field.runtimeType) {
      case DateField:
      case SelectorField:
        if (result == null) {
          result = Decorator();
        }
        result.rootSuffix = Icon(Icons.arrow_right);
        break;
      case OptionsField:
        if (result == null) {
          result = Decorator();
        }
        result.rootSuffix = Icon(Icons.arrow_drop_down);
        break;
    }
    return result;
  }
}
