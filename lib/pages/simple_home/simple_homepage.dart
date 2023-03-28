import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/widgets/appbar/custom_appbar.dart';
import 'package:shop/widgets/drawer/drawer.dart';
import 'package:shop/widgets/header/header.dart';
import 'package:shop/widgets/slider/parent_category_slider.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class SimpleHomePage extends StatelessWidget {
  const SimpleHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    List<Collection> root = [];
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
          child: Column(
            children: [
              const HeaderWidget(),
              SizedBox(
                child: BlocConsumer<StoreCubit, StoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    root = state.collections!
                        .where(((e) => e.parent == null && e.media != null))
                        .toList();

                    return ParentCollectionSlider(
                      root: root,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
