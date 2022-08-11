import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/dimens.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/provider/restaurant_provider.dart';

import 'image_builder_utils.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant data;
  final RestaurantProvider provider;

  const CardRestaurant({Key? key, required this.data, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: radSmall,
              child: Hero(
                tag: data.pictureId,
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Image.network(
                    ApiService.baseImageUrlSmall + data.pictureId,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, stackTrace) => errorImage(stackTrace),
                    loadingBuilder: (_, Widget child,
                            ImageChunkEvent? chunkEvent) =>
                        (chunkEvent == null) ? child : loadingImage(chunkEvent),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          data.name,
        ),
        subtitle: Text(
          data.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),

        onTap: () => Navigator.pushNamed(
          context,
          RestaurantDetailPage.routeName,
          arguments: data.id,
        ).then((value) {
          provider.fetchRestaurantFavorites();
          provider.fetchListRestaurants();
        }),
      ),
    );
  }
}
