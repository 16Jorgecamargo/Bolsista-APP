// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bolsista_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BolsistaStore on _BolsistaStoreBase, Store {
  late final _$bolsistasAtom =
      Atom(name: '_BolsistaStoreBase.bolsistas', context: context);

  @override
  ObservableList<Bolsista> get bolsistas {
    _$bolsistasAtom.reportRead();
    return super.bolsistas;
  }

  @override
  set bolsistas(ObservableList<Bolsista> value) {
    _$bolsistasAtom.reportWrite(value, super.bolsistas, () {
      super.bolsistas = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_BolsistaStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_BolsistaStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchBolsistasAsyncAction =
      AsyncAction('_BolsistaStoreBase.fetchBolsistas', context: context);

  @override
  Future<void> fetchBolsistas() {
    return _$fetchBolsistasAsyncAction.run(() => super.fetchBolsistas());
  }

  late final _$_BolsistaStoreBaseActionController =
      ActionController(name: '_BolsistaStoreBase', context: context);

  @override
  void atualizarBolsista(Bolsista bolsistaAtualizado) {
    final _$actionInfo = _$_BolsistaStoreBaseActionController.startAction(
        name: '_BolsistaStoreBase.atualizarBolsista');
    try {
      return super.atualizarBolsista(bolsistaAtualizado);
    } finally {
      _$_BolsistaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bolsistas: ${bolsistas},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
