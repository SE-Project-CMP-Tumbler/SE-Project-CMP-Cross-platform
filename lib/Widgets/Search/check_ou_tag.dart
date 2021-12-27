import "package:flutter/foundation.dart" show kIsWeb;

import "package:flutter/material.dart";
import 'package:tumbler/Constants/colors.dart';
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Models/tag.dart";
/// for check out tags section
class CheckOutTagComponent extends StatefulWidget {
  ///
  const CheckOutTagComponent({
    required final double width,
    required final this.tag,
    required final this.color,
    final Key? key,
  }) : _width = width, super(key: key);

  final double _width;
  /// the tag to be displayed in the component
  final Tag tag;
  /// main color of the component
  final Color color;

  @override
  State<CheckOutTagComponent> createState() => _CheckOutTagComponentState();
}

class _CheckOutTagComponentState extends State<CheckOutTagComponent> {
  /// to indicate whether the user successfully followed this tag or not
  bool _followed= false;
  /// to indicate a loading of a post or delete tag request
  bool _proceedingFollowing=false;
  @override
  Widget build(final BuildContext context) {
    final double _height= MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: kIsWeb?150:0.38*widget._width,
        height: kIsWeb?200:0.2*_height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius:
          const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color:Color.fromRGBO(widget.color.red+30>0?widget.color.red+30:widget.color.red,
                widget.color.green+30<255?widget.color.green+30:widget.color.green,
                widget.color.blue+30<255?widget.color.blue+30:widget.color.blue
                , 1,),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Expanded(
               flex: 2,
               child: Padding(
                padding:const EdgeInsets.only(
                  top: 16,
                  bottom: 8,
                  left: 8,
                  right: 8,
                ),
                child: Text(
                  "#${widget.tag.tagDescription!}",
                  textScaleFactor: 1.1,
                  style:TextStyle(
                    color: widget.color.computeLuminance()>0.5?Colors.black:Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
             ),
            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: Image.network(
                          widget.tag.tagImgUrl!.isNotEmpty?widget.tag.tagImgUrl!:
                          tumblerImgUrl,
                          height: 65,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 6,
                        top: 6,
                        bottom: 6,
                      ),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: Image.network(
                          widget.tag.tagImgUrl!.isNotEmpty?widget.tag.tagImgUrl!:
                          tumblerImgUrl,
                          height: 65,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                    right: 6,
                    bottom: 4,
                  ),
                  child: ElevatedButton(
                    onPressed: () async{
                      setState(() {
                        _proceedingFollowing=true;
                      });
                      if(!_followed)
                        {
                      if (widget.tag.tagDescription!=null) {
                        final bool succeeded= await
                        followTag(widget.tag.tagDescription!);
                        if(succeeded) {
                          _showToast(context, "Great!, you are now following "
                              "all about #${widget.tag.tagDescription}",);
                          setState(() {
                            _followed = true;
                          });
                        }
                        else{
                        _showToast(context, "OOPS, something went wrong 😢");
                        }
                        }
                      else{
                          // ignore: invariant_booleans
                          if (widget.tag.tagDescription!=null) {
                          final bool succeeded= await
                          unFollowTag(widget.tag.tagDescription!);
                          if(succeeded) {
                          _showToast(context, "Don't worry, u won't be"
                          " bothered by this tag again",);
                          setState(() {
                          _followed = false;
                          });}
                          else{
                          _showToast(context, "OOPS, something went wrong 😢");
                          }
                          }

                      }
                      setState(() {
                        _proceedingFollowing=false;
                      });
                      }},

                    style: ButtonStyle(

                      backgroundColor:
                      //compute Luminance, if >0.4
                      // then make it black,
                      // else make it white
                      MaterialStateProperty.all<Color>(
                        _followed?(widget.color.computeLuminance()>0.5?
                        Colors.white:
                        Colors.black):
                        widget.color.computeLuminance()>0.5?Colors.black:
                        Colors.white,
                      ),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(
                       widget.color,
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size(widget._width, 60),
                      ),
                      elevation:
                      MaterialStateProperty.all(1),
                    ),
                    child: _proceedingFollowing?
                        const CircularProgressIndicator():Text(
                      _followed?"Unfollow":"Follow",
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
/// a function that displays a toast message for the user
void _showToast(final BuildContext context, final String msg) {
  final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: navy,
      action: SnackBarAction(label: "Got it!",
          textColor: floatingButtonColor,
          onPressed: scaffold.hideCurrentSnackBar,),
    ),
  );
}
