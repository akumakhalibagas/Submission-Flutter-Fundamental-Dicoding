import 'package:flutter/material.dart';

loadingImageProgress(ImageChunkEvent chunkEvent) => Center(
  child: CircularProgressIndicator(
    value: (chunkEvent.expectedTotalBytes != null)
        ? chunkEvent.cumulativeBytesLoaded / chunkEvent.expectedTotalBytes!
        : null,
  ),
);

errorImageBuilder(StackTrace? stackTrace){
  debugPrintStack(stackTrace: stackTrace);
  return const Center(child: Text("Error mengambil gambar."));
}