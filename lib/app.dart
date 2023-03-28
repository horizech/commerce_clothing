import 'package:apiraiser/apiraiser.dart';

import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/themes/up_themes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/up_app.dart';
import 'package:shop/constants.dart';

import 'package:shop/pages/authentication/loginsignup.dart';
import 'package:shop/pages/products/products.dart';
import 'package:shop/pages/simple_home/simple_homepage.dart';
import 'package:shop/pages/store_dependant_page.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/media/media_cubit.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Mediacubit(),
      child: BlocProvider(
        create: (_) => CartCubit(),
        child: BlocProvider(
          create: (_) => StoreCubit(),
          child: UpApp(
              theme: UpThemes.generateThemeByColor(
                // primaryColor: Colors.greenAccent,
                primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
                secondaryColor: Colors.white,
                tertiaryColor: const Color.fromARGB(255, 222, 84, 107),
                warnColor: Colors.red,
                successColor: Colors.green,
              ),
              title: 'Shop',
              initialRoute: Routes.loginSignup,
              upRoutes: [
                UpRoute(
                  path: Routes.loginSignup,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const LoginSignupPage(),
                  name: Routes.loginSignup,
                  shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.home,
                ),
                UpRoute(
                  name: Routes.home,
                  path: Routes.home,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const StoreDependantPage(
                    page: SimpleHomePage(),
                  ),
                ),
                // UpRoute(
                //   name: Routes.cart,
                //   path: Routes.cart,
                //   pageBuilder: (BuildContext context, UpRouterState state) =>
                //       StoreDependantPage(
                //     page: CartPage(),
                //   ),
                // ),
                // UpRoute(
                //   name: Routes.product,
                //   path: Routes.product,
                //   pageBuilder: (BuildContext context, UpRouterState state) =>
                //       StoreDependantPage(
                //     page: ProductPage(
                //       queryParams: state.queryParams,
                //     ),
                //   ),
                // ),
                UpRoute(
                  name: Routes.products,
                  path: Routes.products,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      StoreDependantPage(
                    page: Products(
                      queryParams: state.queryParams,
                    ),
                  ),
                ),
                // UpRoute(
                //   path: Routes.payment,
                //   name: Routes.payment,
                //   pageBuilder: (BuildContext context, UpRouterState state) =>
                //       Apiraiser.authentication.isSignedIn()
                //           ? const StoreDependantPage(
                //               page: PaymentPage(),
                //             )
                //           : const PaymentPage(),
                // ),
                // UpRoute(
                //   path: PaymentMethodsPage.routeName,
                //   name: PaymentMethodsPage.routeName,
                //   pageBuilder: (BuildContext context, UpRouterState state) =>
                //       const StoreDependantPage(
                //     page: PaymentMethodsPage(),
                //   ),
                // ),
                // UpRoute(
                //   path: CardPaymentPage.routeName,
                //   name: CardPaymentPage.routeName,
                //   pageBuilder: (BuildContext context, UpRouterState state) =>
                //       const CardPaymentPage(),
                // ),
              ]),
        ),
      ),
    );
  }
}
