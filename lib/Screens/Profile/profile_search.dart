import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Screens/Search/search_result.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Exceptions_UI/generic_exception.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";

/// List of Posts In the Result of the Search
List<PostModel> profileSearchPosts = <PostModel>[];

/// Page to show the Search in Profile page
class ProfileSearchResult extends StatefulWidget {
  /// Constructor
  const ProfileSearchResult({
    required this.word,
    required this.blogID,
    required this.username,
    final Key? key,
  }) : super(key: key);

  /// Word to search
  final String word;

  /// Profile to search in
  final String blogID;

  /// UserName
  final String username;

  @override
  _ProfileSearchResultState createState() => _ProfileSearchResultState();
}

class _ProfileSearchResultState extends State<ProfileSearchResult>
    with TickerProviderStateMixin {
  /// true when posts are loading.
  bool _isLoading = false;

  /// true when error occurred
  bool _error = false;

  /// Indicate that more posts are fetched
  bool _gettingPosts = false;

  late AnimationController loadingSpinnerAnimationController;

  /// for Pagination
  int currentPage = 0;

  final ScrollController _controller = ScrollController();

  Future<void> fetchPosts() async {
    setState(() => _isLoading = true);
    setState(() => _error = false);
    profileSearchPosts.clear();
    currentPage = 0;
    final Map<String, dynamic> response = await Api()
        .fetchSearchResultsProfile(widget.word, widget.blogID, currentPage + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPage++;
        profileSearchPosts.addAll(
          await PostModel.fromJSON(response["response"]["posts"]),
        );
      }
    } else {
      await showToast(response["meta"]["msg"]);
      setState(() => _error = true);
    }
    setState(() => _isLoading = false);
  }

  Future<void> getMorePosts() async {
    if (_gettingPosts) {
      return;
    }
    _gettingPosts = true;
    final Map<String, dynamic> response = await Api()
        .fetchSearchResultsProfile(widget.word, widget.blogID, currentPage + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPage++;
        setState(
          () async => profileSearchPosts.addAll(
            await PostModel.fromJSON(response["response"]["posts"]),
          ),
        );
      }
    } else
      await showToast(response["meta"]["msg"]);
    _gettingPosts = false;
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 50) {
        getMorePosts();
      }
    });

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    fetchPosts();
  }

  @override
  Widget build(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchPosts,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
          appBar: AppBar(
            title: Text(widget.username),
            backgroundColor: appBackgroundColor,
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<SearchResult>(
                          builder: (final BuildContext context) => SearchResult(
                            word: widget.word,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Search all of Tumbler",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: (defaultTargetPlatform == TargetPlatform.windows ||
                            defaultTargetPlatform == TargetPlatform.linux ||
                            defaultTargetPlatform == TargetPlatform.macOS)
                        ? MediaQuery.of(context).size.width * (2 / 3)
                        : double.infinity,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  loadingSpinnerAnimationController.drive(
                                ColorTween(
                                  begin: Colors.blueAccent,
                                  end: Colors.red,
                                ),
                              ),
                            ),
                          )
                        : _error
                            ? ListView(
                                children: const <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 150),
                                    child: ErrorImage(
                                      msg: "Unexpected error,"
                                          " please try again later",
                                    ),
                                  ),
                                ],
                              )
                            : profileSearchPosts.isEmpty
                                ? const EmptyBoxImage(msg: "No Posts to show")
                                : ListView.builder(
                                    controller: _controller,
                                    itemCount: profileSearchPosts.length,
                                    itemBuilder: (
                                      final BuildContext ctx,
                                      final int index,
                                    ) {
                                      return PostOutView(
                                        post: profileSearchPosts[index],
                                        index: index,
                                        page: 6,
                                      );
                                    },
                                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
