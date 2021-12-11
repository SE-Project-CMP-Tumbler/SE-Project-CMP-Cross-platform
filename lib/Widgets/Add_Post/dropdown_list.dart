import "package:flutter/material.dart";
import "package:tumbler/Models/user.dart";

/// DropDownMenu for the profiles in
/// Add post Page
class ProfilesList extends StatefulWidget {
  /// Constructor
  const ProfilesList({final Key? key}) : super(key: key);

  @override
  _ProfilesListState createState() => _ProfilesListState();
}

/// this menu from which the user can choose which profile the current post
/// will be published in
class _ProfilesListState extends State<ProfilesList> {
  @override
  Widget build(final BuildContext context) {
    final List<String> blogs = User.blogsNames.toSet().toList();
    String dropdownValue = User.blogsNames[User.currentProfile];
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      onChanged: (final String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          User.currentProfile = User.blogsNames.indexOf(newValue);
        });
      },
      items: blogs.map<DropdownMenuItem<String>>((final String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
