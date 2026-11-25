import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/location_model.dart';
import '../../data/repositories/location_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repo) : super(const FavoritesState());
  final LocationRepository _repo;

  void load() => emit(FavoritesState(items: _repo.getFavorites()));

  Future<void> toggle(LocationModel loc) async {
    await _repo.toggleFavorite(loc);
    load();
  }

  Future<void> remove(int id) async {
    await _repo.removeFavorite(id);
    load();
  }
}
