import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../features/home/view/news_details.dart';
import '../model/news_data_model.dart';
import '../utils/helper.dart';
import 'shimmer_loading.dart';

class NewsTileList extends StatelessWidget {
  const NewsTileList({
    super.key,
    required this.articleList,
  });

  final List<Article> articleList;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: articleList.length,
      itemBuilder: (BuildContext context, int index) {
        Article article = articleList[index];
        return Container(
          margin: EdgeInsets.only(
            bottom: height * 0.02,
            left: width * 0.02,
            right: width * 0.02,
          ),
          height: height * 0.14,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailsPage(
                    article: article,
                  ),
                ),
              );
            },
            child: CustomNewsTile(
              article: article,
            ),
          ),
        );
      },
    );
  }
}

class CustomNewsTile extends StatelessWidget {
  const CustomNewsTile({
    super.key,
    required this.article,
  });

  final Article article;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          Hero(
            tag: "${article.publishedAt} ${article.title}",
            child: SizedBox(
              width: constraints.maxHeight,
              height: constraints.maxHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ShimmerWidget(
                    height: constraints.maxHeight,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: constraints.maxWidth * 0.01),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.source.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    "${Helper.getFormattedDate(article.publishedAt)} ${Helper.getFormattedTime(article.publishedAt)}",
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
