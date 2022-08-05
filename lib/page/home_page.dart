import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/page/restaurant_list_page.dart';
import 'package:restaurant_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_flutter/utils/dimens.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
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
                      hintStyle: Theme.of(context).textTheme.bodyText2?.apply(
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
                ChangeNotifierProvider<RestaurantProvider>(
                  create: (_) => RestaurantProvider(apiService: ApiService()),
                  child: const RestaurantListPage(),
                ),
              ],
            ),
          ),
        ),
      );
}
