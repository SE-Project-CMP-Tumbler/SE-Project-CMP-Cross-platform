import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";

/// Widget for th Text Field in the Notes Page
class ReplyTextField extends StatelessWidget {
  /// Constructor
  const ReplyTextField({
    required final this.replyController,
    required final this.postId,
    required final this.refresh,
    final Key? key,
  }) : super(key: key);

  /// Controller of the Text Field
  final TextEditingController replyController;

  /// Post ID of the current Note Page have
  final String postId;

  /// Function to refresh the Notes count of the post
  final Function refresh;

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
                await refresh();
              } else {
                await showToast(response["meta"]["msg"]);
              }
              replyController.clear();
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
