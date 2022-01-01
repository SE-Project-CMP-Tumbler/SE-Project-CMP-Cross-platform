import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/follow_blog.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";

/// blog component
class CheckOutBlog extends StatefulWidget {
  /// Constructor
  const CheckOutBlog({
    required final this.blog,
    required final this.bgColor,
    required final double width,
    final Key? key,
  })  : _width = width,
        super(key: key);

  /// blog data
  final Blog blog;

  /// blog background color
  final Color bgColor;
  final double _width;

  @override
  State<CheckOutBlog> createState() => _CheckOutBlogState();
}

class _CheckOutBlogState extends State<CheckOutBlog> {
  /// to indicate whether the user successfully followed this tag or not
  bool _followed = false;

  /// to indicate a loading of a post or delete tag request
  bool _proceedingFollowing = false;

  @override
  void initState() {
    setState(() {
      _followed = widget.blog.isFollowed ?? false;
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<ProfilePage>(
            builder: (final BuildContext context) => ProfilePage(
              blogID: widget.blog.blogId!,
              key: Key(widget.blog.blogId!),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        width: kIsWeb ? 200 : ((widget._width / 3) + 30),
        height: kIsWeb ? 180 : (widget._width / 3) + 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 90,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      widget.blog.headerImage ?? "https://picsum.photos/200",
                      width: widget._width,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: navy,
                        radius: 30,
                        backgroundImage: NetworkImage(
                          widget.blog.avatarImageUrl ??
                              "https://picsum.photos/200",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.blog.username ?? "tumbler",
                  textScaleFactor: 1.1,
                  style: TextStyle(
                    color: widget.bgColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 8,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (mounted)
                        setState(() {
                          _proceedingFollowing = true;
                        });
                      if (!_followed) {
                        if (widget.blog.blogId != null) {
                          final bool succeeded =
                              await followBlog(int.parse(widget.blog.blogId!));
                          if (succeeded) {
                            showSnackBar(
                              context,
                              "Great!, you are now following "
                              "${widget.blog.blogTitle}",
                            );
                            if (mounted)
                              setState(() {
                                _followed = true;
                              });
                          } else {
                            showSnackBar(
                              context,
                              "OOPS, something went wrong 😢",
                            );
                          }
                        }
                      } else {
                        if (widget.blog.blogId != null) {
                          final bool succeeded = await unFollowBlog(
                            int.parse(widget.blog.blogId!),
                          );
                          if (succeeded) {
                            showSnackBar(
                              context,
                              "Don't worry, u won't be"
                              " bothered by this blog again",
                            );
                            if (mounted)
                              setState(() {
                                _followed = false;
                              });
                          } else {
                            showSnackBar(
                              context,
                              "OOPS, something went wrong 😢",
                            );
                          }
                        }
                      }
                      if (mounted)
                        setState(() {
                          _proceedingFollowing = false;
                        });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          //compute Luminance, if >0.4
                          // then make it black,
                          // else make it white
                          MaterialStateProperty.all<Color>(
                        _followed
                            ? (widget.bgColor.computeLuminance() > 0.5
                                ? Colors.white
                                : Colors.black)
                            : widget.bgColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        widget.bgColor,
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size(widget._width, 35),
                      ),
                      elevation: MaterialStateProperty.all(1),
                    ),
                    child: _proceedingFollowing
                        ? const CircularProgressIndicator()
                        : Text(
                            _followed ? "Unfollow" : "Follow",
                            textScaleFactor: 1.2,
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
