import "package:flutter/material.dart";

/// card a single tag
class TagCard extends StatelessWidget {
  ///
  const TagCard({
    required final this.tagBackGround,
    required final double width,
    required final this.tag,
    final Key? key,
  }) : _width = width, super(key: key);
  ///
  final  String tagBackGround;
  final double _width;
  /// the tag title
  final String tag;
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: ClipRRect(
        borderRadius:
        const BorderRadius.all(Radius.circular(5)),
        child: Stack(
          children: <Widget>[
            Image.network(
              tagBackGround.isNotEmpty?tagBackGround:"https://picsum.photos/200",
              width: _width / 3,
              height: (_width / 3) - 40,
              fit: BoxFit.cover,
            ),
            Container(
              width: _width / 3,
              height: (_width / 3) - 40,
              color: Colors.black26,
              child:  Center(
                child: Text(
                  "#$tag",
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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