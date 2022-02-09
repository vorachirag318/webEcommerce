import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producttask/core/constant/app_theme.dart';
import 'package:producttask/core/utils/bindings.dart';
import 'package:producttask/core/utils/routes.dart';
import 'package:producttask/ui/screen/product_screen/product_screen.dart';
import 'package:producttask/ui/shared/image_picker_controller.dart';

late AppImagePicker appImagePicker;
void main() {
  appImagePicker = AppImagePicker();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ProductTask",
      initialBinding: BaseBinding(),
      debugShowCheckedModeBanner: false,
      initialRoute: ProductScreen.routeName,
      getPages: routes,
      theme: AppTheme.defTheme,
    );
  }
}
