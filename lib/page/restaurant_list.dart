import 'package:flutter/material.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import '../data/models/restaurant.dart';
import '../utils/dimens.dart';
import '../utils/image_builder_utils.dart';

class RestaurantList extends StatelessWidget {
  final Restaurant data;
  const RestaurantList({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildListRestaurants(context, data);
  }
}

_buildListRestaurants(BuildContext context, Restaurant data) => InkWell(
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: data);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: radSmall,
              child: Hero(
                tag: data.pictureId,
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://restaurant-api.dicoding.dev/images/small/${data.pictureId}",
                  ),
                  errorBuilder: (_, __, stackTrace) =>
                      errorImageBuilder(stackTrace),
                  loadingBuilder:
                      (_, Widget child, ImageChunkEvent? chunkEvent) =>
                          (chunkEvent == null)
                              ? child
                              : loadingImageProgress(chunkEvent),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: spacingSmaller),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: Theme.of(context).textTheme.headline6),
                  Text(data.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ),
          )
        ],
      ),
    );
