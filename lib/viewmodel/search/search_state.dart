import '../../data/models/location_model.dart';

enum SearchStatus { initial, loading, success, empty, error }

class SearchState {
  final SearchStatus status;
  final String query;
  final List<LocationModel> results;
  final List<LocationModel> history;
  final String? message;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.history = const [],
    this.message,
  });
}
