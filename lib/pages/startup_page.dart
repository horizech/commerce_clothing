// import 'package:lazyboymcr_store/pages/simple-home/simple_homepage.dart';
// import 'package:lazyboymcr_store/widgets/store/store_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class StartupPage extends StatefulWidget {
//   const StartupPage({Key? key}) : super(key: key);

//   @override
//   State<StartupPage> createState() => _StartupPageState();
// }

// class _StartupPageState extends State<StartupPage> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // ApiraiserAuthenticationCubit authentication =
//     //     context.read<ApiraiserAuthenticationCubit>();
//     // authentication.loadSession();
//     // Future.delayed(const Duration(seconds: 5),
//     //     () => context.read<StoreCubit>().getStore());
//     StoreCubit store = context.read<StoreCubit>();
//     store.getStore();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocConsumer<StoreCubit, StoreState>(
//       listener: (context, state) {
//         if (state.isLoading) {
//           const CircularProgressIndicator();
//         }
//         if (state.isSuccessful) {
//         
//          
//         }
//       },
//       builder: (context, state) => ElevatedButton(
//         onPressed: () {
//           StoreCubit store = context.read<StoreCubit>();
//           store.getStore();
//         },
//         child: const Text("click"),
//       ),
//     ));
//   }
// }
