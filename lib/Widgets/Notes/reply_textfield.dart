import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";

///
class ReplyTextField extends StatelessWidget {
  ///
  const ReplyTextField({
    required final this.replyController,
    required final this.postId,
    required final this.refresh,
    required final this.index,
    final Key? key,
  }) : super(key: key);

  ///
  final TextEditingController replyController;

  ///
  final String postId;

  ///
  final Function refresh;

  ///
  final int index;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: TextField(
            controller: replyController,
            decoration: const InputDecoration(
              hintText: "Unleash a compliment...",
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton(
          onPressed: () async {
            if (replyController.text.isNotEmpty) {
              final dynamic response =
                  await Api().replyOnPost(postId, replyController.text);
              if (response["meta"]["status"] == "200") {
                // call function refresh in the NotesPage widget to fetch new
                //replies and setState()
                //update number of notes locally....
                replyController.clear();
                homePosts[index].notes++;
                await refresh();
              } else {
                // show toast ? to say retry again late
                replyController.clear();
                await showToast("Failed operation, try again later");
              }
            }
          },
          child: Text(
            "Reply",
            style: TextStyle(
              color:
                  (replyController.text.isNotEmpty) ? Colors.blue : Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
