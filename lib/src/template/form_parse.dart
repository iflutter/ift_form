import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'package:ift_form/src/field/custom/custom.dart';
import 'package:ift_form/src/field/radio/radios.dart';
import 'package:ift_form/src/validator/cmd.dart';
import 'package:ift_form/src/validator/field_equal.dart';
import 'package:ift_form/src/validator/req_in.dart';

import '../field/title/title.dart';

///类型
///string 字符串
///digital 纯数字
///email 字符串，同时有默认邮件验证规则
///option(workType) 选项，后面跟的是选项列表id
///selector(time),selector(image) 选择器，后面跟的是选择器的id
///
///函数 len(5,6),value(15,25) 常规校验器
///
///装饰器
///suffixText，prefixText,suffixId(money)，prefixId()
///suffixText(0xFF0000,16,元)
/////

class FormInfo {
  final List<Field> fields;

  //final Map<String, Field> fieldsMap;

  FormInfo(this.fields);
}

class FormParser {
  static final FormParser parser = FormParser._();

  factory FormParser.instance() {
    return parser;
  }

  FormParser._() {
    //
  }

  FormInfo parseForm(String formStr) {
    var fieldList = <Field>[];
    var formInfo = FormInfo(fieldList);
    var list = formStr.split('\n');
    for (String fieldStr in list) {
      fieldStr = fieldStr.trim();
      if (fieldStr.length <= 0) {
        continue;
      }
      Field field = _parseField(fieldStr);
      if (field != null) {
        fieldList.add(field);
      }
    }
    return formInfo;
  }

  static final _flagFunStart = '>';
  static final _flagWhiteSpaceCode = ' '.codeUnitAt(0);
  static final _flagWhiteSpaceTabCode = '	'.codeUnitAt(0);
  static final _flagFunStartCode = _flagFunStart.codeUnitAt(0);
  static final _flagSingleQuotationCode = '"'.codeUnitAt(0);
  static final _flagDoubleQuotationCode = "'".codeUnitAt(0);

  bool _isWhiteSpace(int code) {
    return code == _flagWhiteSpaceCode || code == _flagWhiteSpaceTabCode;
  }

  Field _parseField(String fieldStr) {
    String baseInfoStr;
    String funcDefinesStr;

    final funcStartIndex = fieldStr.indexOf(_flagFunStart);
    if (funcStartIndex > 0) {
      baseInfoStr = fieldStr.substring(0, funcStartIndex);
      funcDefinesStr = fieldStr.substring(funcStartIndex + 1);
    } else {
      baseInfoStr = fieldStr;
    }
    if (baseInfoStr != null && baseInfoStr.isNotEmpty) {
      Field field = _parseBaseInfo(baseInfoStr);
      if (field != null &&
          funcDefinesStr != null &&
          funcDefinesStr.isNotEmpty) {
        _parseFuncs(field, funcDefinesStr);
      }
      return field;
    }
    return null;
  }

  Field _parseBaseInfo(String baseInfoStr) {
    if (baseInfoStr.startsWith('-')) {
      //'-'开头定义的表示field不需要结果，所以不需要key，title，hint
      //所以需要有限解析field type
      return _parseNoValueField(baseInfoStr.substring(1, baseInfoStr.length));
    } else {
      return _parseValueField(baseInfoStr);
    }
  }

