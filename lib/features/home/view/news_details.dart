import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/news_data_model.dart';
import 'package:news_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Hero(
              tag: "${article.publishedAt} ${article.title}",
              child: SizedBox(
                height: height * 0.35,
                width: double.maxFinite,
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HeartButton(
                        maxSize: 20,
                        onTap: (value) async {
                          String uuid = FirebaseAuth.instance.currentUser!.uid;

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(uuid)
                              .set({
                            'likedArticle': [article],
                          });
                        },
                        size: 20,
                      )
                    ],
                  ),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(article.description),
                  SizedBox(height: height * 0.01),
                  Text(article.content),
                  SizedBox(height: height * 0.02),
                  MaterialButton(
                    child: Text(
                      "View Full Article",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: () async {
                      _launchURL(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(context) async {
    final Uri url = Uri.parse(article.url);
    if (!await launchUrl(url)) {
      showSnackbar(context, "Could not launch $url");
    }
  }
}

class HeartButton extends StatefulWidget {
  const HeartButton(
      {required this.maxSize,
      required this.onTap,
      required this.size,
      super.key});
  final Function(bool value) onTap;
  final double size;
  final double maxSize;
  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> sizeAnimation;
  late Animation<Color?> colorAnimation;
  bool isFav = false;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );

    colorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: Colors.red,
    ).animate(controller);

    sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: widget.maxSize),
        weight: 90,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.maxSize, end: widget.size),
        weight: 10,
      )
    ]).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return IconButton(
          alignment: Alignment.center,
          onPressed: () {
            if (controller.status == AnimationStatus.dismissed) {
              controller.forward();
              isFav = true;
            } else {
              controller.reverse();
              isFav = false;
            }

            widget.onTap(isFav);
          },
          icon: Icon(
            Icons.favorite,
            color: colorAnimation.value,
            size: isFav ? sizeAnimation.value : widget.size,
          ),
        );
      },
    );
  }
}
