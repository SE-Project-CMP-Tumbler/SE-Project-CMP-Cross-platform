import "dart:io";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart" show TestWidgetsFlutterBinding;
import "package:test/test.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/follow_blog.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Methods/search_utils.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

// ignore: avoid_void_async
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  HttpOverrides.global = _MyHttpOverrides();

  group("getting search & explore api methods tests", () {
    // setup
    final Api api = Api();

    test(
        "un following tag is completed successfully"
          ,() async {
      // run
      final Map<String, dynamic> result = await api.unFollowTag("tag");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test(
        "following tag request is posted successfully"
        ,() async {
      // run
      final Map<String, dynamic> result = await api.followTag("tag");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test(
        "testing fetching tag posts"
            " from mocking server is a success", () async {
      // run
      final Map<String, dynamic> result = await api.fetchTagPosts("tag");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test(
        "testing fetching tag posts"
            " from mocking server returns a list", () async {
      // run
      final Map<String, dynamic> result = await api.fetchTagPosts("tag");
      // verify
      expect(result["response"]["posts"], isA<List<dynamic>>());
    });

    test(
        "testing fetching tags followed by"
        " a blog from mocking server is a success", () async {
      // run
      final Map<String, dynamic> result = await api.fetchTagsFollowed();
      // verify
      expect(result["meta"]["status"], "200");
    });
    test(
        "testing fetching tags followed by a blog from mocking server"
        " returns a list", () async {
      // run
      final Map<String, dynamic> result = await api.fetchTagsFollowed();
      // verify
      expect(
        result["response"]["tags"],
        isA<List<dynamic>>(),
      );
    });
    test("testing fetching check out tags is a success", () async {
      // run
      final Map<String, dynamic> result = await api.fetchCheckOutTags();
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("testing fetching check out tags returns a list", () async {
      // run
      final Map<String, dynamic> result = await api.fetchCheckOutTags();
      // verify
      expect(result["response"]["tags"],
        isA<List<dynamic>>(),);
    });

    test("testing fetching check out blogs is a success", () async {
      // run
      final Map<String, dynamic> result = await api.fetchCheckOutBlogs();
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("testing fetching check out blogs returns a list", () async {
      // run
      final Map<String, dynamic> result = await api.fetchCheckOutBlogs();
      // verify
      expect(result["response"]["blogs"],
        isA<List<dynamic>>(),);
    });

    test("testing fetching random posts is a success", () async {
      // run
      final Map<String, dynamic> result = await api.fetchRandomPosts();
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("testing fetching random posts returns a list", () async {
      // run
      final Map<String, dynamic> result = await api.fetchRandomPosts();
      // verify
      expect(result["response"]["posts"],
        isA<List<dynamic>>(),);
    });

    test("testing fetching trending tags from mock server", () async {
      // run
      final Map<String, dynamic> result = await api.fetchTrendingTags();
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("testing fetching trending tags from mock server is a list", () async {
      // run
      final Map<String, dynamic> result = await api.fetchTrendingTags();
      // verify
      expect(result, isA<Map<String, dynamic>>());
    });


    test(
        "fetching auto complete words to search about is successful"
        ,() async {
      // run
      final Map<String, dynamic> result = await api.fetchAutoComplete("word");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test(
        "fetching auto complete words to search about returns a list"
        ,() async {
      // run
      final Map<String, dynamic> result = await api.fetchAutoComplete("word");
      // verify
      expect(result["response"]["words"], isA<List<dynamic>>());
    });


    test("Testing fetching auto complete words is a list of strings", () async {
      // run
      final dynamic res = await getAutoComplete("anything");
      // verify
      expect(
        res,
        isA<List<String>>(),
      );
    });
    test("testing fetching search results returns "
        "list of posts not a single post", () async {
      // run
      final Map<String, dynamic> result =
          await Api().fetchSearchResults("anything");
      // verify
      expect(
        result["response"]["posts"]["posts"],
        isA<List<dynamic>>(),
      );
    });
    test("testing fetching search results returns "
        "list of tags not a single tag", () async {
      // run
      final Map<String, dynamic> result =
          await Api().fetchSearchResults("anything");
      // verify
      expect(
        result["response"]["tags"]["tags"],
        isA<List<dynamic>>(),
      );
    });
    test("testing fetching search results returns "
        "list of blogs not a single blog", () async {
      // run
      final Map<String, dynamic> result =
          await Api().fetchSearchResults("anything");
      // verify
      expect(
        result["response"]["blogs"]["blogs"],
        isA<List<dynamic>>(),
      );
    });
    test("testing fetching search results returns a list of 3 lists", () async {
      // run
      final  List<List<dynamic>> res = await getSearchResults("anything");
      // verify
      expect(
        res.length,
        3,
      );
    });
  });
  group("parsing responses into lists and objects"
      " in search and explore sections",
          (){
    ////////// in Methods/follow_blog ////////
    test("following blog returns true", ()async{
      final bool res= await  followBlog(1);
      expect(res, true);
    });

    test("un following blog returns true", ()async{
      final bool res= await  unFollowBlog(1);
      expect(res, true);
    });

    //////// in Methods/follow_tag /////////
    test("following tag returns true", ()async{
      final bool res= await  followTag("dump");
      expect(res, true);
    });

    test("un following tag returns true", ()async{
      final bool res= await  unFollowTag("dump");
      expect(res, true);
    });

    //////// in Methods/get_all_blogs /////////
    test("parsing the json response of getting "
        "random blogs and returning a non-empty list of blogs", ()async{
      final List<Blog> res= await getRandomBlogs();
      expect(res, isNotEmpty );
    });

    //////// in Methods/get_tags /////////
    test("parsing the json response of getting "
        "random tags and returning a non-empty list of blogs", ()async{
      final List<Tag> res= await getTagsToFollow();
      expect(res, isNotEmpty );
    });

    test("parsing the json response of getting "
        "trending tags and returning a non-empty list of tags", ()async{
      final List<Tag> res= await getTrendingTagsToFollow();
      expect(res, isNotEmpty );
    });

    test("parsing the json response of getting "
        "tag posts and returning a non-empty list of posts", ()async{
      final List<PostModel> res= await getTagPosts("dump");
      expect(res, isNotEmpty );
    });
    test("parsing the json response of getting list of "
        "tags that the user follows and returning a non-empty list of tags",
            ()async{
      final List<Tag> res= await getUserFollowedTags();
      expect(res, isNotEmpty );
    });
    //////// in Methods/random_posts /////////
    test("parsing the json response of getting list of "
        "random posts and returning a "
        "non-empty list of PostModel",
            ()async{
          final List<PostModel> res= await getRandomPosts();
          expect(res, isNotEmpty );
        });
    //////// in Methods/search_utils /////////
    test("parsing the json response of getting search results, and returning "
        "a list of 3 non-empty lists of types [posts, tags, blogs]",
            ()async{
          final List<List<dynamic>> res= await getSearchResults("dump");
          expect(res.length, 3 );
          expect(res[0], isA<List<PostModel>>());
          expect(res[1], isA<List<Tag>>());
          expect(res[2], isA<List<Blog>>());
          expect(res[0], isNotEmpty);
          expect(res[1], isNotEmpty);
          expect(res[2], isNotEmpty);
        });
    });
}

class _MyHttpOverrides extends HttpOverrides {}
