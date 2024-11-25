import 'package:flutter/material.dart';
import 'package:post_wordpress_api/controller/wordpressapiservice.dart';
import 'package:post_wordpress_api/model/postmodel.dart';
import 'package:post_wordpress_api/views/postcardwidget.dart';
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WordPressApiService _wordpressApiService = WordPressApiService();
  List<Post> _posts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() => _isLoading = true);
    try {
      final posts = await _wordpressApiService.fetchPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showInterstitialAd(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    print("Interstitial Ad Shown (Placeholder)");
    //Replace with actual interstitial ad code here. For example:
    // await _interstitialAd.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPress Post Viewer',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _hasError
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _fetchPosts,
                  child: ListView.separated(
                    itemCount: _posts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          PostCard(
                            post: _posts[index],
                            showInterstitial: () =>
                                _showInterstitialAd(context),
                            wordpressApiService: _wordpressApiService,
                          ),
                          //Banner Ad Placeholder
                          if (_posts[index].bannerAd != null)
                            Container(
                              height: 50,
                              color: Colors.blueGrey[100],
                              child: const Center(
                                child: Text(
                                  'Banner Ad Placeholder',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => const PostCardSkeleton(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchPosts,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 20, width: 100, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Container(height: 10, width: 150, color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
