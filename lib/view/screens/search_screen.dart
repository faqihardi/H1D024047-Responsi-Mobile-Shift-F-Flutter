import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/models/location_model.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/location_repository.dart';
import '../../viewmodel/favorites/favorites_cubit.dart';
import '../../viewmodel/favorites/favorites_state.dart';
import '../../viewmodel/search/search_cubit.dart';
import '../../viewmodel/search/search_state.dart';
import '../../viewmodel/weather/weather_cubit.dart';
import '../widgets/common_widgets.dart';
import '../widgets/location_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late final SearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SearchCubit(context.read<LocationRepository>());
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Cari Lokasi')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (v) {
                        setState(() {}); // refresh tombol clear
                        _cubit.onQueryChanged(v);
                      },
                      decoration: AppInput.search(
                        suffix: _controller.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  _controller.clear();
                                  _cubit.clear();
                                  setState(() {});
                                },
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        if (state.status == SearchStatus.loading) {
                          return const LoadingView(label: 'Mencari kota...');
                        }

                        if (state.status == SearchStatus.error) {
                          return ErrorView(
                            message: state.message ?? 'Pencarian gagal.',
                            onRetry: _cubit.retry,
                          );
                        }

                        if (state.status == SearchStatus.empty) {
                          return const EmptyView(
                            icon: Icons.search_off_rounded,
                            title: 'Kota Tidak Ditemukan',
                            subtitle: 'Periksa ejaan atau coba nama kota lain.',
                          );
                        }

                        if (state.status == SearchStatus.initial) {
                          if (state.history.isEmpty) {
                            return const EmptyView(
                              icon: Icons.search_rounded,
                              title: 'Mulai Pencarian',
                              subtitle: 'Ketik minimal 2 huruf. Hasil diambil langsung dari Geocoding API Open-Meteo.',
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  12,
                                  20,
                                  4,
                                ),
                                child: SectionTitle(
                                  'Pencarian Terakhir',
                                  trailing: TextButton(
                                    onPressed: _cubit.clearHistory,
                                    child: const Text('Hapus'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _LocationList(items: state.history),
                              ),
                            ],
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionTitle('${state.results.length} Hasil'),
                              const SizedBox(height: 4),
                              Expanded(
                                child: _LocationList(items: state.results),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationList extends StatelessWidget {
  final List<LocationModel> items;
  const _LocationList({required this.items});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, fav) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        itemCount: items.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, thickness: 1, color: AppColors.border),
        itemBuilder: (context, i) {
          final loc = items[i];
          return LocationTile(
            location: loc,
            isFavorite: fav.contains(loc.id),
            onTap: () {
              context.read<WeatherCubit>().load(loc);
              Navigator.of(context).pop();
            },
            onFavorite: () => context.read<FavoritesCubit>().toggle(loc),
          );
        },
      ),
    );
  }
}
