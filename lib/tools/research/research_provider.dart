/// Abstraction for ETHER's research information source.
///
/// Implementations may use local data, cached data, APIs, or other
/// external information providers.
abstract class ResearchProvider {
  String get name;

  /// Returns research information for [query].
  Future<String> research(String query);
}
