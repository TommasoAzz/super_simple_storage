import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:super_simple_storage/base/file_path.dart';
import 'package:super_simple_storage/base/file_io.dart';
import 'package:super_simple_storage/base/named_data_repository.dart';

/// Repository to store binary files.
abstract class BinaryNamedFileRepository
    with FileIO
    implements NamedDataRepository<Uint8List>, FilePath {
  /// Folder in which to store files.
  String? _fileFolder;

  BinaryNamedFileRepository({
    String? fileFolder,
  }) : _fileFolder = fileFolder;

  /// [name] must specify the extension.
  @override
  Future<void> saveContent(final String name, final Uint8List content) async {
    await _setFileFolder();
    await saveToFile(_fileFolder!, name, content, byteMode: true);
  }

  /// [name] must specify the extension.
  @override
  Future<Uint8List?> content(final String name) async {
    await _setFileFolder();
    final bytes = (await readFromFile(_fileFolder!, name, byteMode: true) as Uint8List);

    if (bytes.isNotEmpty) {
      return bytes;
    }

    return null;
  }

  /// [name] must specify the extension.
  @override
  Future<void> deleteContent(final String name) async {
    await _setFileFolder();
    await deleteFile(_fileFolder!, name);
  }

  @override
  Future<String> filePath(final String name) async {
    await _setFileFolder();
    return "$_fileFolder/$name";
  }

  @protected
  Future<void> _setFileFolder();
}
