import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:random_color/random_color.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";

/// check out blogs
/// renders random blogs in the search bagw
class CheckOutBlogs extends StatefulWidget {
  /// constructor, takes the blogs list
  const CheckOutBlogs({
    required final double width,
    required final this.blogs,
    required final this.blogsBg,
    final Key? key,
  })  : _width = width,
        super(key: key);

  final double _width;

  /// random blogs to be rendered
  final List<Blog> blogs;

  /// map of bg colors of blogs
  final Map<Blog, Color> blogsBg;

  @override
  State<CheckOutBlogs> createState() => _CheckOutBlogsState();
}

class _CheckOutBlogsState extends State<CheckOutBlogs> {
  /// this is where the mapping will be placed
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              "Check out these blogs",
              textScaleFactor: 1.4,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.blogs
                  .map(
                    (final Blog blog) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<ProfilePage>(
                            builder: (final BuildContext context) =>
                                ProfilePage(blogID: blog.blogId.toString()),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.blogsBg[blog] ??
                                RandomColor().randomColor(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          width: kIsWeb ? 200 : ((widget._width / 3) + 30),
                          height: kIsWeb ? 180 : null,
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
                                        blog.headerImage ??
                                            "https://picsum.photos/200",
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
                                            blog.avatarImageUrl ??
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    blog.username ?? "tumbler",
                                    textScaleFactor: 1.1,
                                    style: TextStyle(
                                      color: widget.blogsBg[blog]!
                                                  .computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 8,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final Map<String, dynamic> response =
                                          await Api().followBlog(
                                        int.parse(
                                          blog.blogId.toString(),
                                        ),
                                      );
                                      if (response["meta"]["status"] == "200") {
                                        // TODO(Donia): Make Follow btn disappea
                                      } else
                                        await showToast(
                                          response["meta"]["msg"],
                                        );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          //compute Luminance, if >0.4
                                          // then make it black,
                                          // else make it white
                                          MaterialStateProperty.all<Color>(
                                        widget.blogsBg[blog]!
                                                    .computeLuminance() >
                                                0.5
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        widget.blogsBg[blog] ?? Colors.black,
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(widget._width, 35),
                                      ),
                                      elevation: MaterialStateProperty.all(1),
                                    ),
                                    child: const Text(
                                      "Follow",
                                      textScaleFactor: 1.2,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
