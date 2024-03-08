import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/view/login.dart';
import 'package:news_app/model/news_data_model.dart';
import 'package:news_app/res/constants.dart';
import 'package:news_app/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../provider/news_provider.dart';
import '../../../widgets/category_custom_chip.dart';
import '../../../widgets/custom_news_tile.dart';
import '../../../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<NewsProvider>(context, listen: false).fetchHeadlinesNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           FirebaseAuth.instance.signOut();

        //           Navigator.pushAndRemoveUntil(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const LoginScreen(),
        //               ),
        //               (route) => false);
        //         },
        //         icon: const Icon(Icons.logout))
        //   ],
        // ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<NewsProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  SizedBox(height: height * 0.04),
                  SizedBox(
                    height: height * 0.045,
                    child: ListView.builder(
                      itemCount: newsCategories.length + 1,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return CategoryCustomChip(
                            category: "Headlines",
                            onSelect: () {
                              provider.fetchHeadlinesNews();
                            },
                            selected: provider.selectedCategory == "Headlines",
                          );
                        }
                        String category = newsCategories[index - 1];
                        return CategoryCustomChip(
                          category: category,
                          onSelect: () {
                            provider.selectCategory(category);
                          },
                          selected: provider.selectedCategory == category,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  provider.loading
                      ? const ShimmerLoading()
                      : provider.newsDataModel == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("No Data Found")],
                              ),
                            )
                          : Expanded(
                              child: NewsTileList(
                                articleList: provider.newsDataModel!.articles,
                              ),
                            ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
