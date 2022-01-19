import 'dart:convert' show json;

import 'package:meta/meta.dart';
import 'package:super_simple_storage/base/file_io.dart';
import 'package:super_simple_storage/base/named_data_repository.dart';

/// Repository per memorizzare su una cache basata su file di testo lo stato (compatto e completo indifferentemente) di un device.
abstract class JsonNamedFileRepository<T> with FileIO implements NamedDataRepository<T> {
  /// Cartella in cui salvare i file.
  String? _fileFolder;

  final T Function(Map<String, dynamic>) fromJson;

  final Map<String, dynamic> Function(T) toJson;

  JsonNamedFileRepository({
    required this.fromJson,
    required this.toJson,
    String? fileFolder,
  }) : _fileFolder = fileFolder;

  @override
  Future<void> saveContent(final String name, final T content) async {
    await setFileFolder();
    await saveToFile(_fileFolder!, '$name.json', json.encode(toJson(content)));
  }

  @override
  Future<T?> content(final String name) async {
    await setFileFolder();
    final String jsonString = await readFromFile(_fileFolder!, '$name.json');

    if (jsonString.isNotEmpty) {
      return fromJson(json.decode(jsonString));
    }

    return null;
  }

  @override
  Future<void> deleteContent(final String name) async {
    await setFileFolder();
    await deleteFile(_fileFolder!, '$name.json');
  }

  @protected
  Future<void> setFileFolder([final String fileFolder = ""]) async {
    _fileFolder ??= fileFolder;
  }
}
