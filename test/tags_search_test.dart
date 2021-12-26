import "dart:convert";
import "dart:io";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/search_utils.dart";

// ignore: avoid_void_async
void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  HttpOverrides.global = _MyHttpOverrides();
  group("tags tests", ()
  {

    test("testing fetching tags followed by"
        " a blog from mocking server is a success",
        ()async{
          // setup
          final Api api= Api();
          // run
          final Response result =await api.fetchTagsFollowed();
          // verify
          expect(result.statusCode,200);

        }
    );
    test("testing fetching tags followed by a blog from mocking server"
        " is in a json format",
            ()async{
              // setup
              final Api api= Api();
              // run
              final Response result =await api.fetchTagsFollowed();
              // verify
              expect(jsonDecode(result.body),isA<Map<String, dynamic>>());
        }
    );

    test("testing fetching tags followed by a blog from mocking server"
        " returns a list",
            ()async{
          // setup
          final Api api= Api();
          // run
          final Response result =await api.fetchTagsFollowed();
          // verify
          expect(jsonDecode(result.body)["response"]["tags"],
              isA<List<dynamic>>(),);


        }
    );
    test("testing fetching check out blogs",
            ()async{
          // setup
          final Api api= Api();
          // run
          final Response result =await api.fetchCheckOutBlogs();
          // verify
          expect(result.statusCode,200);

        }
    );
    test("testing fetching random posts",
            ()async{
          // setup
          final Api api= Api();
          // run
          final Response result =await api.fetchRandomPosts();
          // verify
          expect(result.statusCode,200);

        }
    );
    test("testing fetching trending tags from mock server",
            ()async{

          // run
          final Response result =await Api().fetchTrendingTags();
          // verify
          expect(result.statusCode,200);

        }
    );

    test("testing fetching trending tags from mock server",
            ()async{

          // run
          final Response result =await Api().fetchTrendingTags();
          // verify
          expect(jsonDecode(result.body),isA<Map<String, dynamic>>());

        }
    );

    test("testing fetching tag posts",
            ()async{

          // run
          final Response result =await Api().fetchTagPosts("anything");
          // verify
          expect(jsonDecode(result.body),isA<Map<String, dynamic>>());

        }
    );

    test("testing fetching tag posts", () async{

          // run
          final Response result =await Api().fetchTagPosts("anything");
          // verify
          expect(jsonDecode(result.body)["response"]["posts"],
              isA<List<dynamic>>(),);

        });
    test("testing fetching auto complete words 1",
            ()async{
          // run
          final Response result =await Api().fetchAutoComplete("anything");
          // verify
          expect(result.statusCode,
            200,);

        });
    test("testing fetching auto complete words response 2",
    ()async{
      // run
      final Response result =await Api().fetchAutoComplete("anything");
      print(result.body);
      // verify
      expect(jsonDecode(result.body)["response"]["words"],
        isA<List<dynamic>>(),);

    });

    test("Testing fetching auto complete words 3",
            ()async{
          // run
          final dynamic res= await getAutoComplete("anything");
          // verify
          expect(res,
            isA<List<String>>(),);

        });
    test("testing fetching search results",
            ()async{
              // run
              final Response result =await Api().fetchSearchResults("anything");
              // verify
              expect(jsonDecode(result.body)["response"]["posts"]["posts"],
                isA<List<dynamic>>(),);

        });
    test("testing fetching search results",
            ()async{
          // run
          final Response result =await Api().fetchSearchResults("anything");
          // verify
          expect(jsonDecode(result.body)["response"]["tags"]["tags"],
            isA<List<dynamic>>(),);

        });
    test("testing fetching search results",
            ()async{
          // run
          final Response result =await Api().fetchSearchResults("anything");
          // verify
          expect(jsonDecode(result.body)["response"]["blogs"]["blogs"],
            isA<List<dynamic>>(),);

        });
    test("testing fetching search results",
            ()async{
          // run
          final List<dynamic> res= await getSearchResults("anything");
          // verify
          expect(res.length, 3,);

        });
  });





}
class _MyHttpOverrides extends HttpOverrides {}
