import 'package:anxeb_flutter/widgets/fields/file.dart';
import 'package:anxeb_flutter/widgets/fields/files.dart';
import 'package:anxeb_flutter/widgets/fields/image.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'field.dart';
import 'model.dart';
import 'scope.dart';
import 'utils.dart';
import 'dart:io' as io;

class FieldsForm {
  Map<String, FieldState> fields;
  Map<String, GlobalKey<FieldState>> _keys;
  dynamic _initialValues;
  bool validated;
  ValueChanged<bool> onValidationChanged;

  FieldsForm([dynamic initialValues]) {
    fields = Map();
    _keys = Map();
    validated = false;
    _initialValues = initialValues ?? {};
  }

  GlobalKey<FieldState> key(String name) {
    var $key = _keys[name];
    if ($key == null) {
      $key = GlobalKey<FieldState>();
      _keys[name] = $key;
    }
    return $key;
  }

  void set(String fieldName, dynamic value) {
    if (fields[fieldName] != null) {
      fields[fieldName].value = value;
    }
  }

  dynamic get(String fieldName, {bool raw}) {
    if (raw == true) {
      return fields[fieldName]?.value;
    } else {
      return fields[fieldName]?.data();
    }
  }

  void update([dynamic data]) {
    validated = false;

    if (data is Model) {
      _initialValues = data.toObjects();
    } else if (data is Data) {
      _initialValues = data.toObjects();
    } else {
      _initialValues = data ?? {};
    }

    for (var field in fields.values) {
      if ((_initialValues as Map).containsKey(field.widget.name)) {
        field.reset();
        field.value = _initialValues[field.widget.name];
      }
    }
  }

  fetch() {
    for (var field in fields.values) {
      field.fetch();
    }
  }

  apply() {
    for (var field in fields.values) {
      field.apply();
    }
  }

  void focusNextInvalid() {
    for (var i = 0; i <= fields.length; i++) {
      for (var field in fields.values) {
        if (field.index == i) {
          if (!field.valid() && field.context != null) {
            field.focus();
            return;
          }
        }
      }
    }
  }

  void remove(String name) {
    fields.remove(name);
  }

  void clear([String fieldName]) {
    if (fieldName != null) {
      var field = fields[fieldName];
      field?.reset();
    } else {
      fields.entries.forEach((field) {
        field.value.reset();
      });
    }
  }

  bool focusFrom(int index, {bool onlyEmpty}) {
    for (var field in fields.values) {
      if (field.index == index + 1) {
        if (onlyEmpty != true || field.isEmpty) {
          field.focus();
          return true;
        }
        break;
      }
    }
    return false;
  }

  bool focus(String name, {bool force, String warning}) {
    var field = fields[name];

    if (field != null) {
      if (force == true || field.value == null) {
        field.focus(warning: warning);
        return true;
      }
    }
    return false;
  }

  bool select(String name) {
    var field = fields[name];

    if (field != null) {
      field.select();
      return true;
    }
    return false;
  }

  void include(FieldState current) {
    var $field = fields[current.widget.name];
    if ($field != null) {
      current.index = $field.index;
      current.value = $field.value;
    } else {
      current.index = fields.length;
      if (_initialValues != null) {
        if ((_initialValues as Map).containsKey(current.widget.name)) {
          current.value = _initialValues[current.widget.name];
        }
      }
    }
    fields[current.widget.name] = current;
  }

  bool validate({bool showMessage, bool autoFocus}) {
    var result = true;
    for (var field in fields.values) {
      if (field.mounted && field.context != null) {
        if (field.validate(showMessage: showMessage) != null) {
          if (autoFocus != false) {
            field.focus();
          }
          result = false;
          break;
        }
      }
    }
    if (validated != result) {
      validated = result;
      if (onValidationChanged != null) {
        onValidationChanged(validated);
      }
    }
    return result;
  }

  bool valid({bool autoFocus, bool showMessage}) {
    return validate(autoFocus: autoFocus, showMessage: showMessage);
  }

