import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:producttask/core/constant/app_colors.dart';
import 'package:producttask/core/constant/app_settings.dart';
import 'package:producttask/core/utils/config.dart';
import 'package:producttask/ui/screen/add_product_screen/add_product_screen.dart';
import 'package:producttask/ui/screen/add_product_screen/extensions/add_edit_product_type_extensions.dart';
import 'package:producttask/ui/screen/product_screen/controller/product_controller.dart';
import 'package:producttask/ui/screen/product_screen/model/product_model.dart';
import 'package:producttask/ui/screen/product_screen/widget/custom_radio_button.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = "/productScreen";
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductController productController = Get.find<ProductController>();
  @override
  void initState() {
    productController.loadProductJsonFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Products",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                AddProductScreen.routeName,
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
          )
        ],
        backgroundColor: AppColors.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return productList(crossAxisCount: 2, childAspectRatio: .65);
          } else if (constraints.maxWidth < 700) {
            return productList(crossAxisCount: 3, childAspectRatio: .63);
          } else if (constraints.maxWidth < 800) {
            return productList(crossAxisCount: 3, childAspectRatio: .73);
          } else if (constraints.maxWidth < 1200) {
            return productList(crossAxisCount: 4, childAspectRatio: .73);
          } else if (constraints.maxWidth < 1600) {
            return productList(crossAxisCount: 6, childAspectRatio: .73);
          } else if (constraints.maxWidth < 2000) {
            return productList(crossAxisCount: 8, childAspectRatio: .73);
          } else {
            return productList(crossAxisCount: 10, childAspectRatio: .73);
          }
        },
      ),
    );
  }

  productList({double childAspectRatio = 1.0, required int crossAxisCount}) {
    return GetBuilder(
      builder: (ProductController productController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (productController.showPattern == kGridView) {
                      productController.showPattern = kListView;
                    } else {
                      productController.showPattern = kGridView;
                    }
                  },
                  icon: productController.showPattern == kGridView
                      ? const Icon(Icons.list)
                      : const Icon(Icons.grid_view),
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    items: [
                      DropdownMenuItem(
                        value: "",
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black.withOpacity(0.50)))),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text(
                            "Sort By",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      ...productController.sortList
                          .map(
                            (sort) => DropdownMenuItem<String>(
                              value: sort,
                              child: Container(
                                height: 40,
                                color: Colors.transparent,
                                child: CustomRadioButton(
                                  sort: sort,
                                ),
                              ),
                            ),
                          )
                          .toList()
                    ],
                    customButton: const Icon(Icons.sort),
                    value: productController.selectedSort,
                    onChanged: (value) {
                      productController.selectedSort = value.toString();
                    },
                    itemHeight: 45,
                    itemWidth: 240,
                    dropdownPadding: const EdgeInsets.only(top: 5, bottom: 10),
                    itemPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
              child: productController.showPattern == kGridView
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        itemCount: productController.productSortList.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: childAspectRatio,
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30),
                        itemBuilder: (context, index) {
                          return gridProductBox(
                              productController.productSortList[index]);
                        },
                      ),
                    )
                  : ListView.builder(
                      itemCount: productController.productSortList.length,
                      itemBuilder: (context, index) {
                        return listProductBox(
                          productController.productSortList[index],
                        );
                      },
                    ),
            )
          ],
        );
      },
    );
  }

  listProductBox(ProductModel productModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productModel.imageType == "network"
                  ? listViewProductImage(
                      DecorationImage(
                        image: NetworkImage(productModel.image),
                      ),
                    )
                  : GetPlatform.isAndroid || GetPlatform.isIOS
                      ? listViewProductImage(DecorationImage(
                          image: FileImage(
                            File(productModel.image),
                          ),
                        ))
                      : listViewProductImage(
                          DecorationImage(
                            image: MemoryImage(
                              productModel.uint8list!,
                            ),
                          ),
                        ),
              const SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 140,
                    child: productTitle(productModel),
                  ),
                  priceProduct(productModel),
                  const SizedBox(
                    height: 10,
                  ),
                  productRate(productModel),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    removeProductButton(productModel),
                    const SizedBox(
                      height: 30,
                    ),
                    editProductButton(productModel)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  listViewProductImage(DecorationImage? image) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(image: image),
    );
  }

  gridProductBox(ProductModel productModel) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Spacer(),
                removeProductButton(productModel),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            productModel.imageType == "network"
                ? gridViewProductImage(
                    image: DecorationImage(
                      image: NetworkImage(productModel.image),
                    ),
                  )
                : GetPlatform.isAndroid || GetPlatform.isIOS
                    ? gridViewProductImage(
                        image: DecorationImage(
                          image: FileImage(
                            File(productModel.image),
                          ),
                        ),
                      )
                    : gridViewProductImage(
                        image: DecorationImage(
                          image: MemoryImage(productModel.uint8list!),
                        ),
                      ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: productTitle(productModel),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: priceProduct(productModel),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: productRate(productModel),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: editProductButton(productModel),
              ),
            ),
            const SizedBox(
              height: 3,
            )
          ],
        ),
      ),
    );
  }

  gridViewProductImage({DecorationImage? image}) {
    return Center(
      child: Container(
        height: 100,
        width: 180,
        decoration: BoxDecoration(image: image),
      ),
    );
  }

  startProduct(ProductModel productModel) {
    return Row(
      children: [
        Text(
          productModel.popularity,
          style: const TextStyle(fontSize: 14),
        ),
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
      ],
    );
  }

  priceProduct(ProductModel productModel) {
    return Text(
      "\$${productModel.price.toString()}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    );
  }

  editProductButton(ProductModel productModel) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AddProductScreen.routeName,
          arguments: [
            productModel,
            AddEditProductType.edit,
          ],
        );
      },
      child: const Icon(
        Icons.edit,
        color: Colors.grey,
      ),
    );
  }

  removeProductButton(ProductModel productModel) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            // title: const Text(
            //   "Delete product",
            //   style: TextStyle(
            //       color: Colors.black,
            //       decoration: TextDecoration.none,
            //       fontSize: 20),
            // ),
            content: const Text(
              "Do you sure want to delete?",
              style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  productController.removeProduct(productModel);
                  Get.back();
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: const Icon(
        Icons.delete,
        color: Colors.grey,
      ),
    );
  }

  productTitle(ProductModel productModel) {
    return Text(
      productModel.name.toString(),
      textAlign: TextAlign.start,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  productRate(ProductModel productModel) {
    return RatingBar.builder(
      initialRating: double.parse(productModel.popularity),
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ignoreGestures: true,
      glow: false,
      itemSize: 20,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
        size: 5,
      ),
      onRatingUpdate: (rating) {},
    );
  }
}
