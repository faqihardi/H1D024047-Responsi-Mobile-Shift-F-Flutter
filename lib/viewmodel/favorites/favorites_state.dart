import '../../data/models/location_model.dart';

class FavoritesState {
  final List<LocationModel> items;
  const FavoritesState({this.items = const []});

  Set<int> get ids => items.map((e) => e.id).toSet();
  bool contains(int id) => ids.contains(id);
}
