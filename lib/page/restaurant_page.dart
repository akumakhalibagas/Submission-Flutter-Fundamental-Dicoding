import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/utils/dimens.dart';
import 'package:restaurant_flutter/utils/image_builder_utils.dart';
import 'package:restaurant_flutter/utils/styles.dart';

class RestaurantHome extends StatefulWidget {
  static String routeName = "/restaurant_page";

  const RestaurantHome({Key? key}) : super(key: key);

  @override
  State<RestaurantHome> createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome> {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: FutureBuilder<String>(
        future:
            DefaultAssetBundle.of(context).loadString('assets/restaurant.json'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Terjadi Kesalahan'),
            );
          }
          final restaurants = restaurantResponseFromJson(snapshot.data!);
          return (!isPortrait)
              ? PageView.builder(
                  itemCount: restaurants.restaurants.length,
                  itemBuilder: (context, index) {
                    final data = restaurants.restaurants[index];
                    return _buildItemRestaurant(context, data);
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: PageView.builder(
                          itemCount: restaurants.restaurants.length,
                          itemBuilder: (context, index) {
                            final data = restaurants.restaurants[index];
                            return _buildItemRestaurant(context, data);
                          },
                        ),
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: Container(
                          padding: const EdgeInsets.all(spacingSmall),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = restaurants.restaurants[index];
                              return _buildListRestaurants(context, data);
                            },
                            separatorBuilder: (_, __) => const Divider(),
                            itemCount: restaurants.restaurants.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

_buildItemRestaurant(BuildContext context, Restaurant data) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: data);
    },
    child: Stack(
      children: [
        Hero(
          tag: data.pictureId,
          child: Image.network(
            data.pictureId,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) =>
                (loadingProgress == null)
                    ? child
                    : loadingImageProgress(loadingProgress),
            errorBuilder: (_, __, stackTrace) => errorImageBuilder(stackTrace),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.apply(color: colorWhite),
              ),
              const SizedBox(height: spacingSmaller),
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const WidgetSpan(child: SizedBox(width: spacingTiny)),
                    TextSpan(
                      text: data.city,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.apply(color: colorWhite),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: spacingTiny),
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const WidgetSpan(child: SizedBox(width: spacingTiny)),
                    TextSpan(
                      text: data.rating.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.apply(color: colorWhite),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
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
                  image: NetworkImage(data.pictureId),
                  errorBuilder: (_, __, ___) =>
                      const Text('Failed load image.'),
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
