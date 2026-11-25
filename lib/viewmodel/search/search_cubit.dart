import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/app_failure.dart';
import '../../data/repositories/location_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repo) : super(const SearchState()) {
    loadHistory();
  }

  final LocationRepository _repo;
  Timer? _debounce;
  int _requestId = 0; // abaikan respons request lama

  void loadHistory() {
    emit(
      SearchState(
        status: SearchStatus.initial,
        query: state.query,
        history: _repo.getHistory(),
      ),
    );
  }

  void onQueryChanged(String raw) {
    _debounce?.cancel();
    final q = raw.trim();

    if (q.length < 2) {
      _requestId++;
      emit(SearchState(history: _repo.getHistory(), query: q));
      return;
    }

    emit(
      SearchState(
        query: q,
        status: SearchStatus.loading,
        history: state.history,
      ),
    );
    _debounce = Timer(const Duration(milliseconds: 450), () => _search(q));
  }

  Future<void> _search(String q) async {
    final id = ++_requestId;
    try {
      final results = await _repo.search(q);
      if (isClosed || id != _requestId) return;
      emit(
        SearchState(
          query: q,
          status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
          results: results,
          history: state.history,
        ),
      );
    } on AppFailure catch (e) {
      if (isClosed || id != _requestId) return;
      emit(
        SearchState(
          query: q,
          status: SearchStatus.error,
          message: e.message,
          history: state.history,
        ),
      );
    }
  }

  void retry() => onQueryChanged(state.query);

  void clear() {
    _debounce?.cancel();
    _requestId++;
    emit(SearchState(history: _repo.getHistory()));
  }

  Future<void> clearHistory() async {
    await _repo.clearHistory();
    loadHistory();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
