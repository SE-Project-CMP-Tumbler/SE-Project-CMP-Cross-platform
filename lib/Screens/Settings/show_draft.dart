import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";

/// To Show the Draft Post of the Current Blog
class ShowDraft extends StatefulWidget {
  /// Constructor
  const ShowDraft({final Key? key}) : super(key: key);

  @override
  _ShowDraftState createState() => _ShowDraftState();
}

class _ShowDraftState extends State<ShowDraft> with TickerProviderStateMixin {
  final List<PostModel> _posts = <PostModel>[];
  bool _isLoading = false;
  late AnimationController loadingSpinnerAnimationController;

  Future<void> fetchPosts() async {
    setState(() => _isLoading = true);
    final Map<String, dynamic> response = await Api().fetchDraftPost();

    if (response["meta"]["status"] == "200") {
      setState(
        () async => _posts.addAll(
          await PostModel.fromJSON(response["response"]["posts"], false),
        ),
      );
    } else
      await showToast(response["meta"]["msg"]);

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();

    fetchPosts();
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  /// Shows modal bottom sheet when
  /// the user clicks on more vert icon button in a post.
  void showEditPostBottomSheet(final BuildContext ctx) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: ctx,
      builder: (final _) {
        return Container(
          height: 200,
          color: Colors.black38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Report sensitive content",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Repost spam",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Report something else",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Copy link",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: const Text("Drafts"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: loadingSpinnerAnimationController.drive(
                  ColorTween(
                    begin: Colors.blueAccent,
                    end: Colors.red,
                  ),
                ),
              ),
            )
          : _posts.isNotEmpty
              ? Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (
                          final BuildContext ctx,
                          final int index,
                        ) {
                          return Column(
                            children: <Widget>[
                              PostOutView(
                                post: _posts[index],
                                index: index, // not used
                              ),
                              Container(
                                height: 10,
                                color: const Color.fromRGBO(0, 25, 53, 1),
                              )
                            ],
                          );
                        },
                        itemCount: _posts.length,
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "No Drafts here. Go start one.",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
    );
  }
}
