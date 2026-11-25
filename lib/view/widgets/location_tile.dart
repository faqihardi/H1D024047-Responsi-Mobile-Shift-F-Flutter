import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/location_model.dart';

class LocationTile extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const LocationTile({
    super.key,
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.faint,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location.name, style: t.titleSmall),
                  if (location.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      location.subtitle,
                      style: t.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: onFavorite,
              tooltip: isFavorite ? 'Hapus favorit' : 'Simpan favorit',
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                size: 22,
                color: isFavorite ? AppColors.accent : AppColors.faint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
