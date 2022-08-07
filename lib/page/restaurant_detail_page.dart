import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/dimens.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant_details_result.dart';
import 'package:restaurant_flutter/provider/restaurant_details_provider.dart';
import 'package:restaurant_flutter/provider/result_state.dart';
import 'package:restaurant_flutter/utils/scroll_behavior.dart';
import 'package:restaurant_flutter/widgets/image_builder_utils.dart';

class RestaurantDetailPage extends StatefulWidget {
  static String routeName = "/restaurant_detail_page";
  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestaurantDetailsProvider>(
        create: (_) {
          return RestaurantDetailsProvider(
              apiService: ApiService(), idRestaurant: widget.restaurantId);
        },
        child: Consumer<RestaurantDetailsProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      elevation: 0,
                      pinned: true,
                      title: Text(state.result.name),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: state.result.pictureId,
                          child: Image.network(
                            ApiService.baseImageUrlLarge +
                                state.result.pictureId,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : loadingImage(loadingProgress),
                            errorBuilder: (_, __, stackTrace) =>
                                errorImage(stackTrace),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: spacingSmall),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: Text(
                          state.result.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: SizedBox(
                          height: 30.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final data = state.result.categories[index];
                              return Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      end: spacingTiny),
                                  decoration: const BoxDecoration(
                                    borderRadius: radRegular,
                                    color: colorPrimary,
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: spacingTiny,
                                          horizontal: spacingRegular),
                                      child: Text(data.name)));
                            },
                            itemCount: state.result.categories.length,
                          ),
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
                                text: state.result.city,
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
                                text: state.result.rating.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: Text(
                          state.result.description,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      const SizedBox(height: spacingSmall),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: Text(
                          "Reviews",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: SizedBox(
                          height: 40.0,
                          child: PageView.builder(
                            scrollBehavior: CustomScrollBehavior(),
                            controller: PageController(
                              initialPage: 0,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.result.customerReviews.length,
                            itemBuilder: (BuildContext context, int index) {
                              var data = state.result.customerReviews[index];
                              return _itemMoviePagerWidget(data, context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: spacingSmall),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: Text(
                          "Menu: Food",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 10,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final data = state.result.menus.foods[index];
                              return _buildListFood(context, data.name);
                            },
                            itemCount: state.result.menus.foods.length,
                          ),
                        ),
                      ),
                      const SizedBox(height: spacingSmall),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: Text(
                          "Menu: Drink",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 10,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final data = state.result.menus.drinks[index];
                              return _buildListFood(context, data.name);
                            },
                            itemCount: state.result.menus.drinks.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListFood<T>(BuildContext context, String data) =>
      Text('- $data');

  Widget _itemMoviePagerWidget(CustomerReview data, BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(data.name, style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(width: spacingTiny),
              Text('(${data.date})'),
            ],
          ),
          const SizedBox(height: spacingTiny),
          Text(data.review),
        ],
      );
}
