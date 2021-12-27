import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/material.dart";
import "package:flutter_html/shims/dart_ui_real.dart";
import "package:google_fonts/google_fonts.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/search_utils.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Screens/Search/search_result.dart";
/// The page that enables user to enter a search keyword
class SearchQuery extends StatefulWidget {
  /// constructor
  const SearchQuery(
      {required final this.recommendedTags,
      final Key? key,})
      : super(key: key);
  /// suggested words to search about (taken from suggested tags)
  final List<Tag> recommendedTags;
  @override
  State<SearchQuery> createState() => _SearchQueryState();
}

class _SearchQueryState extends State<SearchQuery> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController= TextEditingController();
  }
  ///

  bool _isTyping= false;
  bool _startedSearching= false;
  List<String> autoCompWords=<String>[];
  List<List<dynamic>> searchResults=<List<dynamic>>[];
  List<PostModel> postsRes=<PostModel>[];
  List<Tag> tagRes= <Tag>[];
  List<Blog> blogResults=<Blog>[];
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: // Next, create a SliverList
        Center(
          child: Container(
            width: kIsWeb?500:null,
            color: Colors.white,
            child: Center(
              child: CustomScrollView(
                slivers:<Widget> [
                  // Add the app bar to the CustomScrollView.
                  SliverAppBar(

                    pinned: true,
                    // Display a placeholder widget to visualize the shrinking size.
                    flexibleSpace: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border(bottom:BorderSide(
                            color: Colors.grey.shade200,),)
                      ,),
                      child: Padding(
                        padding: const EdgeInsets.only
                          (left:100, top: 15, bottom: 10),
                        child: TextField(
                            onTap: (){
                              if(mounted)
                                setState(() {
                                _isTyping=true;
                              });
                            },
                            onChanged: (final String value)async{
                              if (value.isNotEmpty) {

                                setState(() {
                                  _startedSearching=true;
                                });
                                final List<String> res=
                                await getAutoComplete(value);
                                if(mounted)
                                  setState(() {
                                  autoCompWords= res;
                                });
                                searchResults= await getSearchResults(value);
                                if(mounted)
                                  setState(() {
                                  postsRes= searchResults[0] as List<PostModel>;
                                  tagRes= searchResults[1] as List<Tag>;
                                  blogResults= searchResults[2] as List<Blog>;
                                });


                              }
                              else{
                                if(mounted)
                                  setState(() {
                                  _startedSearching=false;
                                });
                              }
                            },
                            onSubmitted: (final String value)async{
                              setState(() {
                                _isTyping=false;
                              });
                              await Navigator.pushReplacement(context,
                                MaterialPageRoute<SearchResult>(
                                builder: (final BuildContext context) =>
                                    SearchResult(word:
                                    _textEditingController.text,),
                              ),
                              );
                            },
                          textAlign: TextAlign.justify,
                            controller: _textEditingController,
                            style: const TextStyle(fontSize: 18),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintMaxLines: 1,
                              alignLabelWithHint: true,
                              hintText: "Search Tumbler",
                              hintStyle:const TextStyle(fontSize: 18),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,),),
                              disabledBorder:  const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,),),
                              focusedBorder:  const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,),),
                              isDense: true,
                              isCollapsed: true,
                              suffixIcon:_isTyping? TextButton(
                                onPressed: (){
                                  _textEditingController.clear();
                                  setState(() {
                                    autoCompWords=<String>[];
                                    _startedSearching=false;

                                  });
                                  }
                                  ,
                                  child: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 25,),
                                  ):const SizedBox(width: 25,),
                                  ),
                            cursorHeight: 24,
                            cursorColor: floatingButtonColor,

                            ),
                            ),
                            ),
                            elevation: 0,
                            toolbarHeight: 70,
                            expandedHeight: 70,
                            collapsedHeight: 70,
                            leading: TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back,
                              color: Colors.grey.shade700,),
                    ),
                      backgroundColor: Colors.white,
                  ),
                  // Next, create a SliverList
                  SliverList(
                    delegate: SliverChildListDelegate(
                   !_startedSearching? <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20,
                            bottom: 20,
                            top: 20,),
                        child: Text("Recommended",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),),) ,
                      Column(
                        children: widget.recommendedTags.map((final Tag tag) =>
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context,
                                    MaterialPageRoute<SearchResult>(
                                      builder:
                                          (final BuildContext context)
                                      => SearchResult(word:
                                      tag.tagDescription!,),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(Icons.search,
                                    size: 28,
                                    color: Colors.grey.shade400,),
                                  title: Text(tag.tagDescription!),),
                              ),
                            ), ).toList(),
                      ),
                                ]
                  : <Widget>[
                         /// if clicked, fetch the posts of that specific tag
                         Material(
                           color: Colors.white,
                           child: InkWell(
                             splashColor: Colors.grey,
                             child: ListTile(
                               onTap: (){},
                               title: Row(
                                 children: <Widget>[
                                   const Text("Go To #",style: TextStyle(
                               fontFamily: "fav",),),
                                   Text(_textEditingController.value.text,
                                   style: TextStyle(color: floatingButtonColor,
                                   fontFamily: "fav",),
                                   )
                                 ],
                               ),),
                           ),
                         ),
                         const Divider(thickness: 0.5,height: 0,),
                         Column(
                             children:
                             autoCompWords.map((final String word) =>
                                 Material(
                                   color: Colors.white,
                                   child: InkWell(
                                     onTap: (){
                                       Navigator.pushReplacement(context,
                                         MaterialPageRoute<SearchResult>(
                                           builder:
                                           (final BuildContext context)
                                           => SearchResult(word:
                                           word,),
                                         ),
                                       );
                                     },
                                     child: ListTile(
                                       leading: Icon(Icons.search,
                                         size: 28,
                                         color: Colors.grey.shade400,),
                                       title: Text(word),),
                                   ),
                                 ),).toList(),
                           ),
                        const Divider(thickness: 0.5,height: 0,),
                         /// tumblers
                         Padding(
                           padding: const EdgeInsets.only
                             (left: 8 ,right: 8, top: 8),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Padding(
                                 padding: const EdgeInsets.only
                                   (left: 16 ,right: 16, top: 16, bottom: 8),
                                 child: Text("Tumblers",style: TextStyle(
                                   fontWeight: FontWeight.w500,
                                   color: Colors.grey.shade700,
                                   fontFamily: "fav",
                                 ),),
                               ),
                               /// If clicked then get that
                               /// specific blog and show it,
                               /// show error toast if not found
                               Material(
                                 color: Colors.white,
                                 child: InkWell(
                                   onTap: (){},
                                   child: ListTile(
                                     title: Row(
                                       children: <Widget>[
                                         const Text("Go To @",style: TextStyle(
                                           fontFamily: "fav",),),
                                         Text(_textEditingController.value.text,
                                           style:
                                           TextStyle(color: floatingButtonColor,
                                             fontFamily: "fav",),
                                         ),
                                       ],
                                     ),

                                   ),
                                 ),
                               ),
                               /// List of search results (blogs)
                               Column(
                                 children:blogResults.map((final Blog blog) =>
                                     ListTile(
                                   title: Text(blog.username!),
                                   leading: Image.network(blog.avatarImageUrl??
                                       tumblerImgUrl,
                                     errorBuilder: (
                                         final BuildContext context,
                                         final Object exception,
                                         final StackTrace? stackTrace,){
                                       return Image.network(
                                         tumblerImgUrl,
                                         height: 40,
                                         width: 40,
                                         fit: BoxFit.fill,);
                                     },
                                     height: 40,
                                     width: 40,
                                     fit: BoxFit.fill,
                                   ),
                                   trailing:
// TODO(DONIA): remove this if the blog is followed by the current user
                                   TextButton(child:
                                   Text("FOLLOW", style: GoogleFonts.
                                   montserrat(textStyle:  TextStyle(
                                     color: floatingButtonColor,
                                     fontWeight: FontWeight.w300,
                                   ),),
                                     textScaleFactor: 1.1,),

                                     onPressed: (){},
                                   ),
                                 )).toList()
                                   ,

                               )
                             ],
                           ),
                         ),

                   ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
