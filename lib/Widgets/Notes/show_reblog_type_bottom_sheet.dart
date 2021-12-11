// ignore_for_file: public_member_api_docs

import "package:flutter/material.dart";

enum blogsType {
  withComments,
  others,
}

void showReblogsCategoriesBottomSheet(
  final BuildContext ctx,
  final int currType,
  final Function changeBlogViewSection,
) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: ctx,
    builder: (final _) {
      return Container(
        height: 150,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  if (currType != blogsType.withComments.index) {
                    changeBlogViewSection(blogsType.withComments);
                  }
                  Navigator.pop(ctx);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        "Reblogs with comments",
                        style: TextStyle(
                          color: (currType == blogsType.withComments.index)
                              ? Colors.blue
                              : Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const FittedBox(
                      child: Text(
                        "Show reblogs with added comments and/or tags",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  if (currType != blogsType.others.index) {
                    changeBlogViewSection(blogsType.others);
                  }
                  Navigator.pop(ctx);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        "Other reblogs",
                        style: TextStyle(
                          color: (currType == blogsType.others.index)
                              ? Colors.blue
                              : Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const FittedBox(
                      child: Text(
                        "Show empty reblogs",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
