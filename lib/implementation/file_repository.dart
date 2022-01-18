import 'dart:typed_data';

import 'package:super_simple_storage/base/file_path.dart';
import 'package:super_simple_storage/base/file_io.dart';
import 'package:super_simple_storage/base/named_data_repository.dart';
import 'package:path_provider/path_provider.dart' as path;

/// Repository to store binary files.
class FileRepository with FileIO implements NamedDataRepository<Uint8List>, FilePath {
  /// Folder in which to store files.
  String? _fileFolder;

  FileRepository({
    String? fileFolder,
  }) : _fileFolder = fileFolder;

  /// [name] must specify the extension.
  @override
  Future<void> saveNamedContent(final String name, final Uint8List content) async {
    await _setFileFolder();
    await saveToFile(_fileFolder!, name, content, byteMode: true);
  }

  /// [name] must specify the extension.
  @override
  Future<Uint8List?> getNamedContent(final String name) async {
    await _setFileFolder();
    final bytes = (await readFromFile(_fileFolder!, name, byteMode: true) as Uint8List);

    if (bytes.isNotEmpty) {
      return bytes;
    }

    return null;
  }

  /// [name] must specify the extension.
  @override
  Future<void> deleteNamedContent(final String name) async {
    await _setFileFolder();
    await deleteFile(_fileFolder!, name);
  }

  @override
  Future<String> filePath(final String name) async {
    await _setFileFolder();
    return "$_fileFolder/$name";
  }

  /// Se la cartella in cui memorizzare i file come il sinottico e il datasheet non è ancora settata,
  /// allora va settata impostando le directory di sistema per i file delle applicazioni,
  /// tramite il metodo getApplicationSupportDirectory() della libreria path_provider.
  ///
  /// Questa scelta è stata fatta poiché per i test getApplicationSupportDirectory() non funziona,
  /// in quanto supporta solo Android e iOS. Quindi nei test c'è la necessità di inserire il nome della
  /// cartella, in casi invece di utilizzo in app non è necessario.
  Future<void> _setFileFolder() async {
    _fileFolder ??= (await path.getApplicationSupportDirectory()).path;
  }
}
