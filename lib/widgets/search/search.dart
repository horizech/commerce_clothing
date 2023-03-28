import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class CustomSearchDelegate extends SearchDelegate {
  final int? collectionId;
  CustomSearchDelegate({Key? key, required this.collectionId});

  List<String> searchTerms = [
    "tshirt",
    "tshirt",
    "Plain tshirt",
    "t-shirt",
    "trouser",
    "ggggg",
    "tshirt1",
    "tshirt2",
    "tshirt3",
    "tshirt4",
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return GestureDetector(
      onTap: () => ServiceManager<UpNavigationService>().navigateToNamed(
        Routes.products,
        queryParams: {
          'collection': '${collectionId ?? 0}',
          'Name': query,
        },
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10),
          child: Row(
            children: [
              Text(query,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var searchValue in searchTerms) {
      if (searchValue.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(searchValue);
      }
    }
    return matchQuery.length > 5
        ? Column(
            children: [
              SizedBox(
                height: 300,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: matchQuery.length < 5 ? matchQuery.length : 5,
                    itemBuilder: (context, index) {
                      var result = matchQuery[index];
                      return GestureDetector(
                        onTap: () => ServiceManager<UpNavigationService>()
                            .navigateToNamed(
                          Routes.products,
                          queryParams: {
                            'collection': '${collectionId ?? 0}',
                            'Name': query,
                          },
                        ),
                        child: ListTile(
                          // shape: RoundedRectangleBorder(
                          //   side: const BorderSide(width: 1),
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                          // leading: const Icon(Icons.ice_skating),
                          textColor: Colors.black,
                          contentPadding:
                              const EdgeInsets.only(top: 5, left: 30),
                          title: Text(result),
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () =>
                    ServiceManager<UpNavigationService>().navigateToNamed(
                  Routes.products,
                  queryParams: {
                    'collection': '${collectionId ?? 0}',
                    'Name': query,
                  },
                ),
                child: const Text(
                  "Show More",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return GestureDetector(
                onTap: () =>
                    ServiceManager<UpNavigationService>().navigateToNamed(
                  Routes.products,
                  queryParams: {
                    'collection': '${collectionId ?? 0}',
                    'Name': query,
                  },
                ),
                child: ListTile(
                  textColor: Colors.black,
                  // selectedTileColor: const Color.fromARGB(255, 60, 49, 49),
                  contentPadding: const EdgeInsets.only(top: 5, left: 30),
                  title: Text(result),
                ),
              );
            });
  }
}
