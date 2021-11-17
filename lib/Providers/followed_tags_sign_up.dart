import 'package:flutter/material.dart';

class FollowedTags with ChangeNotifier {
  //Set<String> _followedTags;

  //Set<String> get followedTags => _followedTags;

  FollowedTags() {
    return _followedTags = {};
  }

  void addFollowTag(String tag) {
    if (tag != null && tag.isNotEmpty) {
      _followedTags.add(tag);
      notifyListeners();
    }
  }

  void removeFollowTag(String tag) {
    if (tag != null && tag.isNotEmpty) {
      _followedTags.remove(tag);
      notifyListeners();
    }
  }

}
