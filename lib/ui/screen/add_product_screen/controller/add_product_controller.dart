import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:producttask/core/constant/app_settings.dart';
import 'package:producttask/core/utils/app_functions.dart';
import 'package:producttask/ui/screen/add_product_screen/extensions/add_edit_product_type_extensions.dart';
import 'package:producttask/ui/screen/product_screen/controller/product_controller.dart';
import 'package:producttask/ui/screen/product_screen/model/product_model.dart';

class AddProductController extends GetxController {
  ProductController productController = Get.find<ProductController>();
  String? _productImage;

  String? get productImage => _productImage;

  set productImage(String? value) {
    _productImage = value;
    update();
  }

  late ProductModel _productModel;

  ProductModel get productModel => _productModel;

  set productModel(ProductModel value) {
    _productModel = value;
    update();
  }

  Uint8List? _logoBase64;

  Uint8List? get logoBase64 => _logoBase64;

  set logoBase64(Uint8List? value) {
    _logoBase64 = value;
    update();
  }

  FilePickerResult? pickedFile;

  void chooseWebImage() async {
    pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      logoBase64 = pickedFile!.files.first.bytes;
      productImage = logoBase64.toString();
      imageType = "File";
    }
  }

  String _imageType = "network";

  String get imageType => _imageType;

  set imageType(String value) {
    _imageType = value;
    update();
  }

  DateTime _dateTime = DateTime.now();

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    _dateTime = value;
    update();
  }

  String _date = DateFormat(kDateFormat).format(DateTime.now());
  String get date => _date;
  set date(String value) {
    _date = value;
    update();
  }

  addAndUpdateProductList(ProductModel productModel) {
    if (type == AddEditProductType.add) {
      bool duplicateName = false;
      for (int i = 0; i < productController.productList.length; i++) {
        if (productController.productList[i].name == productModel.name) {
          duplicateName = true;
          break;
        }
      }
      if (duplicateName) {
        flutterToast("Product already exists.");
      } else {
        productController.productList.insert(0, productModel);
        productController.update();
        Get.back();
      }
    } else {
      productController.productSortList[updateProductIndex] = productModel;
      productController.update();
      Get.back();
    }
  }

  int _updateProductIndex = 0;
  int get updateProductIndex => _updateProductIndex;
  set updateProductIndex(int value) {
    _updateProductIndex = value;
    update();
  }

  findIndexUpdateProduct(ProductModel productModel) {
    updateProductIndex = productController.productSortList
        .indexWhere((element) => element.name == productModel.name);
  }

  AddEditProductType _type = AddEditProductType.add;

  AddEditProductType get type => _type;

  set type(AddEditProductType value) {
    _type = value;
    update();
  }

  double _popularity = 0.5;

  double get popularity => _popularity;

  set popularity(double value) {
    _popularity = value;
    update();
  }
}
