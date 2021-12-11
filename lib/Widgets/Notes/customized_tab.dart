// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import "package:intl/intl.dart";

///[CustomizedTab] customizes tabs in tab view
class CustomizedTab extends StatelessWidget {
  /// takes number, iconType, color, currIndex and myIndex
  CustomizedTab({
    required final this.number,
    required final this.iconType,
    required final this.color,
    required final this.currIndex,
    required final this.myIndex,
    final Key? key,
  }) : super(key: key);

  ///
  final int number;

  ///
  final IconData iconType;

  ///
  final Color color;

  ///
  final int? currIndex;

  ///
  final int myIndex;

  ///
  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconType,
              color: (currIndex == myIndex) ? color : Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              numFormatter.format(number),
              style: TextStyle(
                color:
                    (currIndex == myIndex) ? color.withOpacity(1) : Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
