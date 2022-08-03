import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';

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
                    widget.data.pictureId,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.data.name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(10),
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
                      child: SizedBox(
                        width: 5,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.city,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 5,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.rating.toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.data.description,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
