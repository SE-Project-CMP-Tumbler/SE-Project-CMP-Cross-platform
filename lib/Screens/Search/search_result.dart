import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/material.dart";
import "package:random_color/random_color.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/search_utils.dart";
import "package:tumbler/Models/blog.dart";
import 'package:tumbler/Models/post_model.dart';
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";

/// for displaying results of the search query, (posts, tags, blogs)
class SearchResult extends StatefulWidget {
  ///
  const SearchResult({
    required final this.word,
    final Key? key,}) : super(key: key);
  /// word searched about
  final String word;
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    with TickerProviderStateMixin{
  late AnimationController loadingSpinnerAnimationController;
  TabController? tabController;
  /// true when page is loading.
  bool _isLoading = false;
  bool _isFirstTime=true;
  /// true when error occurred
  // ignore: unused_field
  final bool _error = false;

  List<List<dynamic>> searchResults=<List<dynamic>>[];
  List<PostModel> postsRes=<PostModel>[];
  List<Tag> tagRes= <Tag>[];
  List<Blog> blogResults=<Blog>[];
  List<Color> blogsBgColors=<Color>[RandomColor().randomColor()];
  List<Color> tagsBgColors=<Color>[RandomColor().randomColor()];
  Map<Blog, bool> isDeleted=<Blog, bool>{};
  @override
  void initState() {
    super.initState();
    /// Animation controller for the color varying loading spinner
    tabController = TabController(length: 3, vsync: this);
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    getSearch(widget.word);
  }
  Future<void> getSearch(final String word)async
  {
    await getSearchRes(word);
  }
  Future<void> getSearchRes(final String word) async{
    setState((){
      _isLoading = true;

    });
    searchResults= await getSearchResults(word);
    setState(() {
      postsRes= searchResults[0] as List<PostModel>;
      tagRes= searchResults[1] as List<Tag>;
      blogResults= searchResults[2] as List<Blog>;
      blogsBgColors=<Color>[];
      tagsBgColors=<Color>[];
    });
    for(int i =0; i<blogResults.length; i++)
    {
      setState(() {
        blogsBgColors.add(RandomColor().randomColor());
        if(isDeleted[blogResults[i]]== null)
         {
           isDeleted[blogResults[i]]= false;
         }
      });
    }
    for(int i =0; i<tagRes.length; i++)
    {
      setState(() {
        tagsBgColors.add(RandomColor().randomColor());
      });
    }

    setState(() {
      _isLoading = false;
      _isFirstTime= false;
    });
  }
  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    tabController!.dispose();

    super.dispose();
  }
  @override
  Widget build(final BuildContext context) {
final double _height= MediaQuery.of(context).size.height;
final double _width= MediaQuery.of(context).size.width;
final List<String> _tabs= <String> ["Posts", "Tags", "Blogs"];
return Scaffold(
backgroundColor: navy,

body: SafeArea(
  child: Scaffold(
    backgroundColor: navy,
    appBar: AppBar(
      leading: Container(),
      // Display a placeholder widget to visualize the shrinking size.
      flexibleSpace: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(bottom:BorderSide(
            color: Colors.grey.shade200,),)
          ,),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
              children: <Widget>[
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back,
                    color: Colors.grey.shade700,),
                ),
                Padding(
                  padding: const EdgeInsets.only
                    (left:50),
                  child: Align(alignment: Alignment.centerLeft,child:
                Text(widget.word, textScaleFactor: 1.2,),),),
              ],
            ),
        ),

      ),
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      bottom: TabBar(
        controller: tabController,
        indicatorColor: floatingButtonColor,
        labelColor: floatingButtonColor,
        // These are the widgets to put in each tab in the tab bar
        tabs: _tabs
            .map(
              (final String name) => Tab(text: name),
        )
            .toList(),
      ),
    ),
    body: DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
          child: Container(
            color: navy,
            child: TabBarView(
              // These are the contents of the tab views, below the tabs.
              controller: tabController,
              physics: const ClampingScrollPhysics(),
              children: _tabs
                  .map(
                    (final String name) => Builder(
                  // This Builder is needed to provide
                  // a BuildContext that is
                  // "inside" the NestedScrollView, so that
                  // sliverOverlapAbsorberHandleFor() can find the
                  // NestedScrollView.
                  builder: (final BuildContext context) {
                    if (_isLoading && _isFirstTime) {
                      Center(
                        heightFactor: 15,
                        child: CircularProgressIndicator(
                          valueColor:
                          loadingSpinnerAnimationController.drive(
                            ColorTween(
                              begin: Colors.blueAccent,
                              end: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }
                      /// if posts tab
                  else if(_tabs.indexOf(name)==0) {
                    return RefreshIndicator(
                      onRefresh: ()async{
                        await getSearchRes(widget.word);
                      },
                      child: SingleChildScrollView(

                        child: SizedBox(
                          width: _width,
                          child: Center(
                            child: Column(

                              children: postsRes.map((final PostModel post) =>
                                  SizedBox(
                                    width: kIsWeb?500:_width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 18,
                                      ),
                                      child: Container(
                                        color: Colors.white,
                                        child:Container(), /**PostOutView(
                                          post: post,
                                          index: postsRes.indexOf(post),
                                        ),**/
                                      ),
                                    ),
                                  ),)
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  /// tags
                  else if (_tabs.indexOf(name)==1) {
                    return RefreshIndicator(
                      onRefresh: ()async{
                        await getSearchRes(widget.word);
                      },
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: _width,
                          child: Center(
                            child: (tagRes.isNotEmpty) ?Column(

                             crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    // ignore: avoid_redundant_argument_values
                                    kIsWeb?
                                    CrossAxisAlignment.center:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Top tag",
                                          textScaleFactor:  kIsWeb? 2.2:1.2,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: kIsWeb?(_width>600? 300:250)
                                                  : 0.2 * _height,
                                              width: kIsWeb?(_width>600? 400:350)
                                                  : _width * 0.9,
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:const BorderRadius
                                                    .all(
                                                  Radius.circular(10),),
                                                image: DecorationImage(
                                                  image: NetworkImage
                                                    (tagRes[0].tagImgUrl!.isNotEmpty?
                                                  tagRes[0].tagImgUrl!:
                                                  "https://picsum.photos/200",
                                                  ),
                                                  fit: BoxFit.cover,),
                                              ),

                                            ),
                                            Container(
                                              height: kIsWeb?(_width>600? 300:250)
                                                  : 0.2 * _height,
                                              width: kIsWeb?(_width>600? 400:350)
                                                  : _width * 0.9,
                                              decoration:
                                              const BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .all(
                                                  Radius.circular(10),),
                                                color: Colors.black26,
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text
                                                      ("#${tagRes[0].tagDescription}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontFamily: "fav",
                                                      ),
                                                      textScaleFactor: 2,
                                                    ),
                                                    const SizedBox(height: 15,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],

                                  ),
                                ),
                                if (tagRes.length>1) Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    // ignore: avoid_redundant_argument_values
                                    kIsWeb?
                                    CrossAxisAlignment.center:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8,
                                            left: 8,
                                            right: 8,),
                                        child: Text("Other tags",
                                          textScaleFactor: kIsWeb?2.2:1.2,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child:MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: GridView.builder(
                                            gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: kIsWeb?
                                              (_width>600?9:2):2,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 16,
                                            ),
                                            physics: const
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: tagRes.length-1,
                                            itemBuilder: (
                                                final BuildContext context,
                                                final int index,) {
                                              return GestureDetector(
                                                onTap: (){
                                                },
                                                child:  CheckOutTagComponent
                                                  (width: _width, tag: Tag(
                                                  tagDescription:
                                                  tagRes[index+1]
                                                      .tagDescription,
                                                  tagImgUrl: tagRes[index+1]
                                                      .tagImgUrl
                                                      ??tumblerImgUrl,
                                                ),
                                                  color: tagsBgColors[index+1],
                                                  // TODO(Donia): replace this
                                                  //  with the value from the db
                                                  isFollowed: false,
                                                ),);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) else Container(),
                              ],
                            )
                          : Container(),
                          ),
                        ),
                      ),
                    );
                  }
                  /// blogs
                  else if(_tabs.indexOf(name)==2)
                    return RefreshIndicator(
                      onRefresh: ()async{
                        await getSearchRes(widget.word);
                      },
                      child: SingleChildScrollView(
                        child: Center(
                          child: SizedBox(
                          width: _width,
                          child: Column(
                            children:blogResults.map((final Blog blog) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutCubicEmphasized,
                                child: SizedBox(
                                  height: isDeleted[blog]!? 0:500,
                                  width: kIsWeb? 400: null,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 500,
                                        decoration: BoxDecoration(
                                          color: blogsBgColors
                                          [blogResults.indexOf(blog)],
                                          borderRadius: const
                                          BorderRadius.all(Radius.circular(15)),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: const
                                              BorderRadius.only(topLeft:
                                              Radius.circular(15),
                                              topRight:
                                              Radius.circular(15),),
                                              child: Image.network(
                                                blog.headerImage!=null?
                                              (blog.headerImage!.isNotEmpty?
                                              blog.headerImage!:"https://picsum.photos/200/300"):
                                              "https://picsum.photos/200/300",width: _width,

                                                height: 200,fit: BoxFit.cover,),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 500,
                                        decoration:const BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Colors.black38,
                                              Colors.transparent,
                                              Colors.transparent

                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only
                                                  (left: 16,),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Text(blog.username??"",
                                                        style:const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(6),
                                                      child: Row(
                                                        children: <Widget>[
                                                          ElevatedButton(onPressed:
                                                              (){},
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>
                                                                (blogsBgColors
                                                            [blogResults.indexOf(blog)]
                                                            .computeLuminance()>0.5?
                                                            Colors.black:Colors.white,),
                                                              padding:
                                                              MaterialStateProperty
                                                                  .all(const
                                                              EdgeInsets.symmetric
                                                                (horizontal: 24),),
                                                            ),
                                                            child:
                                                            Text("Follow",
                                                              textScaleFactor: 1.2,
                                                              style:
                                                              TextStyle(
                                                                color:  blogsBgColors
                                                            [blogResults.indexOf(blog)]
                                                              .computeLuminance()>0.5?
                                                            Colors.white:Colors.black,
                                                              )
                                                              ,),
                                                          ),
                                                          IconButton(onPressed: (){
                                                            setState(() {
                                                              isDeleted[blog]= true;
                                                            });
                                                          },
                                                            icon:
                                                            Icon(Icons.clear,
                                                              size: 25,
                                                              color:  blogsBgColors
                                                            [blogResults.indexOf(blog)]
                                                              .computeLuminance()>0.5?
                                                              Colors.black:Colors.white,
                                                            ),),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(6),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      const BorderRadius.all
                                                        (Radius.circular(10)),
                                                      child: GridView.builder(
                                                        // TODO(DONIA): fetch posts of
                                                        //  this specific
                                                        /// blog and display it
                                                        gridDelegate: const
                                    SliverGridDelegateWithFixedCrossAxisCount
                                                          (
                                                          crossAxisCount: 3,
                                                          crossAxisSpacing: 1.5,

                                                        ),
                                                        physics: const
                                                        NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: 3,
                                                        itemBuilder: (
                                                            final BuildContext context,
                                                            final int index,) {
                                                          return GestureDetector(
                                                            onTap: (){
                                                        // TODO(Donia): push blog page
                                                            },
                                                            child: Image.network(
                                                              tumblerImgUrl,
                                                              fit: BoxFit.cover,
                                                              ),);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(top: 120,child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: blogsBgColors
                                              [blogResults.indexOf(blog)],
                                                border: Border.all(
                                                  color: blogsBgColors
                                                  [blogResults.indexOf(blog)]
                                                  , width: 3,),
                                                borderRadius: BorderRadius.all(
                                                  blog.avatarShape=="square"?
                                                const Radius.circular(5):
                                                  const Radius.circular(100),
                                                ),
                                            ),
                                            child: Center(
                                              child: InkWell(
                                                onTap: (){
                                                  // TODO(Donia): push blog page
                                                },
                                                child: ClipRRect(
                                                  borderRadius:BorderRadius.all(
                                                    blog.avatarShape=="square"?
                                                    const Radius.circular(3):
                                                    const Radius.circular(100),
                                                  ),
                                                  child: Image.network(
                                                    blog.avatarImageUrl!=null?
                                                    (blog.avatarImageUrl!.isNotEmpty?
                                                    blog.avatarImageUrl!:tumblerImgUrl):
                                                    tumblerImgUrl,
                                                    errorBuilder: (
                                                        final BuildContext context,
                                                        final Object exception,
                                                        final StackTrace? stackTrace,){
                                                      return Image.network(
                                                        tumblerImgUrl,
                                                        width: 100,
                                                        height: 100,fit: BoxFit.cover,);
                                                    },
                                                    width: 100,
                                                    height: 100,fit: BoxFit.cover,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:const  EdgeInsets.all(16),
                                            child: GestureDetector(
                                              onTap:  (){
                                                // TODO(Donia): push blog page
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:const EdgeInsets.all(8),
                                                    child: Text(blog.blogTitle??"",
                                                      textScaleFactor: 1.8,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color:  blogsBgColors
                                                        [blogResults.indexOf(blog)]
                                                            .computeLuminance()>0.5?
                                                        Colors.black:Colors.white,
                                                        fontFamily: "fav",
                                                      ),

                                                    ),
                                                  ),
                                                  Text(blog.blogDescription??"",
                                                    textScaleFactor: 1.1,
                                                    style:  TextStyle(
                                                      color:blogsBgColors
                                                      [blogResults.indexOf(blog)]
                                                          .computeLuminance()>0.5?
                                                      Colors.black:Colors.white,
                                                      fontFamily: "fav",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),).toList(),
                          ),
                        ),
                        ),
                      ),
                    );
                  return Center(
                    heightFactor: 15,
                    child: CircularProgressIndicator(
                      valueColor:
                      loadingSpinnerAnimationController.drive(
                        ColorTween(
                          begin: Colors.blueAccent,
                          end: Colors.red,
                        ),
                      ),
                    ),
                  );

                  },
                ),
              )
                  .toList(),
            ),
          ),
        ),

    ),
  ),
);
  }
}
