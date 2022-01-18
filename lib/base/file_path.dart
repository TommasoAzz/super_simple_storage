/// Inteface for implementing a part of a repository or a system that stores data on text files and needs to handle them.
abstract class FilePath {
  /// Returns the path of a file stored with name [name]. Requires to be implemented with another repository interface.
  Future<String> filePath(final String name);
}
