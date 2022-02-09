import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:producttask/core/constant/app_json.dart';
import 'package:producttask/core/constant/app_settings.dart';
import 'package:producttask/core/utils/app_functions.dart';
import 'package:producttask/ui/screen/product_screen/model/product_model.dart';

class ProductController extends GetxController {
  List<ProductModel> _productList = [];

  List<ProductModel> get productList => _productList;

  set productList(List<ProductModel> value) {
    _productList = value;
    update();
  }

  void loadProductJsonFile() async {
    var jsonText = await rootBundle.loadString(AppJson.product);
    var data = json.decode(jsonText);
    data['slots'].forEach((element) {
      productList.add(ProductModel.fromJson(element));
      update();
    });
  }

  removeProduct(ProductModel productModel) {
    productList.remove(productModel);
    update();
    flutterToast("Product deleted successfully.");
  }

  String _showPattern = kGridView;

  String get showPattern => _showPattern;

  set showPattern(String value) {
    _showPattern = value;
    update();
  }

  String? _selectedSort;

  String? get selectedSort => _selectedSort;

  set selectedSort(String? value) {
    _selectedSort = value;
    update();
  }

  List<ProductModel> get productSortList {
    if (selectedSort != null) {
      if (sortList[0] == selectedSort) {
        productList.sort(
            (a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
      } else if (sortList[1] == selectedSort) {
        productList.sort(
            (a, b) => b.name.toUpperCase().compareTo(a.name.toUpperCase()));
      } else if (sortList[2] == selectedSort) {
        productList.sort(
            (a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
      } else if (sortList[3] == selectedSort) {
        productList.sort(
            (a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
      } else if (sortList[4] == selectedSort) {
        productList.sort((a, b) => b.launchedAt.compareTo(a.launchedAt));
      } else if (sortList[5] == selectedSort) {
        productList.sort((a, b) => a.launchedAt.compareTo(b.launchedAt));
      } else if (sortList[6] == selectedSort) {
        productList.sort((a, b) =>
            double.parse(b.popularity).compareTo(double.parse(a.popularity)));
      } else if (sortList[7] == selectedSort) {
        productList.sort((a, b) =>
            double.parse(a.popularity).compareTo(double.parse(b.popularity)));
      }

      return productList;
    }
    return productList;
  }

  List<String> sortList = [
    "Product name - A - Z",
    "Product name - Z - A",
    "Price - high to low",
    "Price - low to high",
    "Date - latest",
    "Date - oldest",
    "Popularity - high to low",
    "Popularity - low to high",
  ];
}
