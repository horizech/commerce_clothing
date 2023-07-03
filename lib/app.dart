import 'package:apiraiser/apiraiser.dart';

import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/themes/up_themes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/up_app.dart';
import 'package:flutter_up/widgets/up_responsive_page.dart';
import 'package:shop/constants.dart';
import 'package:shop/pages/admin/admin.dart';
import 'package:shop/pages/admin/admin_attributes_mob.dart';
import 'package:shop/pages/admin/admin_combos.dart';
import 'package:shop/pages/admin/admin_combos_mob.dart';
import 'package:shop/pages/admin/admin_gallery.dart';
import 'package:shop/pages/admin/admin_gallery_mob.dart';
import 'package:shop/pages/admin/admin_keywords.dart';
import 'package:shop/pages/admin/admin_attributes.dart';
import 'package:shop/pages/admin/admin_media.dart';
import 'package:shop/pages/admin/admin_keywords_mob.dart';
import 'package:shop/pages/admin/admin_media_mob.dart';
import 'package:shop/pages/admin/admin_products.dart';
import 'package:shop/pages/admin/admin_products_mob.dart';
import 'package:shop/pages/authentication/loginsignup.dart';
import 'package:shop/pages/cart/cart.dart';
import 'package:shop/pages/payment/payment.dart';
import 'package:shop/pages/payment_method/card_payment_page.dart';
import 'package:shop/pages/payment_method/payment_method_page.dart';
import 'package:shop/pages/product/product.dart';
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
                // baseColor: const Color.fromARGB(255, 23, 23, 23),
                // isDark: true,
                baseColor: Colors.white,
                // primaryColor: Colors.greenAccent,
                primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
                secondaryColor: Colors.white,
                tertiaryColor: const Color.fromARGB(255, 222, 84, 107),
                warnColor: Colors.red,
                successColor: Colors.green,
              ),
              title: 'Shop',
              initialRoute: Routes.home,
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
                UpRoute(
                  name: Routes.cart,
                  path: Routes.cart,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      StoreDependantPage(
                    page: CartPage(),
                  ),
                ),
                UpRoute(
                  path: Routes.admin,
                  name: Routes.admin,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const StoreDependantPage(
                    page: Admin(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  path: Routes.adminMedia,
                  name: Routes.adminMedia,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const UpResponsivePage(
                    desktopPage: AdminMedia(),
                    mobilePage: AdminMediaMob(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  path: Routes.adminCombos,
                  name: Routes.adminCombos,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const UpResponsivePage(
                    desktopPage: AdminCombos(),
                    mobilePage: AdminCombosMob(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  path: Routes.adminProducts,
                  name: Routes.adminProducts,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const UpResponsivePage(
                    desktopPage: AdminProducts(),
                    mobilePage: AdminProductsMob(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  path: Routes.adminAttributes,
                  name: Routes.adminAttributes,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const UpResponsivePage(
                    desktopPage: AdminProductOptions(),
                    mobilePage: AdminProductOptionsMob(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  path: Routes.adminKeywords,
                  name: Routes.adminKeywords,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const UpResponsivePage(
                    desktopPage: AdminKeywords(),
                    mobilePage: AdminKeywordsMob(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  path: Routes.adminGallery,
                  name: Routes.adminGallery,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const UpResponsivePage(
                    desktopPage: AdminGallery(),
                    mobilePage: AdminGalleryMob(),
                  ),
                  shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                  redirectRoute: Routes.loginSignup,
                ),
                UpRoute(
                  name: Routes.product,
                  path: Routes.product,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      StoreDependantPage(
                    page: ProductPage(
                      queryParams: state.queryParams,
                    ),
                  ),
                ),
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
                UpRoute(
                  path: Routes.payment,
                  name: Routes.payment,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      Apiraiser.authentication.isSignedIn()
                          ? const StoreDependantPage(
                              page: PaymentPage(),
                            )
                          : const PaymentPage(),
                ),
                UpRoute(
                  path: Routes.paymentMethod,
                  name: Routes.paymentMethod,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const StoreDependantPage(
                    page: PaymentMethodsPage(),
                  ),
                ),
                UpRoute(
                  path: Routes.cardPayment,
                  name: Routes.cardPayment,
                  pageBuilder: (BuildContext context, UpRouterState state) =>
                      const CardPaymentPage(),
                ),
              ]),
        ),
      ),
    );
  }
}
