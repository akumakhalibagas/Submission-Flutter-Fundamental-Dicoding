import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurants_result.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/utils/dimens.dart';
import 'package:restaurant_flutter/utils/image_builder_utils.dart';
import 'package:restaurant_flutter/utils/scroll_behavior.dart';

class RestaurantHome extends StatefulWidget {
  static String routeName = "/restaurant_page";

  const RestaurantHome({Key? key}) : super(key: key);

  @override
  State<RestaurantHome> createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome> {
  late Future<RestaurantsResult> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiService().listRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: FutureBuilder<RestaurantsResult>(
        future: _article,
        builder: (context,AsyncSnapshot<RestaurantsResult> snapshot) {

          debugPrint(snapshot.toString());
          // Check connectivity
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check has data
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Terjadi Kesalahan'),
            );
          }

          return (!isPortrait)
              ? _pageBuilder(context, snapshot.data!.restaurants)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _pageBuilder(context, snapshot.data!.restaurants)
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
                              final data = snapshot.data!.restaurants[index];
                              return _buildListRestaurants(context, data);
                            },
                            separatorBuilder: (_, __) => const Divider(),
                            itemCount: snapshot.data!.restaurants.length,
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

  _pageBuilder(BuildContext context, List<Restaurant> restaurants) =>
      PageView.builder(
        scrollBehavior: CustomScrollBehavior(),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final data = restaurants[index];
          return _buildItemRestaurant(context, data);
        },
      );
}

_buildItemRestaurant(BuildContext context, Restaurant data) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: data);
    },
    child: Stack(
      children: [
        Image.network(
          ApiService.basImageUrlLarge + data.pictureId,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
              (loadingProgress == null)
                  ? child
                  : loadingImageProgress(loadingProgress),
          errorBuilder: (_, __, stackTrace) => errorImageBuilder(stackTrace),
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
                  image: NetworkImage(ApiService.basImageUrlSmall + data.pictureId),
                  errorBuilder: (_, __, stackTrace) => errorImageBuilder(stackTrace),
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
