import 'package:path/path.dart' as path_lib;
import 'dart:io';

import 'dart:typed_data';

/// Mixin with common functionalities for writing, reading, opening and closing a file.
mixin FileIO {
  /// Creates a reference to a file with the following path: `fileFolder/fileName`.
  /// Then checkes whether the file exists or not. If it does not exist, it gets created.
  Future<File> _openFile(final String fileFolder, final String fileName) async {
    final _file = File(path_lib.join(fileFolder, fileName));

    return !(await _file.exists()) ? await _file.create() : _file;
  }

  /// **SYNCHRONOUS VERSION**
  ///
  /// Creates a reference to a file with the following path: `fileFolder/fileName`.
  /// Then checkes whether the file exists or not. If it does not exist, it gets created.
  File _openFileSync(final String fileFolder, final String fileName) {
    final _file = File(path_lib.join(fileFolder, fileName));

    if (!_file.existsSync()) {
      _file.createSync();
    }

    return _file;
  }

  /// Saves on a file (which path is `fileFolder/fileName`) the content in [fileContent].
  ///
  /// Before writing onto the file checks whether the file exists or not.
  Future<void> saveToFile(
    final String fileFolder,
    final String fileName,
    final dynamic fileContent, {
    final bool append = false,
    final bool byteMode = false,
  }) async {
    final _file = await _openFile(fileFolder, fileName);

    if (byteMode) {
      await _file.writeAsBytes(fileContent as Uint8List);
    } else if (append) {
      await _file.writeAsString(fileContent, mode: FileMode.append);
    } else {
      await _file.writeAsString(fileContent);
    }
  }

  /// **SYNCHRONOUS VERSION**
  ///
  /// Saves on a file (which path is `fileFolder/fileName`) the content in [fileContent].
  ///
  /// Before writing onto the file checks whether the file exists or not.
  void saveToFileSync(
    final String fileFolder,
    final String fileName,
    final dynamic fileContent, {
    final bool append = false,
    final bool byteMode = false,
  }) {
    final _file = _openFileSync(fileFolder, fileName);

    if (byteMode) {
      _file.writeAsBytesSync(fileContent as Uint8List);
    } else if (append) {
      _file.writeAsStringSync(fileContent, mode: FileMode.append);
    } else {
      _file.writeAsStringSync(fileContent);
    }
  }

  /// Reads from a file and returns the content on the form of a `String` or `Uint8List`.
  ///
  /// Before reading, it checks whether the file exists or not.
  Future<dynamic> readFromFile(
    final String fileFolder,
    final String fileName, {
    final bool byteMode = false,
  }) async {
    final _file = await _openFile(fileFolder, fileName);

    return byteMode ? await _file.readAsBytes() : await _file.readAsString();
  }

  /// Reads from a file and returns the content on the form of a `String` or `Uint8List`.
  ///
  /// Before reading, it checks whether the file exists or not.
  dynamic readFromFileSync(
    final String fileFolder,
    final String fileName, {
    final bool byteMode = false,
  }) {
    final _file = _openFileSync(fileFolder, fileName);

    return byteMode ? _file.readAsBytesSync() : _file.readAsStringSync();
  }

  /// Deletes a file.
  ///
  /// Before deleting, it checks whether the file exists or not.
  Future<void> deleteFile(
    final String fileFolder,
    final String fileName,
  ) async {
    final _file = await _openFile(fileFolder, fileName);

    await _file.delete();
  }

  /// **SYNCHRONOUS VERSION**
  ///
  /// Deletes a file.
  ///
  /// Before deleting, it checks whether the file exists or not.
  void deleteFileSync(
    final String fileFolder,
    final String fileName,
  ) {
    final _file = _openFileSync(fileFolder, fileName);

    _file.deleteSync();
  }

  /// Creates a folder named [newFolder] inside the path specified by [path].
  ///
  /// It creates it only if it does not already exist.
  Future<void> createDirectory(final String path, final String newFolder) async {
    final dir = Directory(path_lib.join(path, newFolder));

    if (!(await dir.exists())) {
      await dir.create();
    }
  }

  /// **SYNCHRONOUS VERSION**
  ///
  /// Creates a folder named [newFolder] inside the path specified by [path].
  ///
  /// It creates it only if it does not already exist.
  void createDirectorySync(final String path, final String newFolder) {
    final dir = Directory(path_lib.join(path, newFolder));

    if (!dir.existsSync()) {
      dir.createSync();
    }
  }
}
