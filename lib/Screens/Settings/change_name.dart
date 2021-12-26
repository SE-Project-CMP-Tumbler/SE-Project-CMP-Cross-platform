import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";

/// Change Name Page
class ChangeName extends StatefulWidget {
  /// Constructor
  const ChangeName({final Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final TextEditingController _nameController = TextEditingController();
  bool canChange = false;
  String validatorText = "";
  Color validatorColor = Colors.black;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool canChangeName(final String name) {
    // TODO(Ziyad): Check the ability to change the name
    // this should be from an endpoint
    // but there is not endpoint for that
    return true;
  }

  void checkName(final String name) {
    if (name.isEmpty) {
      setState(() {
        validatorText = "";
        validatorColor = Colors.black;
        canChange = false;
      });
      return;
    }

    if (canChangeName(name)) {
      setState(() {
        validatorText = "Yes! That's very \"you\".";
        validatorColor = Colors.green;
        canChange = true;
      });
    } else {
      setState(() {
        validatorText = "That's a good name, but it's taken";
        validatorColor = Colors.red;
        canChange = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        leadingWidth: 70,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white60,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (canChange) {
                // TODO(Ziyad): Make the Request
                // make request to change the name
                // but there is no endpoint to that
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 15,
                    color: (_nameController.text.isEmpty)
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "What do you want to be called?",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextField(
              onChanged: checkName,
              controller: _nameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: validatorColor),
                ),
                focusedBorder: const UnderlineInputBorder(),
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: "name",
                suffixIcon: _nameController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _nameController.clear();
                          validatorText = "";
                          validatorColor = Colors.black;
                          canChange = false;
                        }),
                        color: Colors.white30,
                      )
                    : null,
              ),
            ),
          ),
          Text(
            validatorText,
            style: TextStyle(color: validatorColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
