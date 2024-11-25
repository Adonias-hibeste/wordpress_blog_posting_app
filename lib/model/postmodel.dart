import 'dart:convert';

class Post {
  final int id;
  final String title;
  final String excerpt;
  final int featuredMediaId;
  final String content;
  final String? bannerAd;
  final String? interstitialAd;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.featuredMediaId,
    required this.content,
    this.bannerAd,
    this.interstitialAd,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    //Handle potential nulls more gracefully
    return Post(
      id: json['id'] ?? 0, //Provide default values if null.
      title: json['title']['rendered'] ?? '',
      excerpt: json['excerpt']['rendered'] ?? '',
      featuredMediaId: json['featured_media'] ?? 0,
      content: json['content']['rendered'] ?? '',
      bannerAd: json['acf']?['banner_ad_code'],
      interstitialAd: json['acf']?['interstitial_ad_code'],
    );
  }
}
