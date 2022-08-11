import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/dimens.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/provider/restaurant_review_provider.dart';
import 'package:restaurant_flutter/provider/result_state.dart';

class BottomSheetReview extends StatefulWidget {
  final String id;

  const BottomSheetReview({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BottomSheetReview> createState() => _BottomSheetReviewState();
}

class _BottomSheetReviewState extends State<BottomSheetReview> {
  String _name = "";
  String _review = "";

  void _setName(String name) {
    setState(() {
      _name = name;
    });
  }

  void _setReview(String review) {
    setState(() {
      _review = review;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(spacingRegular),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 10.0,
                  width: 100.0,
                  decoration: const BoxDecoration(
                    borderRadius: radRegular,
                    color: colorGray2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingRegular),
            Text('Nama', style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: spacingSmaller),
            TextFormField(
              autofocus: true,
              onChanged: (value) {
                _setName(value);
              },
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.bodyText2?.apply(
                      color: colorGray,
                    ),
                hintText: "Masukkan nama kamu",
                border: const OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: spacingRegular),
            Text('Review', style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: spacingSmaller),
            TextFormField(
              minLines: 3,
              maxLines: 5,
              onChanged: (value) {
                _setReview(value);
              },
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.bodyText2?.apply(
                      color: colorGray,
                    ),
                hintText: "Masukkan review kamu",
                border: const OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: spacingRegular),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChangeNotifierProvider<RestaurantReviewProvider>(
                  create: (_) {
                    return RestaurantReviewProvider(apiService: ApiService());
                  },
                  child: Consumer<RestaurantReviewProvider>(
                    builder: (context, provider, __) {
                      switch (provider.state) {
                        case ResultState.loading:
                          return _elevatedButtonSubmit(provider, true);
                        case ResultState.noData:
                          return _elevatedButtonSubmit(provider, false);
                        case ResultState.hasData:
                          Navigator.pop(context);
                          return _elevatedButtonSubmit(provider, false);
                        case ResultState.error:
                          return _elevatedButtonSubmit(provider, false);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _elevatedButtonSubmit(
          RestaurantReviewProvider provider, bool isLoading) =>
      Expanded(
        child: ElevatedButton(
          child: isLoading
              ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : const Text('Submit Review'),
          onPressed: () {
            debugPrint(_name);
            debugPrint(_review);
            if(provider.isReviewFormValid(_name, _review)){
              FocusManager.instance.primaryFocus?.unfocus();
              provider.postReview(widget.id, _name, _review);
            } else {
              Fluttertoast.showToast(
                  msg: provider.message,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: colorBlackTransparent50,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
        ),
      );
}
