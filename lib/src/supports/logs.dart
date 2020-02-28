import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger _logger = Logger();

void logs(dynamic value) {
  if (kDebugMode) {
    _logger.d(value);
  }
}