  Map<String, dynamic> data({bool images, bool files}) {
    if (validate()) {
      var data = Map<String, dynamic>();

      for (var field in fields.values) {
        var isImage = field.widget is ImageInputField;
        var isFile = field.widget is FileInputField || field.widget is FilesInputField;

        if (field.widget.visible != false) {
          if (((images == null) || (images == true && isImage) || (images == false && !isImage)) && ((files == null) || (files == true && isFile) || (files == false && !isFile))) {
            if (isFile == true || isImage == true) {
              if (field.data() == '') {
                continue;
              }
            }
            data[field.widget.name] = field.data();
          }
        }
      }
      return data;
    } else {
      return null;
    }
  }

  Map<String, FileInputValue> files() {
    var result = Map<String, FileInputValue>();

    var payload = data(files: true);
    payload.forEach((key, value) {
      final FileInputValue fileValue = value;
      if (fileValue?.title?.isNotEmpty == true) {
        result[key] = value;
      }
    });
    return result;
  }

  Future<Map<String, dynamic>> multipart() async {
    Map<String, FileInputValue> files = this.files();
    final Map<String, dynamic> multiPayload = {};

    final entries = files.entries;
    for (final entry in entries) {
      if (entry.value.path != null && await io.File(entry.value.path).exists()) {
        multiPayload[entry.key] = await Utils.convert.fromPathToMultipartFile(entry.value.path);
      }
    }
    return multiPayload;
  }

  Map<String, dynamic> value() {
    if (validate()) {
      var result = Map<String, dynamic>();

      for (var field in fields.values) {
        if (field.widget.visible != false) {
          result[field.widget.name] = field.value;
        }
      }
      return result;
    } else {
      return null;
    }
  }

  bool noneFocused() {
    for (MapEntry<String, FieldState> item in fields.entries) {
      if (item.value.focused == true) {
        return false;
      }
    }
    return true;
  }
}

class ScopeForms {
  Scope _scope;
  Map<String, FieldsForm> _forms;

  ScopeForms(Scope scope) {
    _scope = scope;
    _forms = Map<String, FieldsForm>();
  }

  bool validate(String name) {
    return _retrieve(name).validate();
  }

  bool valid({bool autoFocus}) {
    for (var $form in _forms.values) {
      if ($form.valid(autoFocus: autoFocus) == false) {
        return false;
      }
    }
    return true;
  }

  void focusNextInvalid(String name) {
    _retrieve(name).focusNextInvalid();
  }

  bool noneFocused() {
    for (var $form in _forms.values) {
      for (var item in $form.fields.entries) {
        if (item.value.focused == true) {
          return false;
        }
      }
    }
    return true;
  }

  Data data({bool separateByGroup}) {
    var result = Data();
    if (separateByGroup == true) {
      for (var $item in _forms.entries) {
        var groupName = $item.key;
        var $data = $item.value.data();
        if ($data != null) {
          result[groupName] = $data;
        }
      }
    } else {
      for (var $form in _forms.values) {
        var $data = $form.data();
        if ($data != null) {
          result.include($data);
        }
      }
    }
    return result;
  }

  Data values({bool separateByGroup}) {
    var result = Data();
    if (separateByGroup == true) {
      for (var $item in _forms.entries) {
        var groupName = $item.key;
        var $value = $item.value.value();
        if ($value != null) {
          result[groupName] = $value;
        }
      }
    } else {
      for (var $form in _forms.values) {
        var $value = $form.value();
        if ($value != null) {
          result.include($value);
        }
      }
    }
    return result;
  }

  FieldsForm _retrieve(String name) {
    var $form = _forms[name ?? _scope.key];
    if ($form == null) {
      $form = FieldsForm();
      _forms[name] = $form;
    }
    return $form;
  }

  FieldsForm get current => _retrieve(_scope.key);

  FieldsForm operator [](name) => _retrieve(name);

  key(String name, String field) {
    var $form = _retrieve(name);
    return $form.key(field);
  }
}
