import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/dimens.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/data/models/restaurant_details_result.dart';
import 'package:restaurant_flutter/provider/restaurant_details_provider.dart';
import 'package:restaurant_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_flutter/provider/result_state.dart';
import 'package:restaurant_flutter/utils/scroll_behavior.dart';
import 'package:restaurant_flutter/widgets/image_builder_utils.dart';

import '../data/database/db_service.dart';

class RestaurantDetailPage extends StatefulWidget {
  static String routeName = "/restaurant_detail_page";
  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  var favProvider = RestaurantProvider(
    apiService: ApiService(),
    databaseService: DatabaseService(),
  );

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
              var restaurantDetails = state.result;
              var restaurantData = Restaurant(
                id: restaurantDetails.id,
                name: restaurantDetails.name,
                description: restaurantDetails.description,
                pictureId: restaurantDetails.pictureId,
                city: restaurantDetails.city,
                rating: restaurantDetails.rating,
              );
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      elevation: 0,
                      pinned: true,
                      title: Text(restaurantDetails.name),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: restaurantDetails.pictureId,
                          child: Image.network(
                            ApiService.baseImageUrlLarge +
                                restaurantDetails.pictureId,
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
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: spacingSmaller),
                          child:
                              _buildFavoriteIcon(restaurantData, favProvider),
                        ),
                      ],
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
                          restaurantDetails.name,
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
                              final data = restaurantDetails.categories[index];
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
                            itemCount: restaurantDetails.categories.length,
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
                                text: restaurantDetails.city,
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
                                text: restaurantDetails.rating.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: Text(
                          restaurantDetails.description,
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
                          height: 60.0,
                          child: PageView.builder(
                            scrollBehavior: CustomScrollBehavior(),
                            controller: PageController(
                              initialPage: 0,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: restaurantDetails.customerReviews.length,
                            itemBuilder: (BuildContext context, int index) {
                              var data =
                                  restaurantDetails.customerReviews[index];
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
                              final data = restaurantDetails.menus.foods[index];
                              return _buildListFood(context, data.name);
                            },
                            itemCount: restaurantDetails.menus.foods.length,
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
                              final data =
                                  restaurantDetails.menus.drinks[index];
                              return _buildListFood(context, data.name);
                            },
                            itemCount: restaurantDetails.menus.drinks.length,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.reviews_outlined),
        onPressed: () {},
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
          Text(data.review, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      );

  _buildFavoriteIcon(
      Restaurant restaurantData, RestaurantProvider favProvider) {
    debugPrint("Build Fav Icon");
    return ChangeNotifierProvider<RestaurantProvider>(
      create: (_) {
        favProvider.fetchRestaurantFavorites();
        return favProvider;
      },
      child: Consumer<RestaurantProvider>(
        builder: (context, _, __) {
          switch (favProvider.state) {
            case ResultState.loading:
              return const Icon(Icons.favorite_outline, size: 26.0);
            case ResultState.noData:
              return IconButton(
                icon: const Icon(Icons.favorite_outline,
                    size: 26.0, color: Colors.white),
                onPressed: () {
                  favProvider.setFavorites(restaurantData).then(
                    (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil menyimpan")));
                    },
                  );
                },
              );
            case ResultState.hasData:
              return favProvider.favorites
                      .where((element) => element.id == restaurantData.id)
                      .isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.favorite, size: 26.0),
                      color: Colors.red,
                      onPressed: () {
                        favProvider.setFavorites(restaurantData).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Berhasil menghapus")),
                          );
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.favorite_outline,
                          size: 26.0, color: Colors.white),
                      onPressed: () {
                        favProvider.setFavorites(restaurantData).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Berhasil menyimpan")));
                        });
                      },
                    );
            case ResultState.error:
              return const Icon(Icons.favorite_outline, color: Colors.black87);
          }
        },
      ),
    );
  }
}
