import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:google_fonts/google_fonts.dart";
import "package:random_color/random_color.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Screens/Search/tag_posts.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";

/// the component of each trending tag
class TrendingComponent extends StatefulWidget {
  /// constructor takes a tag object
  const TrendingComponent({
    required final this.tag,
    required final this.index,
    required final this.posts,
    final this.numberColors = colors,
    final Key? key,
  }) : super(key: key);

  /// a single tag details
  final Tag tag;

  /// index of the trending
  final int index;

  /// count of colors used
  final List<Color> numberColors;

  /// posts of each tag to display it under the tag title
  final List<PostModel> posts;

  ///
  static const List<Color> colors = <Color>[
    Color(0xff7F00FF),
    Color(0xffFF7BF5),
    Color(0xffFF5733),
    Color(0xffFFA440),
    Color(0xffF2FF40),
    Color(0xff00DF18),
    Color(0xff36BFFF),
    Color(0xff7F00FF),
    Color(0xffFF7BF5),
  ];

  @override
  State<TrendingComponent> createState() => _TrendingComponentState();
}

class _TrendingComponentState extends State<TrendingComponent> {
  /// to indicate whether the user successfully followed this tag or not
  bool _followed=false;
  bool _proceedingFollowing=false;
  @override
  void initState() {
    setState(() {
      _followed= widget.tag.isFollowed??false;
    });
    super.initState();
  }
  @override
  Widget build(final BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 6),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: widget.numberColors[widget.index],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (widget.index + 1).toString(),
                            style: GoogleFonts.publicSans(
                              color: navy,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute<TagPosts>(
                                builder:
                                    (final BuildContext context)
                                => TagPosts(tag: widget.tag,bgColor:
                                RandomColor().randomColor(),),),);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                widget.tag.tagDescription!,
                                maxLines: 1,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "#${widget.tag.tagDescription!}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () async{
                    if(mounted)
                      setState(() {
                        _proceedingFollowing=true;
                      });
                    if(!_followed)
                    {
                      if (widget.tag.tagDescription!=null) {
                        final bool succeeded= await
                        followTag(widget.tag.tagDescription!);
                        if(succeeded) {
                          showSnackBar(
                            context,
                            "Great!, you are now following "
                            "all about #${widget.tag.tagDescription}",
                          );
                          if(mounted)
                            setState(() {
                              _followed = true;
                            });
                        }
                        else{
                          showSnackBar(
                              context, "OOPS, something went wrong 😢");
                        }
                      }
                    }
                    else{
                      // ignore: invariant_booleans
                      if (widget.tag.tagDescription!=null) {
                        final bool succeeded= await
                        unFollowTag(widget.tag.tagDescription!);
                        if(succeeded) {
                          showSnackBar(
                            context,
                            "Don't worry, u won't be"
                            " bothered by this tag again",
                          );
                          if(mounted)
                            setState(() {
                              _followed = false;
                            });}
                        else{
                          showSnackBar(
                              context, "OOPS, something went wrong 😢");
                        }
                      }}
                    if(mounted)
                      setState(() {
                        _proceedingFollowing=false;
                      });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child:_proceedingFollowing?
                    const CircularProgressIndicator():
                    Text(
                      _followed?"Unfollow":"Follow",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                        color: _followed?Colors.grey:
                        floatingButtonColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 53),
              child: Row(
                children: widget.posts
                    .map(
                      (final PostModel item) => Padding(
                        key: Key(item.postId.toString()),
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute<TagPosts>(
                                  builder:
                                      (final BuildContext context)
                                  => TagPosts(tag: widget.tag,bgColor:
                                  RandomColor().randomColor(),),),);
                            },
                            child: Container(
                              width: _width / 4 + 10,
                              height: _width / 4 - 20,
                              color: Colors.white,
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Html(
                                    data: item.postBody,
                                    style: <String, Style>{
                                      for (final String tag in Html.tags)
                                        tag: Style(
                                          fontSize: FontSize.large,
                                          backgroundColor: Colors.white,
                                          margin: EdgeInsets.zero,
                                          textOverflow: TextOverflow.ellipsis,
                                          width: _width / 4 + 20,
                                          height: _width / 4 - 20,
                                        ),
                                    },
                                    tagsList: Html.tags..remove("video"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
