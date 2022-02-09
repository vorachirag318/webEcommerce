import 'package:get/get.dart';
import 'package:producttask/ui/screen/add_product_screen/add_product_screen.dart';
import 'package:producttask/ui/screen/product_screen/product_screen.dart';

final List<GetPage<dynamic>> routes = [
  GetPage(name: ProductScreen.routeName, page: () => const ProductScreen()),
  GetPage(
      name: AddProductScreen.routeName, page: () => const AddProductScreen()),
];
