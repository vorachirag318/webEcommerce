import 'package:get/get.dart';
import 'package:producttask/ui/screen/add_product_screen/controller/add_product_controller.dart';
import 'package:producttask/ui/screen/product_screen/controller/product_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<AddProductController>(() => AddProductController(),
        fenix: true);
  }
}
