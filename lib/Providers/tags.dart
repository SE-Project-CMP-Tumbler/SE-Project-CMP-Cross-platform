import "dart:convert";

import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/tag.dart";
/// to provide the tags to the search page

class Tags with ChangeNotifier {
  final List<Tag> _followedTags = <Tag>[];
  /// Returns all followed tags
  List<Tag> get followedTags {
    return <Tag>[..._followedTags];
  }

  /// fetch tags through http get request.

  Future<void> fetchAndSetFollowedTags() async {

    /// clear all loaded post.



    final dynamic res = await Api().fetchTagsFollowed();
    final Map<String, dynamic> encodedRes = jsonDecode(res.body);

    /// checking the status code of the received response.
    if (res.statusCode != 200)
      throw HttpException(encodedRes["meta"]["msg"]);
    _followedTags.clear();

    /// set _followedTags list.
    final List<dynamic> tagsList = encodedRes["response"]["tags"];
    for (int i = 0; i < tagsList.length; i++) {
      _followedTags.add(
        Tag(
            tagDescription:
            tagsList[i]["tag_description"],
            tagImgUrl:
            tagsList[i]["tag_image"],
        ),
      );
    }

    notifyListeners();

  }



}
