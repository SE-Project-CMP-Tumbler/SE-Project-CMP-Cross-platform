import "package:flutter/material.dart";
import "package:gif_view/gif_view.dart";
import "package:google_fonts/google_fonts.dart";

/// Used For Carousel Item
class CarouselItemBuilder extends StatelessWidget {
  /// Constructor
  const CarouselItemBuilder({
    required final double width,
    required final double height,
    required final String imageUrl,
    required final String poster,
    required final String title,
    final bool gifView = false,
    final Key? key,
  })  : _width = width,
        _height = height,
        _imageUrl = imageUrl,
        _title = title,
        _poster = poster,
        _gifView = gifView,
        super(key: key);

  final double _width;
  final double _height;
  final String _imageUrl;
  final String _poster;
  final String _title;
  final bool _gifView;

  @override
  Widget build(final BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        if (!_gifView)
          Image.asset(
            _imageUrl,
            width: _width,
            height: _height,
            fit: BoxFit.fitHeight,
          )
        else
          GifView.asset(
            _imageUrl,
            width: _width,
            height: _height,
            fit: BoxFit.fitHeight,
            frameRate: 8,
          ),
        Container(
          width: _width,
          height: _height,
          color: Colors.black.withOpacity(0.49),
        ),
        Positioned(
          bottom: 25,
          child: Text(
            _poster,
            style: GoogleFonts.nunito(
              color: Colors.white38,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(child: Container()),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 40,
                    ),
                    child: Text(
                      _title,
                      textScaleFactor: 2.2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "favoritPro",
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(blurRadius: 8),
                          Shadow(color: Colors.white, blurRadius: 1)
                        ],
                      ),
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        )
      ],
    );
  }
}
