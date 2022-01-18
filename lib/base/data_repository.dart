/// Interface for implementing block-data (whole object) repositories.
///
/// The implementation of this interface must allow to save a single entire object in a persistence system,
/// retrieving it from the same system and removing it.
abstract class DataRepository<T> {
  /// Stores the object [content] of type `T` inside the predefined (by the implementer) persistent system.
  Future<void> saveContent(final T content);

  /// Reads the content of the whole object stored inside the persistence system.
  /// Returns `null` if it cannot read the object.
  Future<T?> get content;

  /// Removes the object from the persistence system. It can also unmount the persistence system if it is no longer useful.
  Future<void> deleteContent();
}
