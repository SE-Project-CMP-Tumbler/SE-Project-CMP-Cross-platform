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

  /// Number to Show in the Tab
  final int number;

  /// Icon to Show in the Tab
  final IconData iconType;

  /// Color of the Tab
  final Color color;

  /// Current Index chose
  final int? currIndex;

  /// The Index of this Tab
  final int myIndex;

  /// Formatter for [number]
  final NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

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
