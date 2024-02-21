import 'package:anxeb_flutter/middleware/dialog.dart';
import 'package:anxeb_flutter/middleware/scope.dart';
import 'package:anxeb_flutter/widgets/buttons/text.dart';
import 'package:flutter/material.dart' hide Dialog, TextButton;

class MessageDialog extends ScopeDialog {
  final String title;
  final String message;
  final Widget Function(BuildContext) body;
  final IconData icon;
  final double iconSize;
  final Color messageColor;
  final Color titleColor;
  final Color iconColor;
  final List<DialogButton> buttons;
  final TextAlign textAlign;
  final EdgeInsets contentPadding;
  final EdgeInsets insetPadding;
  final BorderRadius borderRadius;
  final double width;

  MessageDialog(
    Scope scope, {
    this.title,
    this.message,
    this.body,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.messageColor,
    this.titleColor,
    this.buttons,
    this.textAlign,
    this.contentPadding,
    this.insetPadding,
    this.borderRadius,
    this.width,
    bool dismissible,
  }) : super(scope) {
    super.dismissible = dismissible != null ? dismissible : (this.buttons == null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(scope.application.settings.dialogs.dialogRadius ?? 20.0))),
      contentPadding: contentPadding ?? EdgeInsets.only(bottom: 20, left: 24, right: 24, top: 5),
      insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      contentTextStyle: TextStyle(fontSize: title != null ? 16.4 : 20, color: messageColor ?? scope.application.settings.colors.text, fontWeight: FontWeight.w400),
      title: title != null
          ? Container(
              width: width,
              child: Row(
                children: <Widget>[
                  icon != null
                      ? Container(
                          padding: EdgeInsets.only(right: 7),
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.0, color: scope.application.settings.colors.separator),
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: iconSize ?? 72,
                            color: iconColor ?? scope.application.settings.colors.primary,
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      softWrap: width != null,
                      textAlign: icon == null ? TextAlign.center : TextAlign.left,
                      style: TextStyle(fontSize: 16.2, color: titleColor ?? scope.application.settings.colors.primary, fontWeight: FontWeight.w500, letterSpacing: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : icon != null
              ? Container(
                  child: Icon(
                    icon,
                    size: iconSize ?? 150,
                    color: iconColor ?? scope.application.settings.colors.primary,
                  ),
                )
              : Container(),
      content: Container(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            message != null
                ? Container(
                    padding: EdgeInsets.only(bottom: 4, top: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: new Text(
                            message,
                            softWrap: true,
                            textAlign: textAlign ?? (title != null ? TextAlign.left : TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            body?.call(context) ?? Container(),
            buttons != null
                ? Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: TextButton.createList(context, buttons, settings: scope.application.settings),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
