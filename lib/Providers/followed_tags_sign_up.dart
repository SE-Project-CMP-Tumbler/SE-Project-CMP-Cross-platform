import "package:flutter/material.dart";

/// Provider used for [TagSelect] Page
class FollowedTags with ChangeNotifier {
  final Set<String> _followedTags = <String>{};

  /// Getter for private Set [_followedTags]
  /// for the followed tags from [tagsNames]
  Set<String> get followedTags => _followedTags;

  /// Add [tag] to the [_followedTags].
  void addFollowTag(final String tag) {
    if (tag.isNotEmpty) {
      _followedTags.add(tag);
      notifyListeners();
    }
  }

  /// Remove [tag] to the [_followedTags].
  void removeFollowTag(final String tag) {
    if (tag.isNotEmpty) {
      _followedTags.remove(tag);
      notifyListeners();
    }
  }
}
