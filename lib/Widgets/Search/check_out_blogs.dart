import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Widgets/Search/check_out_blog.dart";

/// check out blogs
/// renders random blogs in the search page
class CheckOutBlogs extends StatefulWidget {
  /// constructor, takes the [Blog]s list with all its data,
  /// and a list of their background colors.
  const CheckOutBlogs({
    required final this.blogs,
    required final this.blogsBg,
    final Key? key,
  }) : super(key: key);

  /// random blogs to be rendered
  final List<Blog> blogs;

  /// map of bg colors of blogs
  final Map<Blog, Color> blogsBg;

  @override
  State<CheckOutBlogs> createState() => _CheckOutBlogsState();
}

class _CheckOutBlogsState extends State<CheckOutBlogs> {
  /// to indicate whether the user successfully followed this blog or not

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
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
          if (Provider.of<Tags>(context, listen: false).isLoaded == false &&
              widget.blogs.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.blogs
                    .map(
                      (final Blog blog) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CheckOutBlog(
                          key: Key(blog.blogId!),
                          blog: blog,
                          bgColor: widget.blogsBg[blog] ?? navy,
                          width: _width,
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
