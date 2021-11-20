import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tumbler/Screens/Settings/profile_settings.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int currentTab=0;
  final greenKey =  GlobalKey();
  final blueKey =  GlobalKey();
  final orangeKey =  GlobalKey();
  final yellowKey =  GlobalKey();
  final purpleKey =  GlobalKey();
  List<String> _tumblers = ["Donia Esawi", "Regina Phalange", "Princess Consuella BananaHammok", "Create a new tumblr"];
  List<String> _tumblersProfilePics = ["intro_3.jpg", "intro_4.jpg", "intro_4.jpg", "create_tumblr.png"];
  int currentOption=0;
  int themeColor=0xff001935;
  int themeTitleColor=0xffffffff;
  String? _selectedTumbler= "Donia Esawi";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          ));

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController!.dispose();
    SystemChrome.restoreSystemUIOverlays();

  }
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double _width = MediaQuery.of(context).size.width;
    int _value = 1;
    return Scaffold(
      body: Container(
        color: Color(themeColor),
        child: CustomScrollView(
          slivers:  <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 0.35*_height,
                    decoration:const  BoxDecoration(
                      image:  DecorationImage(
                        image:  ExactAssetImage('assets/images/intro_3.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          top: 0.35*_height- 0.085*_height,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Color(themeColor),
                            height: 0.8* _height,
                          ),
                        ),
                        Positioned(
                          bottom: 0.085* _height - 25,
                          child: Container(
                          height: 100,
                          width: 100,
                          decoration:  BoxDecoration(
                            color: Color(themeColor),
                            shape: BoxShape.circle, //editable
                            border: Border.all(width: 3.0,color: Color(themeColor))
                          ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(50)), //editable
                                child: Image.asset('assets/images/intro_3.jpg',fit: BoxFit.cover,)),
                        )),
                        Text('Untitled', textScaleFactor: 2.4,style: TextStyle(fontWeight: FontWeight.w500, color: Color(themeTitleColor)),),
                        Positioned(top: 0,left:0,right:0,child:
                        SafeArea(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  width: _width/2,
                                  child: DropdownButton<String>(
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTumbler = value;

                                    });
                                    },
                                  value: _selectedTumbler,
                                  // Hide the default underline
                                  underline: Container(height: 0,),
                                  icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: Colors.white,
                                  ),
                                  isExpanded: true,
                                  // The list of options
                                  items: _tumblers
                                    .map((e) => DropdownMenuItem(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset('assets/images/${_tumblersProfilePics[_tumblers.indexOf(e)]}',width: 35,height: 35,),
                                            const SizedBox(width: 10,),
                                            Expanded(child: Text(e,overflow: TextOverflow.ellipsis,)),
                                          ],
                                        ),
                                        if (_tumblers.indexOf(e)!=3) Expanded(child: Divider(thickness: 1.0,color: Colors.grey.shade200,height: 0,)) else Container()
                                      ],
                                    ),
                                  ),
                                  value: e,
                                   ))
                                    .toList(),

                                    // Customize the selected item
                                  selectedItemBuilder: (BuildContext context) => _tumblers
                                    .map((e) => Align(
                                    alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                        e,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            ),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                  ),
                                      ),
                                    ))
                                    .toList(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  type: MaterialType.transparency,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    icon:Icon(Icons.search_outlined, color: Colors.white),
                                    onPressed: (){},
                                    splashColor: Colors.white10,

                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  type: MaterialType.transparency,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    icon:Icon(Icons.color_lens, color: Colors.white),
                                    onPressed: (){},
                                    splashColor: Colors.white10,

                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  type: MaterialType.transparency,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    icon:Icon(Icons.share, color: Colors.white),
                                    onPressed: (){},
                                    splashColor: Colors.white10,

                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  type: MaterialType.transparency,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    icon:Icon(Icons.settings,size: 25, color: Colors.white),
                                    onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const ProfileSettings()));
                                    },
                                    splashColor: Colors.white10,

                                  ),
                                ),
                              ),


                          ],),
                        )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            makeTabBarHeader(),
            SliverList(
              delegate: SliverChildListDelegate(
                //posts
                [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    key: greenKey,
                    height: 1800,
                    color: Colors.white,
                  ),
                ),
                Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  key: purpleKey,
                  height: 1800,
                  color: Colors.white,
                ),
              ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
  SliverPersistentHeader makeTabBarHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 70.0,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          color: Color(themeColor),
          child: TabBar(
            onTap: (val) {
              setState(() {
                currentTab=val;
              });
            },
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 2.0,
            labelColor: Colors.white,
            controller: tabController,
            tabs: const <Widget>[
               Tab(
                child: Text(
                  "Posts",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
               Tab(
                child: Text(
                  "Likes",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
               Tab(
                child: Text(
                  "Following",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
    );
  }
}
class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return  SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

