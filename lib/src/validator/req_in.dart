import 'package:ift_form/ift_form.dart';

class VReqIn extends Validator {
  List<String> reqInKeys;

  VReqIn(this.reqInKeys);

  @override
  validate(IftFormState formState, Field field, value) {
    if (reqInKeys == null || reqInKeys.isEmpty) {
      return null;
    }
    StringBuffer sb;
    for (String key in reqInKeys) {
      Field f = formState.getFieldByKey(key);
      var value = f.getValue();
      if (value != null) {
        if (value is! String || (value as String).isNotEmpty) {
          return null;
        }
      }
      if (sb == null) {
        sb = StringBuffer();
      }
      sb.write(f.label);
      sb.write(' ');
    }
    sb.write("选填一项");
    return sb.toString();
  }
}
