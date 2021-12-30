import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

/// to get the "autocomplete words"
Future<List<String>> getAutoComplete(
  final String word,
) async {
  final List<String> autoCompWords = <String>[];
  if (word.length > 1) {
    final Map<String, dynamic> response = await Api().fetchAutoComplete(word);
    if (response["meta"]["status"] == "200") {
      final List<dynamic> words = response["response"]["words"];
      for (final Map<String, dynamic> wordResult in words) {
        final String autoCompWord = wordResult["word"];
        autoCompWords.add(autoCompWord);
      }
    }
  }
  return autoCompWords;
}

/// to get the "autocomplete words"
Future<List<List<dynamic>>> getSearchResults(final String word,
    {final int page = 1,}) async {
  List<PostModel> postsResults = <PostModel>[];
  final List<Tag> tagsResults = <Tag>[];
  final List<Blog> blogResults = <Blog>[];

  final Map<String, dynamic> response = await Api().fetchSearchResults(
    word,
    page: page,
  );
  if (response["meta"]["status"] == "200") {
    final List<dynamic> posts = response["response"]["posts"]["posts"];
    final List<dynamic> tags = response["response"]["tags"]["tags"];
    final List<dynamic> blogs = response["response"]["blogs"]["blogs"];
    postsResults = await PostModel.fromJSON(posts, true);

    for (final Map<String, dynamic> tagResult in tags) {
      final Tag tag = Tag(
        tagDescription: tagResult["tag_description"],
        tagImgUrl: tagResult["tag_image"],
        postsCount: tagResult["posts_count"],
        isFollowed: tagResult["followed"] as bool,
        followersCount: tagResult["followers_number"],
      );
      tagsResults.add(tag);
    }

    for (final Map<String, dynamic> blogResult in blogs) {
      final Blog blog = Blog(
        isPrimary: false,
        // don't care
        allowAsk: false,
        // don't care
        allowSubmission: false,
        // don't care
        avatarImageUrl: blogResult["avatar"].toString().isNotEmpty
            ? blogResult["avatar"].toString()
            : "https://i.pinimg.com/736x/89/90/48/899048ab0cc455154006fdb9676964b3.jpg",
        avatarShape: blogResult["avatar_shape"] ?? "circle",
        headerImage: blogResult["header_image"].toString().isNotEmpty
            ? blogResult["header_image"].toString()
            : "https://picsum.photos/200",
        blogDescription: blogResult["description"] ?? "",
        blogTitle: blogResult["title"] ?? "",
        blogId: blogResult["id"].toString(),
        username: blogResult["username"] ?? "",
        isFollowed: blogResult["followed"],
      );
      blogResults.add(blog);
    }
  } else
    await showToast(response["meta"]["status"]);
  final List<List<dynamic>> result = <List<dynamic>>[
    postsResults,
    tagsResults,
    blogResults
  ];
  return result;
}
