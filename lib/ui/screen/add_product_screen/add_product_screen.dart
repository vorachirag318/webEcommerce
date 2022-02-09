import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:producttask/core/constant/app_colors.dart';
import 'package:producttask/core/constant/app_settings.dart';
import 'package:producttask/main.dart';
import 'package:producttask/ui/screen/add_product_screen/controller/add_product_controller.dart';

import '../../../core/utils/app_functions.dart';
import '../../../core/utils/config.dart';
import '../../../core/utils/global.dart';
import '../../shared/app_text_filed.dart';
import '../product_screen/model/product_model.dart';
import 'extensions/add_edit_product_type_extensions.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = "/addProductScreen";
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddProductController addProductController = Get.find<AddProductController>();
  TextEditingController productNameTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController webSiteTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          addProductController.type == AddEditProductType.add
              ? "Add product"
              : "Edit product",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.scaffoldBackgroundColor,
        elevation: 2,
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Form(
            key: formKey,
            child: SizedBox(
              width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
              child: ListView(
                children: [
                  GetBuilder(
                    builder: (AddProductController addProductController) {
                      return GestureDetector(
                        onTap: () async {
                          if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                            await appImagePicker.openBottomSheet();
                            if (appImagePicker.imagePickerController.image !=
                                "") {
                              addProductController.productImage =
                                  appImagePicker.imagePickerController.image;
                              addProductController.imageType = "File";
                              appImagePicker.imagePickerController.resetImage();
                            }
                          } else {
                            addProductController.chooseWebImage();
                          }
                          disposeKeyboard();
                        },
                        child: Container(
                          height: 80,
                          width: SizeConfig.width,
                          child: addProductController.imageType == "network"
                              ? Image.network(
                                  addProductController.productImage.toString(),
                                  fit: BoxFit.cover,
                                )
                              : addProductController.productImage != ""
                                  ? GetPlatform.isIOS || GetPlatform.isAndroid
                                      ? Image.file(
                                          File(addProductController
                                              .productImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.memory(
                                          addProductController.logoBase64!,
                                          fit: BoxFit.cover,
                                        )
                                  : const Center(
                                      child: Text(
                                        "Upload Image",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                          color: addProductController.productImage != ""
                              ? Colors.transparent
                              : Colors.black,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AppTextField(
                      controller: productNameTextController,
                      hintText: "Product Name",
                      validate: (value) =>
                          value!.isEmpty ? "Please enter name" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Launch at",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder(
                          builder: (AddProductController addProductController) {
                            return dateTime(
                              Icons.date_range,
                              context,
                              addProductController.date,
                              () async {
                                disposeKeyboard();
                                DateTime? dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2050)) ??
                                    DateTime.now();
                                addProductController.date =
                                    DateFormat(kDateFormat).format(dateTime);
                                addProductController.dateTime = dateTime;
                              },
                            );
                          },
                        ),
                        SizedBox(
                          width: getWidth(40),
                        ),
                        Expanded(
                          child: AppTextField(
                            controller: priceTextController,
                            keyboardType: TextInputType.number,
                            hintText: "\$ Price",
                            suffixText: "\$",
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validate: (value) =>
                                value!.isEmpty ? "Please enter price" : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AppTextField(
                        controller: webSiteTextController,
                        hintText: "Launch site",
                        validate: (value) {
                          return hasValidUrl(value!);
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder(
                    builder: (AddProductController addProductController) {
                      return Center(
                        child: RatingBar.builder(
                          initialRating: addProductController.popularity,
                          minRating: 0.5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          glow: false,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            addProductController.popularity = rating;
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      disposeKeyboard();
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (addProductController.productImage != "") {
                          addProductController.addAndUpdateProductList(
                              ProductModel(
                                  popularity: addProductController
                                      .popularity
                                      .toString(),
                                  name: productNameTextController.text,
                                  image: addProductController.productImage
                                      .toString(),
                                  price: priceTextController.text,
                                  launchedAt: addProductController.dateTime,
                                  launchSite: webSiteTextController.text,
                                  imageType: addProductController.imageType,
                                  uint8list: addProductController.logoBase64));
                        } else {
                          flutterToast("Please add image");
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: addProductController.type ==
                                  AddEditProductType.add
                              ? const Text(
                                  "Add product",
                                  style: TextStyle(color: Colors.white),
                                )
                              : const Text(
                                  "Update product",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String? hasValidUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter launch site';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid launch site';
    }
    return null;
  }

  dateTime(IconData? icon, BuildContext context, String dateTime,
      void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              const SizedBox(
                width: 9,
              ),
              Icon(
                icon,
                color: Colors.black,
                size: 18,
              ),
              const SizedBox(
                width: 9,
              ),
              Text(dateTime.toString()),
              const SizedBox(
                width: 9,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (Get.arguments == null) {
      addProductController.productModel = ProductModel(
          popularity: "0",
          name: "",
          image: "",
          price: "",
          launchedAt: DateTime.now(),
          launchSite: "",
          imageType: "File");
    } else {
      addProductController.productModel = Get.arguments[0];
    }

    addProductController.productImage = addProductController.productModel.image;
    addProductController.imageType =
        addProductController.productModel.imageType;
    productNameTextController.text = addProductController.productModel.name;
    priceTextController.text = addProductController.productModel.price;
    webSiteTextController.text = addProductController.productModel.launchSite;
    addProductController.date = DateFormat(kDateFormat)
        .format(addProductController.productModel.launchedAt);
    addProductController.dateTime =
        addProductController.productModel.launchedAt;
    addProductController.popularity =
        double.parse(addProductController.productModel.popularity);
    addProductController.logoBase64 =
        addProductController.productModel.uint8list;
    addProductController
        .findIndexUpdateProduct(addProductController.productModel);
    addProductController.type =
        Get.arguments == null ? AddEditProductType.add : Get.arguments[1];
    super.initState();
  }
}
