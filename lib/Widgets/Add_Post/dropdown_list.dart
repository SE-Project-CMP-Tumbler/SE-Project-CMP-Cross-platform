import "package:flutter/material.dart";
import "package:tumbler/Models/user.dart";

class ProfilesList extends StatefulWidget {
  const ProfilesList({Key? key}) : super(key: key);

  @override
  _ProfilesListState createState() => _ProfilesListState();
}

class _ProfilesListState extends State<ProfilesList> {
  List<String> s = User.profilesNames;
  String dropdownValue = User.profilesNames[User.currentProfile];
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      //icon: const Icon(Icons.d),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      /* underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          User.currentProfile = User.profilesNames.indexOf(newValue);
          print(User.currentProfile);
        });
      },
      items: s.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
