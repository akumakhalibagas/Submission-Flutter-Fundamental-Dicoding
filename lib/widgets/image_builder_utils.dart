import 'package:flutter/material.dart';

Widget loadingImage(ImageChunkEvent chunkEvent) => Center(
  child: CircularProgressIndicator(
    value: (chunkEvent.expectedTotalBytes != null)
        ? chunkEvent.cumulativeBytesLoaded / chunkEvent.expectedTotalBytes!
        : null,
  ),
);

Widget errorImage(StackTrace? stackTrace){
  debugPrintStack(stackTrace: stackTrace);
  return const Center(child: Text("Error mengambil gambar."));
}