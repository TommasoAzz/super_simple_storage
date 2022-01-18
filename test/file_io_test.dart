import 'dart:io';

import 'package:super_simple_storage/base/file_io.dart';
import 'package:test/test.dart';

class TestClass with FileIO {}

void main() {
  late TestClass _tester;

  const String fileFolder = "./";
  const String fileName = "testfile.txt";
  const String fileContent = "This is a test.";
  const String directoryName = "newfoldertest";

  setUp(() {
    _tester = TestClass();
  });

  group("Asynchronous tests", () {
    test("Test file opening, writing and reading (in this order)", () async {
      await _tester.saveToFile(fileFolder, fileName, fileContent);

      final readString = await _tester.readFromFile(fileFolder, fileName);

      expect(readString, "This is a test.");
    });

    test("Test file opening, writing, writing in append mode and reading (in this order)",
        () async {
      await _tester.saveToFile(fileFolder, fileName, fileContent);

      await _tester.saveToFile(fileFolder, fileName, fileContent, append: true);

      final readString = await _tester.readFromFile(fileFolder, fileName);

      expect(readString, "This is a test.This is a test.");
    });

    test("Test file opening, reading and finding nothing (in this order)", () async {
      final readString = await _tester.readFromFile(fileFolder, fileName);

      expect(readString, "");
    });

    test("Test file opening, deleting it and then not finding it anymore (in this order)",
        () async {
      await _tester.deleteFile(fileFolder, fileName);
      expect(await File('$fileFolder/$fileName').exists(), false);
    });

    test("Test directory creation", () async {
      expect(await Directory('$fileFolder/$directoryName').exists(), false);
      await _tester.createDirectory(fileFolder, directoryName);
      expect(await Directory('$fileFolder/$directoryName').exists(), true);
    });
  });

  group("Synchronous tests", () {
    test("Test file opening, writing and reading (in this order)", () {
      _tester.saveToFileSync(fileFolder, fileName, fileContent);

      final readString = _tester.readFromFileSync(fileFolder, fileName);

      expect(readString, "This is a test.");
    });

    test("Test file opening, writing, writing in append mode and reading (in this order)", () {
      _tester.saveToFileSync(fileFolder, fileName, fileContent);

      _tester.saveToFileSync(fileFolder, fileName, fileContent, append: true);

      final readString = _tester.readFromFileSync(fileFolder, fileName);

      expect(readString, "This is a test.This is a test.");
    });

    test("Test file opening, reading and finding nothing (in this order)", () {
      final readString = _tester.readFromFileSync(fileFolder, fileName);

      expect(readString, "");
    });

    test("Test file opening, deleting it and then not finding it anymore (in this order)", () {
      _tester.deleteFileSync(fileFolder, fileName);
      expect(File('$fileFolder/$fileName').existsSync(), false);
    });

    test("Test directory creation", () {
      expect(Directory('$fileFolder/$directoryName').existsSync(), false);
      _tester.createDirectorySync(fileFolder, directoryName);
      expect(Directory('$fileFolder/$directoryName').existsSync(), true);
    });
  });

  tearDown(() async {
    final f = File('$fileFolder/$fileName');
    final d = Directory('$fileFolder/$directoryName');
    if (await f.exists()) await f.delete();
    if (await d.exists()) await d.delete();
  });
}
