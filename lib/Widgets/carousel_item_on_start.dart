import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselItemBuilder extends StatelessWidget {
  const CarouselItemBuilder(
      {Key? key,
      required double width,
      required double height,
      required String imageUrl,
      required String poster,
      required String title,
      bool gifView = false})
      : _width = width,
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
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      !_gifView
          ? Image.asset(
              _imageUrl,
              width: _width,
              height: _height,
              fit: BoxFit.fitHeight,
            )
          : GifView.asset(
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
        child: Text(
          _poster,
          style: GoogleFonts.nunito(
              color: Colors.white38, fontWeight: FontWeight.w700, fontSize: 12),
        ),
        bottom: 25,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Container()),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40.0),
                  child: Text(
                    _title,
                    textScaleFactor: 2.2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'favoritPro',
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8.0),
                          Shadow(color: Colors.white, blurRadius: 1.0)
                        ]),
                  ),
                ),
                Container(),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      )
    ]);
  }
}
