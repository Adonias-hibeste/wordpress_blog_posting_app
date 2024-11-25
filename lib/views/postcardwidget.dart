import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:post_wordpress_api/controller/wordpressapiservice.dart';
import 'package:post_wordpress_api/model/postmodel.dart';
import 'package:post_wordpress_api/views/detailspage.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback showInterstitial;
  final WordPressApiService wordpressApiService;

  const PostCard({
    Key? key,
    required this.post,
    required this.showInterstitial,
    required this.wordpressApiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HtmlUnescape htmlUnescape = HtmlUnescape();
    return FutureBuilder<String?>(
      future: wordpressApiService.fetchImageUrl(post.featuredMediaId),
      builder: (context, snapshot) {
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage(post: post)),
              ).then((value) => showInterstitial());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                snapshot.connectionState == ConnectionState.waiting
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : snapshot.hasError
                        ? const SizedBox(
                            height: 200,
                            child: Center(child: Icon(Icons.error)),
                          )
                        : (snapshot.hasData && snapshot.data != null)
                            ? CachedNetworkImage(
                                imageUrl: snapshot.data!,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Icon(Icons.error, size: 48)),
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(
                                height: 200,
                                child: Center(child: Text("No Image")),
                              ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        htmlUnescape.convert(post.title),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        htmlUnescape.convert(post.excerpt),
                        style: TextStyle(
                            fontSize: 14, color: Colors.blueGrey[300]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
