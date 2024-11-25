import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:post_wordpress_api/controller/wordpressapiservice.dart';
import 'package:post_wordpress_api/model/postmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatelessWidget {
  final Post post;
  final HtmlUnescape htmlUnescape = HtmlUnescape();

  DetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Customize icon color if needed
          onPressed: () {
            Navigator.pop(
                context); // This pops the current route (DetailPage) off the stack
          },
        ),
        title: Text(post.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image with better error handling
            FutureBuilder<String?>(
              future: WordPressApiService().fetchImageUrl(post.featuredMediaId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error, size: 48)),
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const SizedBox(height: 200); //If there's no image.
                  }
                } else if (snapshot.hasError) {
                  return Text('Error loading image: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              htmlUnescape.convert(post.title),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey), //Example text color
            ),
            const SizedBox(height: 16),
            Html(
              data: post.content,
              style: {
                "body": Style(
                  fontSize: FontSize(16.0),
                  color: Colors.blueGrey[300], //Example text color
                  lineHeight: LineHeight(1.5),
                ),
                "h1, h2, h3": Style(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold), //Example heading color
              },
            ),
            const SizedBox(height: 32), //Spacer
            //Interstitial Ad Placeholder (Replace with actual ad code)
            if (post.interstitialAd != null)
              Container(
                height: 50,
                color: Colors.blueGrey[100],
                child: const Center(
                  child: Text(
                    'Interstitial Ad Placeholder',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
