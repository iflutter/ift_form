import 'package:flutter/material.dart';

class FieldWidgetBox extends StatelessWidget {
  final Widget child;
  final String errorText;
  final bool isFocused;
  final bool isReadOnly;

  FieldWidgetBox({this.child, this.errorText, this.isFocused, this.isReadOnly});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Container(
        decoration: BoxDecoration(
          color: isReadOnly ? Colors.grey[50] : Colors.white,
          border: Border(
            bottom: BorderSide(
              color:
                  isFocused ? Theme.of(context).primaryColor : Colors.grey[300],
              width: 1,
            ),
          ),
        ),
        child: child,
      ),
    ];
    if (errorText != null && errorText.isNotEmpty) {
      children.add(
        Text(
          errorText,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Theme.of(context).errorColor,
            fontSize: 15,
          ),
        ),
      );
    }
    return Column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
