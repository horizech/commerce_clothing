import 'package:flutter_up/locator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/widgets/appbar/custom_appbar.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/cart/empty_cart.dart';
import 'package:shop/widgets/counter.dart';
import 'package:shop/widgets/drawer/drawer.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/price/price.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/variations/color_variation.dart';
import 'package:shop/widgets/variations/size_variation.dart';
import 'package:shop/widgets/variations/variation_selection_mode.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);
  int quantity = 0;

  onQuantityChange(int count) {
    quantity = count;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (state.cart.items.isNotEmpty)
                ? width > 800
                    ? Column(
                        children: [
                          Container(child: cartList(context)),
                          Column(
                            children: state.cart.items.asMap().entries.map(
                              (entry) {
                                return cartListDisplay(context, entry.value,
                                    entry.key, onQuantityChange);
                              },
                            ).toList(),
                          ),
                          // totalPayment(context, state.cart.items),
                          paymentAndBackButton(context, state.cart.items),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            width: width,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 3.0, color: Colors.black),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                "Cart",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(fontSize: 20),
                              ),
                            ),
                          ),
                          const UpText(
                            "Item",
                          ),
                          Column(
                              children:
                                  state.cart.items.asMap().entries.map((entry) {
                            return cartGridDisplay(context, entry.value,
                                entry.key, onQuantityChange);
                          }).toList()),
                          paymentAndBackButton(context, state.cart.items)
                        ],
                      )
                : const EmptyCart();
          },
        ),
      ),
    );
  }
}

