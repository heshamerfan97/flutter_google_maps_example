import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';

import 'package:flutter/foundation.dart';

class Logger {
  static const String tag = "Flutter :";

  /// Normal Text
  static log(dynamic msg, {String tag = tag}) {
    if (!kReleaseMode) {
      developer.log('$msg', name: tag);
    }
  }

  /// Normal Text
  static logCubit(Change change, String cubitName) {
    if (!kReleaseMode) {
      developer.log('${change.currentState} => ${change.nextState}', name: '📦 Cubit $cubitName Change 📦');
    }
  }

  /// Blue text
  static void logInfo(dynamic msg, {String tag = tag}) {
    if (!kReleaseMode) {
      developer.log('$msg', name: '📘 $tag');
    }
  }

  /// Green text
  static void logSuccess(dynamic msg, {String tag = tag}) {
    if (!kReleaseMode) {
      developer.log('$msg', name: '📗 $tag');
    }
  }

  /// Yellow text
  static void logWarning(dynamic msg, {String tag = tag}) {
    if (!kReleaseMode) {
      developer.log('$msg', name: '📒 $tag');
    }
  }

  /// Red text
  static void logError(dynamic msg, {String tag = tag}) {
    if (!kReleaseMode) {
      developer.log('🛑 $msg 🛑', name: '📕 $tag');
    }
  }

  ///Singleton factory
  static final Logger _instance = Logger._internal();

  factory Logger() {
    return _instance;
  }

  Logger._internal();
}
