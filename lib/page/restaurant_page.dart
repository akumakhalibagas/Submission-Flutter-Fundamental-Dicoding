import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurants_result.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/utils/dimens.dart';
import 'package:restaurant_flutter/utils/image_builder_utils.dart';

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
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: FutureBuilder<RestaurantsResult>(
            future: _article,
            builder: (context, AsyncSnapshot<RestaurantsResult> snapshot) {
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

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: spacingSmaller,
                        horizontal: spacingRegular,
                      ),
                      child: TextFormField(
                        onChanged: (query) {
                          // @todo search based query
                        },
                        decoration: InputDecoration(
                          hintStyle:
                              Theme.of(context).textTheme.bodyText2?.apply(
                                    color: colorGray,
                                  ),
                          hintText: "Cari restaurant yang kamu mau...",
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(
                            Icons.search,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.restaurants[index];
                        return _buildListRestaurants(context, data);
                      },
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemCount: snapshot.data!.restaurants.length,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

_buildListRestaurants(BuildContext context, Restaurant data) => InkWell(
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: data);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: spacingSmaller, horizontal: spacingRegular),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: radSmall,
                child: Hero(
                  tag: data.pictureId,
                  child: Image.network(
                    ApiService.basImageUrlSmall + data.pictureId,
                    fit: BoxFit.cover,
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
                    Text(data.name,
                        style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: spacingTiny),
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
      ),
    );
