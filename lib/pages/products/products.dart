import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/appbar/custom_appbar.dart';
import 'package:shop/widgets/drawer/drawer.dart';
import 'package:shop/widgets/error/error.dart';
import 'package:shop/widgets/filters/filter.dart';
import 'package:shop/widgets/header/header.dart';
import 'package:shop/widgets/keywords/keywords.dart';
import 'package:shop/widgets/products/products_list.dart';
import 'package:shop/widgets/products/products_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class Products extends StatefulWidget {
  final Map<String, String>? queryParams;
  const Products({
    this.queryParams,
    Key? key,
  }) : super(key: key);

  @override
  State<Products> createState() => _AllProductsState();
}

class _AllProductsState extends State<Products> {
  int? selectedKeywordId = 0;
  Map<int, List<int>> selectedVariationsValues = {};
  List<Product>? filteredProducts;
  List<Product>? products;

  change(int? id, Map<int, List<int>>? s) {
    setState(() {
      selectedKeywordId = id;
      selectedVariationsValues = s ?? {};
      // filteredProducts!= filteredProducts(
      //     products, selectedVariationsValues, selectedKeywordId);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> collections = [];
    bool isCollectionFilter = false;
    int? collection;
    widget.queryParams;
    if (widget.queryParams!['collection'] != null &&
        widget.queryParams!['collection']!.isNotEmpty) {
      collection = int.parse(widget.queryParams!['collection'] ?? "");
      isCollectionFilter = true;
    } else {
      if (widget.queryParams != null && widget.queryParams!.isNotEmpty) {
        isCollectionFilter = false;
      } else {
        isCollectionFilter = true;
      }
    }
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        scaffoldKey: scaffoldKey,
        collection: collection,
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: isCollectionFilter
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BlocConsumer<StoreCubit, StoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    collections = [];
                    if (collection != null) {
                      int parent = collection;
                      collections.add(parent);

                      while (true) {
                        if (state.collections!
                            .any((element) => element.parent == parent)) {
                          parent = state.collections!
                              .where((element) => element.parent == parent)
                              .first
                              .id!;
                          collections.add(parent);
                        } else {
                          break;
                        }
                      }
                    }

                    debugPrint(collections.toString());
                    return Column(
                      children: [
                        const HeaderWidget(),
                        UpOrientationalColumnRow(
                          widths: const [200, -1],
                          children: [
                            Center(
                              child: Container(
                                // height: MediaQuery.of(context).size.height,
                                color: Colors.grey[100],
                                child: FilterPage(
                                  collection: collection,
                                  change: (v) => change(0, v),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Keywords(
                                    categoryId: collection,
                                    onChange: (k) => change(k, {}),
                                    selectedKeywordId: selectedKeywordId,
                                  ),
                                ),
                                FutureBuilder<List<Product>>(
                                  future: ProductService.getProducts(
                                      collections,
                                      selectedVariationsValues,
                                      selectedKeywordId,
                                      null, {}),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Product>> snapshot) {
                                    products = snapshot.data;
                                    // filteredProducts ??= products;

                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 150,
                                                width: 1000,
                                                child: Container(
                                                    color: Colors.grey[200]),
                                              ),
                                            );
                                          },
                                          itemCount: 6,
                                        ),
                                      );
                                    }
                                    return snapshot.hasData
                                        ? ProductsList(
                                            // products: filteredProducts!,
                                            collection: collection,
                                            products: snapshot.data!,
                                          )
                                        : const CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            )
          : const NotFoundErrorWidget(),
    );
  }
}
