// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimerStore on _TimerStoreBase, Store {
  Computed<String>? _$formattedTimeComputed;

  @override
  String get formattedTime =>
      (_$formattedTimeComputed ??= Computed<String>(() => super.formattedTime,
              name: '_TimerStoreBase.formattedTime'))
          .value;

  late final _$elapsedTimeAtom =
      Atom(name: '_TimerStoreBase.elapsedTime', context: context);

  @override
  int get elapsedTime {
    _$elapsedTimeAtom.reportRead();
    return super.elapsedTime;
  }

  @override
  set elapsedTime(int value) {
    _$elapsedTimeAtom.reportWrite(value, super.elapsedTime, () {
      super.elapsedTime = value;
    });
  }

  late final _$startCountAtom =
      Atom(name: '_TimerStoreBase.startCount', context: context);

  @override
  int get startCount {
    _$startCountAtom.reportRead();
    return super.startCount;
  }

  @override
  set startCount(int value) {
    _$startCountAtom.reportWrite(value, super.startCount, () {
      super.startCount = value;
    });
  }

  late final _$stopCountAtom =
      Atom(name: '_TimerStoreBase.stopCount', context: context);

  @override
  int get stopCount {
    _$stopCountAtom.reportRead();
    return super.stopCount;
  }

  @override
  set stopCount(int value) {
    _$stopCountAtom.reportWrite(value, super.stopCount, () {
      super.stopCount = value;
    });
  }

  late final _$isRunningAtom =
      Atom(name: '_TimerStoreBase.isRunning', context: context);

  @override
  bool get isRunning {
    _$isRunningAtom.reportRead();
    return super.isRunning;
  }

  @override
  set isRunning(bool value) {
    _$isRunningAtom.reportWrite(value, super.isRunning, () {
      super.isRunning = value;
    });
  }

  late final _$_TimerStoreBaseActionController =
      ActionController(name: '_TimerStoreBase', context: context);

  @override
  void startTimer() {
    final _$actionInfo = _$_TimerStoreBaseActionController.startAction(
        name: '_TimerStoreBase.startTimer');
    try {
      return super.startTimer();
    } finally {
      _$_TimerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopTimer() {
    final _$actionInfo = _$_TimerStoreBaseActionController.startAction(
        name: '_TimerStoreBase.stopTimer');
    try {
      return super.stopTimer();
    } finally {
      _$_TimerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementTime() {
    final _$actionInfo = _$_TimerStoreBaseActionController.startAction(
        name: '_TimerStoreBase.incrementTime');
    try {
      return super.incrementTime();
    } finally {
      _$_TimerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetTimer() {
    final _$actionInfo = _$_TimerStoreBaseActionController.startAction(
        name: '_TimerStoreBase.resetTimer');
    try {
      return super.resetTimer();
    } finally {
      _$_TimerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
elapsedTime: ${elapsedTime},
startCount: ${startCount},
stopCount: ${stopCount},
isRunning: ${isRunning},
formattedTime: ${formattedTime}
    ''';
  }
}
