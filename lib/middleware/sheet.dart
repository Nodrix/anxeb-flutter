import 'package:anxeb_flutter/services/sheets/tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'scope.dart';

class Sheet {
  final Scope scope;

  Sheet(this.scope);

  @protected
  Widget build(BuildContext context) {
    return Container();
  }

  Future show() async {
    return showModalBottomSheet<void>(
      context: scope.context,
      builder: (BuildContext context) {
        return build(context);
      },
    );
  }
}

class ScopeSheets {
  Scope _scope;

  ScopeSheets(Scope scope) {
    _scope = scope;
  }

  TipSheet success(String title, {String message, Widget body}) {
    return TipSheet(
      _scope,
      title: title,
      fill: _scope.application.settings.colors.success,
      foreground: Colors.white,
      message: message,
      body: body,
      icon: Icons.check_circle,
    );
  }

  TipSheet information(String title, {String message, Widget body}) {
    return TipSheet(
      _scope,
      title: title,
      fill: _scope.application.settings.colors.info,
      foreground: Colors.white,
      message: message,
      body: body,
      icon: Icons.info,
    );
  }

  TipSheet tip(String title, {String message, Widget body}) {
    return TipSheet(
      _scope,
      title: title,
      fill: _scope.application.settings.colors.tip,
      message: message,
      body: body,
      icon: Ionicons.md_bulb,
    );
  }

  TipSheet warning(String title, {String message, Widget body}) {
    return TipSheet(
      _scope,
      title: title,
      fill: _scope.application.settings.colors.danger,
      foreground: Colors.white,
      message: message,
      body: body,
      icon: Icons.warning,
    );
  }

  TipSheet neutral(String title, {String message, Widget body}) {
    return TipSheet(
      _scope,
      title: title,
      fill: Colors.white,
      message: message,
      body: body,
      icon: Icons.chat,
    );
  }
}