  Field _parseValueField(String baseInfoStr) {
    //print("base---> $baseInfoStr");
    String key;
    int keyStartIndex = -1;
    String label;
    int labelStartIndex = -1;
    int labelEndCharCode = null;
    String hint;
    int hintStartIndex = -1;
    String fieldType;
    int fieldStartIndex = -1;
    for (int i = 0; i < baseInfoStr.length; i++) {
      var charCode = baseInfoStr.codeUnitAt(i);
      if (key == null) {
        if (keyStartIndex < 0 && _isWhiteSpace(charCode)) {
          continue;
        }
        if (keyStartIndex < 0) {
          keyStartIndex = i;
          continue;
        }
        if (_isWhiteSpace(charCode)) {
          key = baseInfoStr.substring(keyStartIndex, i).trim();
          //print("find key end----->$key");
        }
      } else if (label == null) {
        if (labelStartIndex < 0 && _isWhiteSpace(charCode)) {
          continue;
        }
        if (labelStartIndex < 0) {
          labelStartIndex = i;
          if (charCode == _flagSingleQuotationCode ||
              charCode == _flagDoubleQuotationCode) {
            labelEndCharCode = charCode;
          }
          continue;
        }
        if (labelEndCharCode == null) {
          if (_isWhiteSpace(charCode)) {
            label = baseInfoStr.substring(labelStartIndex, i).trim();
          }
        } else if (charCode == labelEndCharCode) {
          //label with quotation marks
          label = baseInfoStr.substring(labelStartIndex + 1, i).trim();
        }
      } else if (fieldType == null) {
        if (fieldStartIndex < 0 && _isWhiteSpace(charCode)) {
          continue;
        }
        if (fieldStartIndex < 0) {
          fieldStartIndex = i;
          continue;
        }
        if (_isWhiteSpace(charCode)) {
          fieldType = baseInfoStr.substring(fieldStartIndex, i).trim();
          //print("find type end----->$fieldType");
        }
      } else {
        hint = baseInfoStr.substring(i, baseInfoStr.length).trim();
        //print("find hint end----->$label");
        break;
      }
    }
    if (fieldType == null) {
      fieldType = baseInfoStr.trim();
    }
    int typeArgSplitIndex = fieldType.indexOf(':');
    String typeArgId;
    if (typeArgSplitIndex > 0) {
      typeArgId = fieldType.substring(typeArgSplitIndex + 1, fieldType.length);
      fieldType = fieldType.substring(0, typeArgSplitIndex);
    }
    //print("parse base info  ----->$key,$label,$hint,$fieldType");
    final fieldTypeName = fieldType.toLowerCase();
    var field = makeField(fieldType, typeArgId, key, label, hint);
    if (field != null) {
      field.rawTypeName = fieldTypeName;
    }
    return field;
  }

  Field _parseNoValueField(String baseInfoStr) {
    String fieldType;
    //
    int typeArgSplitIndex = baseInfoStr.indexOf(':');
    String typeArg;
    if (typeArgSplitIndex > 0) {
      typeArg =
          baseInfoStr.substring(typeArgSplitIndex + 1, baseInfoStr.length);
      fieldType = baseInfoStr.substring(0, typeArgSplitIndex);
    } else {
      fieldType = baseInfoStr;
    }
    switch (fieldType.toLowerCase()) {
      case IftForm.FieldTypeDivider:
        return DividerField();
      case IftForm.FieldTypeHint:
        return HintField(hint: typeArg);
      case IftForm.FieldTypeTitle:
        return TitleField(label: typeArg);
    }
    return null;
  }

  Field makeField(String fieldType, String typeArgId, String key, String label,
      String hint) {
    switch (fieldType) {
      case IftForm.FieldTypeString:
        return InputField(key: key, label: label, hint: hint);
      case IftForm.FieldTypePwd:
        return InputField(
            key: key, label: label, hint: hint, obscureText: true);
      case IftForm.FieldTypeTextarea:
        return InputField(key: key, label: label, hint: hint)
          ..maxLines = 5
          ..minLines = 3;
      case IftForm.FieldTypeEmail:
        return InputField(key: key, label: label, hint: hint)
          ..textInputType = TextInputType.emailAddress;
      case IftForm.FieldTypeNumber:
        return InputField(key: key, label: label, hint: hint)
          ..textInputType = TextInputType.numberWithOptions(decimal: true);
      case IftForm.FieldTypePhone:
        return InputField(key: key, label: label, hint: hint)
          ..textInputType = TextInputType.phone
          ..maxLength = 11
          ..maxLength = 11;
      case IftForm.FieldTypeTelPhone:
        return InputField(key: key, label: label, hint: hint)
          ..textInputType = TextInputType.phone;
      case IftForm.FieldTypeMoney:
        return InputField(key: key, label: label, hint: hint)
          ..textInputType = TextInputType.numberWithOptions(decimal: true);
      case IftForm.FieldTypeOptions:
        return OptionsField(key: key, label: label, hint: hint)
          ..optionsDataSourceId = typeArgId;
      case IftForm.FieldTypeRadioGroup:
        return RadiosField(key: key, label: label, hint: hint)
          ..optionsDataSourceId = typeArgId;
      case IftForm.FieldTypeSelector:
        return SelectorField(key: key, label: label, hint: hint)
          ..selectorHandlerId = typeArgId;
      case IftForm.FieldTypeCustom:
        return CustomField(typeArgId, key: key, label: label, hint: hint);
      case IftForm.FieldTypeDivider:
        return DividerField();
      case IftForm.FieldTypeHint:
        return HintField(hint: hint ?? label);
      case IftForm.FieldTypeTitle:
        return TitleField(label: label);
      case IftForm.FieldTypeDate:
        return DateField(
            key: key, label: label, hint: hint, dateFormat: typeArgId);
    }
    return null;
  }

