// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';

void main() {
  var data = {
    "id": "rqdv5juczeskfw1e867",
    "name": "Melting Pot",
    "description":
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
    "pictureId": "14",
    "city": "Medan",
    "rating": 4.2
  };
  test("Tes Json Parsing", () async {
    var result = Restaurant.fromJson(data);

    expect(result.id, "rqdv5juczeskfw1e867");
    expect(result.name, "Melting Pot");
    expect(result.description,
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...");
    expect(result.pictureId, "14");
    expect(result.city, "Medan");
    expect(result.rating, 4.2);
  });
}