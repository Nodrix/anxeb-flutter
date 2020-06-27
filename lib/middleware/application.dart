import 'package:anxeb_flutter/anxeb.dart';
import 'package:anxeb_flutter/middleware/settings.dart';
import 'package:flutter/material.dart' hide Navigator;

import 'api.dart';
import 'disk.dart';
import 'navigator.dart';

class Application {
  Settings _settings;
  Api _api;
  String _title;
  Disk _disk;
  Navigator _navigator;

  Application() {
    _settings = Settings();
    _title = 'Anxeb';
    _disk = Disk();
    _navigator = Navigator(this);

    init();
  }

  @protected
  void init() {}

  Settings get settings => _settings;

  String get version => 'v0.0.0';

  Api get api => _api;

  @protected
  set api(value) {
    _api = value;
  }

  String get title => _title;

  @protected
  set title(value) {
    _title = value;
  }

  Navigator get navigator => _navigator;

  @protected
  set navigator(value) {
    _navigator = value;
  }

  Disk get disk => _disk;
}