import 'package:flutter/material.dart';

showSnackbar(context, String message) {
  hideBanner(context);

  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Text(message),
      actions: const [SizedBox()],
    ),
  );
}

void hideBanner(context) {
  Future.delayed(const Duration(seconds: 2), () {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  });
}
