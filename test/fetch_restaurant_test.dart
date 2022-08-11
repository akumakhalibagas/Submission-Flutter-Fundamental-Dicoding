import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant_details_result.dart';
import 'package:restaurant_flutter/data/models/restaurant_review_result.dart';
import 'package:restaurant_flutter/data/models/restaurant_search_result.dart';
import 'package:restaurant_flutter/data/models/restaurants_result.dart';

import 'fetch_restaurant_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetch list restaurants', () {
    final client = MockClient();
    Uri endpoint = Uri.parse("${ApiService.baseUrl}list");
    test('return a RestaurantsResult when http call complete successfully',
            () async {
          when(client.get(endpoint)).thenAnswer((_) async =>
              http.Response(
                  '{"error": false,"message": "success","count": 20,"restaurants": []}',
                  200));

          expect(await ApiService(client: client).listRestaurants(),
              isA<RestaurantsResult>());
        });

    test('throws an exception if the http call completes with an error',
            () async {
          when(client.get(endpoint))
              .thenAnswer((_) async => http.Response('Not Found', 400));
          expect(ApiService(client: client).listRestaurants(), throwsException);
        });
  });

  group('fetch searched restaurants', () {
    String query = "Makan";

    final client = MockClient();
    Uri endpoint = Uri.parse("${ApiService.baseUrl}search")
        .replace(queryParameters: {'q': query});

    test('return a RestaurantSearchResult when http call complete successfully',
            () async {
          when(client.get(endpoint)).thenAnswer((_) async =>
              http.Response(
                  '{"error":false,"founded":1,"restaurants":[{"id":"fnfn8mytkpmkfw1e867","name":"Makan mudah","description":"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.","pictureId":"22","city":"Medan","rating":3.7}]}',
                  200));

          expect(await ApiService(client: client).searchRestaurants(query),
              isA<RestaurantSearchResult>());
        });

    test('throws an exception if the http call completes with an error',
            () async {
          when(client.get(endpoint))
              .thenAnswer((_) async => http.Response('Not Found', 400));
          expect(
              ApiService(client: client).searchRestaurants(query),
              throwsException);
        });
  });

  group('fetch details restaurants', () {
    final client = MockClient();
    String id = "fnfn8mytkpmkfw1e867";
    Uri endpoint = Uri.parse("${ApiService.baseUrl}detail/$id");
    test(
        'return a RestaurantDetailsResult when http call complete successfully',
            () async {
          when(client.get(endpoint)).thenAnswer((_) async =>
              http.Response(
                  '{"error":false,"message":"success","restaurant":{"id":"fnfn8mytkpmkfw1e867","name":"Makan mudah","description":"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"22","rating":3.7,"categories":[{"name":"Jawa"}],"menus":{"foods":[{"name":"Kari kacang dan telur"},{"name":"Toastie salmon"},{"name":"Matzo farfel"},{"name":"Napolitana"},{"name":"Salad yuzu"},{"name":"Sosis squash dan mint"},{"name":"Daging Sapi"}],"drinks":[{"name":"Minuman soda"},{"name":"Jus apel"},{"name":"Air"},{"name":"Jus jeruk"},{"name":"Es krim"},{"name":"Es teh"},{"name":"Jus tomat"},{"name":"Coklat panas"}]},"customerReviews":[{"name":"Gilang","review":"Harganya murah sekali!","date":"14 Agustus 2018"},{"name":"Thomas Shelby","review":"Resto disini sangat nyaman dan enak, cocok untuk kawan kawan yang ingin menjadi cowok cool.","date":"11 Agustus 2022"},{"name":"Thomas Shelby","review":"Resto disini sangat nyaman dan enak, cocok untuk kawan kawan yang ingin menjadi cowok cool.","date":"11 Agustus 2022"}]}}',
                  200));

          expect(await ApiService(client: client).detailsRestaurant(id),
              isA<RestaurantDetailsResult>());
        });

    test('throws an exception if the http call completes with an error',
            () async {
          when(client.get(endpoint))
              .thenAnswer((_) async => http.Response('Not Found', 400));
          expect(ApiService(client: client).detailsRestaurant(id),
              throwsException);
        });
  });

  group('post reviews', () {
    final client = MockClient();
    String id = "fnfn8mytkpmkfw1e867";
    String name = "Fakhry Mubarak";
    String review = "Makan ngab";
    final Map<String, String> headers = { "Content-Type": "application/json"};
    final Map<String, String> body = {
      "id": id,
      "name": name,
      "review": review,
    };

    Uri endpoint = Uri.parse("${ApiService.baseUrl}review");
    test(
        'return a RestaurantReviewResult when http call complete successfully',
            () async {
          when(client.post(endpoint,
            headers: headers,
            body: json.encode(body),
          )).thenAnswer((_) async =>
              http.Response(
                  '{"error":false,"message":"success","customerReviews":[{"name":"Gilang","review":"Harganya murah sekali!","date":"14 Agustus 2018"},{"name":"Thomas Shelby","review":"Resto disini sangat nyaman dan enak, cocok untuk kawan kawan yang ingin menjadi cowok cool.","date":"11 Agustus 2022"},{"name":"Thomas Shelby","review":"Resto disini sangat nyaman dan enak, cocok untuk kawan kawan yang ingin menjadi cowok cool.","date":"11 Agustus 2022"},{"name":"Thomas Shelby","review":"Resto disini sangat nyaman dan enak, cocok untuk kawan kawan yang ingin menjadi cowok cool.","date":"11 Agustus 2022"}]}',
                  201));

          expect(
              await ApiService(client: client).reviewRestaurant(
                  id, name, review),
              isA<RestaurantReviewResult>());
        });

    test('throws an exception if the http call completes with an error',
            () async {
          when(client.post(endpoint,
            headers: headers,
            body: json.encode(body),
          )).thenAnswer((_) async =>
              http.Response('Not Found', 400));
          expect(
              ApiService(client: client).reviewRestaurant(id, name, review),
              throwsException);
        });
  });
}
