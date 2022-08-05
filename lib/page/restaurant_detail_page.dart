import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurants_result.dart';
import 'package:restaurant_flutter/utils/dimens.dart';
import 'package:restaurant_flutter/utils/image_builder_utils.dart';

class RestaurantDetailPage extends StatefulWidget {
  static String routeName = "/restaurant_detail_page";
  final Restaurant data;

  const RestaurantDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              elevation: 0,
              pinned: true,
              title: Text(widget.data.name),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.data.pictureId,
                  child: Image.network(
                    ApiService.basImageUrlLarge + widget.data.pictureId,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        (loadingProgress == null)
                            ? child
                            : loadingImageProgress(loadingProgress),
                    errorBuilder: (_, __, stackTrace) =>
                        errorImageBuilder(stackTrace),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: spacingSmall),
              Padding(
                padding: const EdgeInsets.all(spacingSmall),
                child: Text(
                  widget.data.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const SizedBox(height: spacingSmall),
              Padding(
                padding: const EdgeInsets.all(spacingSmall),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: spacingTiny),
                      ),
                      TextSpan(
                        text: widget.data.city,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(spacingSmall),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: spacingTiny),
                      ),
                      TextSpan(
                        text: widget.data.rating.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(spacingSmall),
                child: Text(
                  widget.data.description,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(height: spacingSmall),
              // Padding(
              //   padding: const EdgeInsets.all(spacingSmall),
              //   child: Text(
              //     "Menu: Food",
              //     style: Theme.of(context).textTheme.headline5,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(spacingSmall),
              //   child: MediaQuery.removePadding(
              //     context: context,
              //     removeTop: true,
              //     child: ListView.separated(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         final data = widget.data.menus.foods[index];
              //         return _buildListFood(context, data.name);
              //       },
              //       separatorBuilder: (_, __) => const Divider(),
              //       itemCount: widget.data.menus.foods.length,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: spacingSmall),
              // Padding(
              //   padding: const EdgeInsets.all(spacingSmall),
              //   child: Text(
              //     "Menu: Drink",
              //     style: Theme.of(context).textTheme.headline5,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(spacingSmall),
              //   child: MediaQuery.removePadding(
              //     context: context,
              //     removeTop: true,
              //     child: ListView.separated(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         final data = widget.data.menus.drinks[index];
              //         return _buildListFood(context, data.name);
              //       },
              //       separatorBuilder: (_, __) => const Divider(),
              //       itemCount: widget.data.menus.drinks.length,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
