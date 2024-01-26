import 'package:flutter/material.dart';
import 'package:tokyu_envy_report/etc/style.dart';

class AxisWidget extends StatelessWidget {
  final String topTitle;
  final double topTitleFontSize;
  final String leftTitle;
  final double leftTitleFontSize;
  final String rightTitle;
  final double rightTitleFontSize;
  final String topVisitorCountNumber;
  final String topVisitorCountText;
  final String leftVisitorCountNumber;
  final String leftVisitorCountText;
  final String rightVisitorCountNumber;
  final String rightVisitorCountText;

  const AxisWidget(
      {super.key,
      required this.topTitle,
      this.topTitleFontSize = 16,
      required this.leftTitle,
      this.leftTitleFontSize = 12,
      required this.rightTitle,
      this.rightTitleFontSize = 12,
      required this.topVisitorCountNumber,
      required this.topVisitorCountText,
      required this.leftVisitorCountNumber,
      required this.leftVisitorCountText,
      required this.rightVisitorCountNumber,
      required this.rightVisitorCountText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = Style.of(context);

    return Container(
      height: 180,
      width: 200,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(topTitle, style: TextStyle(fontSize: topTitleFontSize)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(topVisitorCountNumber, style: style.visitorCountLarge),
              const SizedBox(width: 2),
              Text(topVisitorCountText, style: style.visitorCountText)
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
            child: const Divider(height: 2),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    leftTitle,
                    style: TextStyle(fontSize: leftTitleFontSize),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(leftVisitorCountNumber, style: style.visitorCountSmall),
                      const SizedBox(width: 2),
                      Text(leftVisitorCountText, style: style.visitorCountText),
                    ],
                  )
                ],
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                color: Colors.white.withOpacity(0.7),
                child: const VerticalDivider(width: 2),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    rightTitle,
                    style: TextStyle(fontSize: rightTitleFontSize),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(rightVisitorCountNumber, style: style.visitorCountSmall),
                      const SizedBox(width: 2),
                      Text(rightVisitorCountText, style: style.visitorCountText),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