  static final _flagFuncNameEndCharWithArgs = '('.codeUnitAt(0);
  static final _flagFuncArgsEndChar = ')'.codeUnitAt(0);
  static final _flagComma = ','.codeUnitAt(0);

  void _parseFuncs(Field filed, String funcStr) {
    //find func name
    //find func arg '(,)'
    //print(funcStr);
    int funcNameStartIndex = -1;
    int funcArgsStartIndex = -1;
    String funcName;
    String funcArgsStr;
    bool isFirstFunc = true;
    final length = funcStr.length;
    final lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      var charCode = funcStr.codeUnitAt(i);
      if (funcNameStartIndex < 0 && _isWhiteSpace(charCode)) {
        continue;
      }
      if (funcNameStartIndex < 0) {
        if (isFirstFunc) {
          funcNameStartIndex = i;
          isFirstFunc = false;
        } else if (charCode == _flagComma) {
          funcNameStartIndex = i + 1;
        }
        continue;
      }
      if (funcArgsStartIndex < 0) {
        //check func name end
        if (charCode == _flagComma) {
          //find ',' func splitor
          funcName = funcStr.substring(funcNameStartIndex, i).trim();
          funcNameStartIndex = i + 1; //current func end,and new func start
          createFunInstance(filed, funcName, funcArgsStr);
        } else if (i == lastIndex || _isWhiteSpace(charCode)) {
          //reach origin funcs string end
          funcName = funcStr.substring(funcNameStartIndex, i + 1).trim();
          funcNameStartIndex = i + 1; //current func end,and new func start
          createFunInstance(filed, funcName, funcArgsStr);
        } else if (charCode == _flagFuncNameEndCharWithArgs) {
          //find args start'('
          funcName = funcStr.substring(funcNameStartIndex, i).trim();
          funcArgsStartIndex = i + 1; //make find func args
        }
      } else {
        //check func args end
        if (charCode == _flagFuncArgsEndChar) {
          funcArgsStr = funcStr.substring(funcArgsStartIndex, i);
          funcArgsStartIndex = -1; //reset to find func name
          funcNameStartIndex = -1; //reset find func name
          createFunInstance(filed, funcName, funcArgsStr);
          //print("find func name:$funcName,args:$funcArgsStr");
        }
      }
    }
  }

  void createFunInstance(Field field, String funcName, String argsRawStr) {
    //len(3,6) value(2,3) maxLines(5) suffixText(0xFF0000,16,元)
    ///suffixText，prefixText,suffixId(money)，prefixId()
    ///suffixText(0xFF0000,16,元)
    //print(funcName);
    switch (funcName.toLowerCase()) {
      case 'req':
        _parseValidateNotNull(field, argsRawStr);
        break;
      case 'reqin':
        _parseValidateReqIn(field, argsRawStr);
        break;
      case 'len':
        _parseValidateLength(field, argsRawStr);
        break;
      case 'vids': //vIds
        _parseValidateCmds(field, argsRawStr);
        break;
      case 'range':
        _parseValidateRange(field, argsRawStr);
        break;
      case 'readonly':
        field.isReadOnly = true;
        break;
      case 'prefixid':
        field.prefixId = argsRawStr.trim();
        break;
      case 'suffixid':
        field.suffixId = argsRawStr.trim();
        break;
      case 'prefixtext':
        _parseDecorator(field, argsRawStr, true);
        break;
      case 'suffixtext':
        _parseDecorator(field, argsRawStr, false);
        break;
      case 'lastdate':
        _parseDateEnd(field, argsRawStr);
        break;
      case 'picker':
        _parsePicker(field, argsRawStr);
        break;
      case 'fequal':
        _parseValidateFEqual(field, argsRawStr);
        break;
    }
  }

  void _parseValidateFEqual(Field field, String argsRawStr) {
    List<String> args = _parseNomralFuncArgs(argsRawStr);
    if (args == null || args.isEmpty) {
      return;
    }
    if (args.length > 1) {
      _addValidator(field, VFieldEqual(args[0], args[1]));
    } else {
      _addValidator(field, VFieldEqual(args[0], null));
    }
  }

  void _parsePicker(Field field, String argsRawStr) {
    field.pickerId = argsRawStr;
  }

  void _parseDateEnd(Field field, String argsRawStr) {
    if (field is DateField) {
      field.lastDate = argsRawStr;
    }
  }

  List<String> _parseNomralFuncArgs(String argsRawStr) {
    if (argsRawStr == null || argsRawStr.isEmpty) {
      return null;
    }
    return argsRawStr.split(',');
  }

  void _parseValidateNotNull(Field field, String argsRawStr) {
    field.isRequired = true;
    _addValidator(field, VNotNull());
  }

  void _parseValidateReqIn(Field field, String argsRawStr) {
    List<String> args = _parseNomralFuncArgs(argsRawStr);
    if (args == null || args.isEmpty) {
      return;
    }
    //print("reqId key:${args.toString()}");
    _addValidator(field, VReqIn(args));
  }

  int stringToIntFromList(List<String> source, int index) {
    if (source == null || index >= source.length) {
      return null;
    }
    return int.parse(source[index]);
  }

  double stringToDoubleFromList(List<String> source, int index) {
    if (source == null || index >= source.length) {
      return null;
    }
    return double.parse(source[index]);
  }

  void _parseValidateLength(Field field, String argsRawStr) {
    List<String> args = _parseNomralFuncArgs(argsRawStr);
    int min = stringToIntFromList(args, 0);
    int max = stringToIntFromList(args, 1);
    if (max == null) {
      max = min;
    }
    //print("------------------VLength>" + argsRawStr + "  $min   $max");
    _addValidator(field, VLength(min: min, max: max));
  }

  void _parseValidateCmds(Field field, String argsRawStr) {
    List<String> args = _parseNomralFuncArgs(argsRawStr);
    if (args != null && args.isNotEmpty) {
      _addValidator(field, VCmd(args));
    }
    //print("------------------Vcmds> ids:" + argsRawStr);
  }

  void _parseValidateRange(Field field, String argsRawStr) {
    List<String> args = _parseNomralFuncArgs(argsRawStr);
    double min = stringToDoubleFromList(args, 0);
    double max = stringToDoubleFromList(args, 1);
    if (max == null) {
      max = min;
    }
    //print("------------------VRange>" + argsRawStr + "  $min   $max");
    _addValidator(field, VRange(rangeStart: min, rangeEnd: max));
  }

  void _addValidator(Field field, Validator validator) {
    if (validator != null) {
      if (field.validators == null) {
        field.validators = [];
      }
      field.validators.add(validator);
    }
  }

  void _parseDecorator(Field field, String argsRawStr, bool isHeader) {
    String colorStr;
    String sizeStr;
    String text;
    int startIndex = 0;
    for (int i = 0; i < argsRawStr.length; i++) {
      if (colorStr == null && _flagComma == argsRawStr.codeUnitAt(i)) {
        colorStr = argsRawStr.substring(startIndex, i);
        startIndex = i + 1;
      } else if (sizeStr == null && _flagComma == argsRawStr.codeUnitAt(i)) {
        sizeStr = argsRawStr.substring(startIndex, i);
        startIndex = i + 1;
        //
        text = argsRawStr.substring(startIndex, argsRawStr.length);
        break;
      }
    }
    if (text != null) {
      colorStr = colorStr?.trim();
      sizeStr = sizeStr?.trim();
      if (isHeader) {
        field.prefixText = text;
        field.prefixTextStyle = _parseAppendedTextStyle(colorStr, sizeStr);
      } else {
        field.suffixText = text;
        field.suffixTextStyle = _parseAppendedTextStyle(colorStr, sizeStr);
      }
    }
  }

  int _ParseColor(String hexColor) {
    hexColor = hexColor.toUpperCase();
    hexColor = hexColor.replaceAll('#', '');
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  AppendedTextStyle _parseAppendedTextStyle(String colorStr, String sizeStr) {
    AppendedTextStyle style = AppendedTextStyle();
    try {
      style.color = _ParseColor(colorStr);
    } catch (e) {
      print(e);
    }
    try {
      style.fontSize = double.parse(sizeStr);
    } catch (e) {
      print(e);
    }
    return style;
  }
}
