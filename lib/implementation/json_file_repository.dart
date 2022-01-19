import 'dart:convert' show json;

import 'package:meta/meta.dart';
import 'package:super_simple_storage/base/data_repository.dart';
import 'package:super_simple_storage/base/file_io.dart';

/// Repository per memorizzare su una cache basata su file di testo l'identity dell'utente.
abstract class JsonFileRepository<T> with FileIO implements DataRepository<T> {
  /// Cartella in cui salvare i file.
  String? _fileFolder;

  /// Nome del file in cui salvare le informazioni memorizzate al login.
  final String _fileName;

  final T Function(Map<String, dynamic>) fromJson;

  final Map<String, dynamic> Function(T) toJson;

  JsonFileRepository({
    required this.fromJson,
    required this.toJson,
    required String fileName,
    String? fileFolder,
  })  : _fileFolder = fileFolder,
        _fileName = fileName;

  @override
  Future<void> saveContent(T content) async {
    await setFileFolder();
    await saveToFile(_fileFolder!, _fileName, json.encode(toJson(content)));
  }

  @override
  Future<T?> get content async {
    await setFileFolder();
    final String jsonString = await readFromFile(_fileFolder!, _fileName);

    if (jsonString.isNotEmpty) {
      return fromJson(json.decode(jsonString));
    }

    return null;
  }

  @override
  Future<void> deleteContent() async {
    await setFileFolder();
    await deleteFile(_fileFolder!, _fileName);
  }

  @protected
  Future<void> setFileFolder();
}
