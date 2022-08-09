import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';

var data = {
  "id": "rqdv5juczeskfw1e867",
  "name": "Melting Pot",
  "description":
      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
  "pictureId": "14",
  "city": "Medan",
  "rating": 4.2
};
void main() {
  test("Tes Json Parsing", () async {
    var result = Restaurant.fromJson(data).id;

    expect(result, "rqdv5juczeskfw1e867");
  });
}
