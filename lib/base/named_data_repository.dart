/// Interface for implementing block-data (whole object) repositories, specifying for each CRUD operation the name of the object involved.
///
/// The implementation of this interface must allow to save a single entire object in a persistence system,
/// retrieving it from the same system and removing it.
abstract class NamedDataRepository<T> {
  /// Stores the object [content] of type `T` inside the predefined (by the implementer) persistent system, storing it with name [name].
  Future<void> saveContent(final String name, final T content);

  /// Reads the content of the whole object stored inside the persistence system with name `name`.
  /// Returns `null` if it cannot read the object.
  Future<T?> content(final String name);

  /// Removes the object with name [name] from the persistence system. It can also unmount the persistence system if it is no longer useful.
  Future<void> deleteContent(final String name);
}