Widget cartListDisplay(
    BuildContext context, CartItem item, int index, Function onQuantityChange) {
  // double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  List<Attribute> attributes = [];
  AttributeValue? sizeVariation;
  AttributeValue? colorVariation;
  return BlocConsumer<StoreCubit, StoreState>(
    listener: (context, state) {},
    builder: (context, state) {
      if (state.attributes != null && state.attributes!.isNotEmpty) {
        attributes = state.attributes!.toList();
      }
      if (state.attributeValues != null &&
          state.attributeValues!.isNotEmpty &&
          item.selectedVariation != null &&
          state.attributeValues!.any((element) =>
              element.id ==
              item.selectedVariation!.options[
                  "${attributes.where((element) => element.name.toLowerCase() == "size").first.id}"])) {
        sizeVariation = state.attributeValues!
            .map((e) => e)
            .where((element) =>
                element.id ==
                item.selectedVariation!.options[
                    "${attributes.where((element) => element.name.toLowerCase() == "size").first.id}"])
            .first;
      }

      if (state.attributeValues != null &&
          state.attributeValues!.isNotEmpty &&
          item.selectedVariation != null &&
          state.attributeValues!.any((element) =>
              element.id ==
              item.selectedVariation!.options[
                  "${attributes.where((element) => element.name.toLowerCase() == "color").first.id}"])) {
        colorVariation = state.attributeValues!
            .map((e) => e)
            .where((element) =>
                element.id ==
                item.selectedVariation!.options[
                    "${attributes.where((element) => element.name.toLowerCase() == "color").first.id}"])
            .first;
      }

      return Container(
        width: width - 80,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: MediaWidget(
                      width: 100,
                      height: 100,
                      mediaId: item.product!.thumbnail,
                      onChange: () =>
                          ServiceManager<UpNavigationService>().navigateToNamed(
                        Routes.product,
                        queryParams: {
                          'productId': '${item.product!.id}',
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Text(item.product!.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black)),
                ),
                Wrap(
                  children: [
                    Visibility(
                      visible: item.product!.isVariedProduct &&
                          sizeVariation != null,
                      child: SizeVariationWidget(
                        sizeVariations:
                            sizeVariation != null ? [sizeVariation!] : [],
                        mode: VariationSelectionMode.cart,
                        selectedValues: [sizeVariation?.id ?? -1],
                      ),
                    ),
                    Visibility(
                      visible: item.product!.isVariedProduct &&
                          colorVariation != null,
                      child: ColorVariationWidget(
                        colorVariations:
                            colorVariation != null ? [colorVariation!] : [],
                        mode: VariationSelectionMode.cart,
                        selectedValues: [colorVariation?.id ?? -1],
                      ),
                    ),
                  ],
                ),
                Counter(
                  onChange: (quantity) {
                    try {
                      CartCubit cart = context.read<CartCubit>();
                      cart.updateQuantity(index, quantity);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  defaultValue: item.quantity,
                ),
                Text(
                    "${(getPrice(
                          productVariation: item.selectedVariation,
                          product: item.product,
                        )) * item.quantity}",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black, fontSize: 16)),
                GestureDetector(
                    child: const Text("Remove",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black)),
                    onTap: () {
                      CartCubit cart = context.read<CartCubit>();
                      cart.removeItem(
                        index,
                      );
                    }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget cartGridDisplay(
    BuildContext context, CartItem item, int index, Function onQuantityChange) {
  List<Attribute> attributes = [];
  AttributeValue? sizeVariation;
  AttributeValue? colorVariation;
  double width = MediaQuery.of(context).size.width;

  return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.attributes != null && state.attributes!.isNotEmpty) {
          attributes = state.attributes!.toList();
        }
        if (state.attributeValues != null &&
            state.attributeValues!.isNotEmpty &&
            item.selectedVariation != null &&
            state.attributeValues!.any((element) =>
                element.id ==
                item.selectedVariation!.options[
                    "${attributes.where((element) => element.name.toLowerCase() == "size").first.id}"])) {
          sizeVariation = state.attributeValues!
              .map((e) => e)
              .where((element) =>
                  element.id ==
                  item.selectedVariation!.options[
                      "${attributes.where((element) => element.name.toLowerCase() == "size").first.id}"])
              .first;
        }

        if (state.attributeValues != null &&
            state.attributeValues!.isNotEmpty &&
            item.selectedVariation != null &&
            state.attributeValues!.any((element) =>
                element.id ==
                item.selectedVariation!.options[
                    "${attributes.where((element) => element.name.toLowerCase() == "color").first.id}"])) {
          colorVariation = state.attributeValues!
              .map((e) => e)
              .where((element) =>
                  element.id ==
                  item.selectedVariation!.options[
                      "${attributes.where((element) => element.name.toLowerCase() == "color").first.id}"])
              .first;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: width - 20,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  item.product != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: MediaWidget(
                                width: 100,
                                height: 100,
                                mediaId: item.product!.thumbnail,
                                onChange: () =>
                                    ServiceManager<UpNavigationService>()
                                        .navigateToNamed(
                                      Routes.product,
                                      queryParams: {
                                        'Product': '${item.product!.id}',
                                      },
                                    )),
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 2, 0),
                          child: Text(
                            (item.product != null
                                    ? item.product!.name
                                    : item.selectedVariation != null
                                        ? item.selectedVariation!.name
                                        : "") ??
                                "",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: item.product!.isVariedProduct &&
                                  sizeVariation != null,
                              child: SizeVariationWidget(
                                sizeVariations: sizeVariation != null
                                    ? [sizeVariation!]
                                    : [],
                                mode: VariationSelectionMode.cart,
                                selectedValues: [sizeVariation?.id ?? -1],
                              ),
                            ),
                            Visibility(
                              visible: item.product!.isVariedProduct &&
                                  colorVariation != null,
                              child: ColorVariationWidget(
                                colorVariations: colorVariation != null
                                    ? [colorVariation!]
                                    : [],
                                mode: VariationSelectionMode.cart,
                                selectedValues: [colorVariation?.id ?? -1],
                              ),
                            ),
                          ],
                        ),
                        Counter(
                          onChange: (quantity) {
                            try {
                              CartCubit cart = context.read<CartCubit>();
                              cart.updateQuantity(index, quantity);
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                          defaultValue: item.quantity,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                          "${(getPrice(
                                productVariation: item.selectedVariation,
                                product: item.product,
                              )) * item.quantity}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.black)),
                      GestureDetector(
                          child: const Text("Remove",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black)),
                          onTap: () {
                            CartCubit cart = context.read<CartCubit>();
                            cart.removeItem(
                              index,
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget paymentAndBackButton(BuildContext context, List<CartItem> cartItem) {
  double total;
  total = cartItem
      .map((e) => ((getPrice(
            productVariation: e.selectedVariation,
            product: e.product,
          )) *
          e.quantity))
      .reduce((value, totalPrice) => value + totalPrice);
  return Padding(
    padding:
        const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50, bottom: 10.0),
          child: Wrap(
            alignment: WrapAlignment.end,
            runSpacing: 15.0,
            spacing: 15.0,
            children: [
              Text("Total : ",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: const Color.fromARGB(255, 80, 80, 80),
                      fontSize: 16)),
              Text("$total",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black, fontSize: 20)),
            ],
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.spaceEvenly,
          spacing: 20.0,
          runSpacing: 20.0,
          children: [
            GestureDetector(
              onTap: () =>
                  ServiceManager<UpNavigationService>().navigateToNamed(
                Routes.home,
              ),
              child: Text("< Wanna Shop more",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black, fontSize: 16)),
            ),
            UpButton(
                onPressed: () =>
                    ServiceManager<UpNavigationService>().navigateToNamed(
                      Routes.payment,
                    ),
                text: "Proceed to payment")
          ],
        ),
      ],
    ),
  );
}

Widget cartList(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 3.0, color: Colors.black),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
            child: Text(
              "Cart",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 20),
            ),
          ),
        ),
        Container(
          width: width - 100,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text("ITEM"),
                  // SizedBox(
                  //   width: 120,
                  // ),
                  // Text("Variation"),
                  // Text("UNIT"),
                  // Text("Price"),
                  // Text("    "),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
