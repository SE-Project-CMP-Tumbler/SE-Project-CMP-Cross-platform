import "package:flutter/foundation.dart" show kIsWeb;

import "package:flutter/material.dart";
import "package:random_color/random_color.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Search/tag_posts.dart";
/// for check out tags section
class CheckOutTagComponent extends StatefulWidget {
  /// Constructor: takes the [Tag] data, the random background color,
  /// and a boolean to indicate if the [User] follow this [Tag] or not
  const CheckOutTagComponent({
    required final double width,
    required final this.tag,
    required final this.color,
    required final this.isFollowed,

    final Key? key,
  }) : _width = width, super(key: key);

  final double _width;
  /// the tag to be displayed in the component
  final Tag tag;
  /// main color of the component
  final Color color;
  /// indicates whether this tag is followed or not
  final bool isFollowed;
  @override
  State<CheckOutTagComponent> createState() => _CheckOutTagComponentState();
}

class _CheckOutTagComponentState extends State<CheckOutTagComponent> {
  /// to indicate whether the user successfully followed this tag or not
  bool _followed=false;


  /// to indicate a loading of a post or delete tag request
  bool _proceedingFollowing=false;
  @override
  void initState() {
    setState(() {
      _followed= widget.isFollowed;
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final double _height= MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
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
          width: kIsWeb?150:0.38*widget._width,
          height: kIsWeb?200:0.2*_height,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius:
            const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color:Color.fromRGBO(widget.color.red+30>0?widget.color.red+30:
              widget.color.red,
                  widget.color.green+30<255?widget.color.green+30:
                  widget.color.green,
                  widget.color.blue+30<255?widget.color.blue+30:
                  widget.color.blue
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
                    overflow: TextOverflow.ellipsis,
                    style:TextStyle(
                      color: widget.color.computeLuminance()>0.5?
                      Colors.black:Colors.white,
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
                            widget.tag.tagImgUrl!.isNotEmpty?
                            widget.tag.tagImgUrl!:
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
                            widget.tag.tagImgUrl!.isNotEmpty?
                            widget.tag.tagImgUrl!
                                :
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
                        showSnackBar(context, "Great!, you are now following "
                        "all about #${widget.tag.tagDescription}",);
                        if(mounted)
                        setState(() {
                        _followed = true;
                        });
                        }
                        else{
                        showSnackBar(context, "OOPS, something went wrong 😢");
                        }
                        }
                        }
                        else{
                            // ignore: invariant_booleans
                            if (widget.tag.tagDescription!=null) {
                            final bool succeeded= await
                            unFollowTag(widget.tag.tagDescription!);
                            if(succeeded) {
                            showSnackBar(context, "Don't worry, u won't be"
                            " bothered by this tag again",);
                            if(mounted)
                            setState(() {
                            _followed = false;
                            });}
                            else{
                            showSnackBar(context, "OOPS, something went wrong 😢");
                            }
                        }}
                        if(mounted)
                        setState(() {
                          _proceedingFollowing=false;
                        });
                        },

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
      ),
    );
  }

}
/// a function that displays a toast message for the user
void showSnackBar(final BuildContext context, final String msg) {
  final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xff2fea34),
      action: SnackBarAction(label: "Got it!",
          textColor: navy,
          onPressed: scaffold.hideCurrentSnackBar,),
    ),
  );
}
