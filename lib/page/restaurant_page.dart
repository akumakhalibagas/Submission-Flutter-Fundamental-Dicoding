import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
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
          return PageView.builder(
            itemCount: restaurants.restaurants.length,
            itemBuilder: (context, index) {
              final data = restaurants.restaurants[index];
              return _buildItemRestaurant(context, data);
            },
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
              const SizedBox(height: 10),
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
                    const WidgetSpan(
                      child: SizedBox(
                        width: 5,
                      ),
                    ),
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
              const SizedBox(height: 5),
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
                    const WidgetSpan(
                      child: SizedBox(
                        width: 5,
                      ),
                    ),
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
