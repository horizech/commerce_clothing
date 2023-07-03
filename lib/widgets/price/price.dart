import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';

class PriceWidget extends StatelessWidget {
  final double? price;
  final double? discountPrice;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;

  const PriceWidget(
      {Key? key,
      this.price,
      this.discountPrice,
      this.discountStartDate,
      this.discountEndDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return price != null
        ? checkDisocunt(discountStartDate, discountEndDate)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UpText(
                    "${getDiscountPercentage(price, discountPrice).toString()}% discount",
                    style: UpStyle(
                      textSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpText(price.toString(), style: UpStyle(textSize: 16)),
                      const SizedBox(
                        width: 5,
                      ),
                      UpText(discountPrice.toString(),
                          style: UpStyle(textSize: 16)),
                    ],
                  ),
                ],
              )
            : Align(
                alignment: Alignment.topLeft, child: UpText(price.toString()))
        : const Text("");
  }
}

// to check if there is discount or not
checkDisocunt(DateTime? discountStartDate, DateTime? disountEndDate) {
  bool isDiscount = false;
  // DateTime startDate = DateTime.parse(service_start_date);
  // DateTime endDate = DateTime.parse(service_end_date);

  DateTime currentDate = DateTime.now();
  if (discountStartDate != null && disountEndDate != null) {
    if (discountStartDate.isBefore(currentDate) &&
        disountEndDate.isAfter(currentDate)) {
      isDiscount = true;
    }
  }
  return isDiscount;
}

getDiscountPercentage(double? price, double? discountPrice) {
  double percentage = 0;
  if (price != null && discountPrice != null) {
    percentage = 100 - ((discountPrice / price) * 100);
  }
  return percentage.ceilToDouble();
}

getPrice({Product? product, ProductVariation? productVariation}) {
  double? price = 0;
  bool isDisocunt = false;
  if (productVariation != null) {
    isDisocunt = checkDisocunt(
      productVariation.discountStartDate,
      productVariation.discountEndDate,
    );
  } else if (product != null) {
    isDisocunt = checkDisocunt(
      product.discountStartDate,
      product.discountEndDate,
    );
  }

  if (isDisocunt) {
    if (productVariation != null && productVariation.discounPrice != null) {
      price = productVariation.discounPrice;
    } else if (product != null && product.discounPrice != null) {
      price = product.discounPrice;
    }
  } else {
    if (productVariation != null && productVariation.price != null) {
      price = productVariation.price;
    } else if (product != null && product.price != null) {
      price = product.price;
    }
  }
  return price;
}
