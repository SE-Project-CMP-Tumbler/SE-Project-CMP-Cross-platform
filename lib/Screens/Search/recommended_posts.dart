import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Widgets/Exceptions_UI/error_dialog.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";
/// to show suggested posts (random) from the explore page
class RecommendedPosts extends StatefulWidget {
  /// constructor
  const RecommendedPosts({final Key? key}) : super(key: key);

  @override
  _RecommendedPostsState createState() => _RecommendedPostsState();
}

class _RecommendedPostsState extends State<RecommendedPosts> with
    TickerProviderStateMixin{
  /// true when posts are loading.
  bool _isLoading = false;

  /// true when error occurred
  bool _error = false;

  /// true when it's first time to load
  bool _firstTime =true;
  AnimationController? loadingSpinnerAnimationController;
  List<PostModel> randomPosts=<PostModel>[];
  /// Responsible for reloading all explore screen results
  Future<void> refreshRandomPostsPage(final BuildContext context,)
  async {
    _error = false;
    setState((){
      _isLoading = true;

    });

    /// get random posts "try these posts"
    await getRandomPosts().then((final List<PostModel> value) {
      setState((){
        randomPosts.clear();
        randomPosts= value;
        if(_firstTime)
          _firstTime=false;
        _isLoading= false;}
    );
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
      showErrorDialog(context,  "error on random posts\n${error.toString()}");
    });
  }
  @override
  void initState() {
    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController!.repeat();
    refreshRandomPostsPage(context);
    super.initState();
  }
  @override
  void dispose() {
    loadingSpinnerAnimationController!.dispose();
    super.dispose();
  }
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const
          Icon(CupertinoIcons.arrow_left,
            color: Colors.white,
            size: 20,),),
        elevation: 0,
        backgroundColor: navy,
        title: const Text("Recommended for you",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),

        ),
        centerTitle: true,
      ),
      body: _isLoading&& _firstTime?
      const Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: ()async{
            await refreshRandomPostsPage(context);
          },
          child: randomPosts.isNotEmpty?Column(
            children:randomPosts.map((final PostModel post) =>
                Container(
                color: Colors.white,
                child: PostOutView(
                  key: Key(post.postId.toString()),
                  post: post,
                    index: 0, //dump
                   ),
            ),).toList(),
          ):Container(),
        ),
      ),
    );
  }
}
