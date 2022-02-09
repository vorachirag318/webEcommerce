import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producttask/ui/screen/product_screen/controller/product_controller.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({Key? key, required this.sort}) : super(key: key);
  final String sort;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (ProductController productController) => Row(
        children: [
          Container(
            height: 17,
            width: 17,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: Colors.black.withOpacity(0.50), width: 2)),
            child: widget.sort == productController.selectedSort
                ? Center(
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.black.withOpacity(0.50),
                    ),
                  )
                : const SizedBox(),
          ),
          Text(
            widget.sort,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.60),
            ),
          )
        ],
      ),
    );
  }
}
