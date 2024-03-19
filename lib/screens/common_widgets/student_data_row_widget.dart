import 'package:database_practice/screens/common_widgets/text_widget_common.dart';
import 'package:database_practice/utils/colors.dart';
import 'package:flutter/material.dart';

class StudentDataRowWidget extends StatelessWidget {
  const StudentDataRowWidget({
    super.key,
    required this.text,
    required this.fieldName,
  });

  final String text;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kWhite,
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 4),
              color: Color.fromARGB(143, 177, 177, 177),
            )
          ]),
      child: ListTile(
        leading: TextWidgetCommon(
          fontSize: 20,
          text: '$fieldName:',
          fontWeight: FontWeight.bold,
          color: kBlack,
        ),
        trailing: TextWidgetCommon(
          text: text,
          color: kBlack,
          fontSize: 20,
        ),
      ),
    );
  }
}