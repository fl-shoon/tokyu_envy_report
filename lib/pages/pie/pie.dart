import 'package:flutter/material.dart';
import 'package:tokyu_envy_report/etc/define.dart';
import 'package:tokyu_envy_report/pages/graph/survey/question.dart';
import 'package:tokyu_envy_report/state/state_model.dart';

class SurveyPieWidget extends StatelessWidget {
  final List<Visitor> visitors;
  final double width;
  const SurveyPieWidget({super.key, required this.visitors, required this.width});

  @override
  Widget build(BuildContext context) {
    final check = visitors.first.afterAnswers.length == questions.length;

    if (!check) {
      return Container();
    }

    if (width < 480) {
      return Column(
        children: questions
            .map((question) => SurveyQuestionPieChart(
                  visitors: visitors,
                  title: '質問${questions.indexOf(question) + 1}',
                  questionIndex: questions.indexOf(question),
                  width: width,
                ))
            .toList(),
      );
    }

    return Column(
      children: questions
          .where((question) =>
              (questions.indexOf(question) % 2 == 0) ||
              (questions.indexOf(question) + 1).isOdd && (questions.indexOf(question) + 1 == questions.length))
          .map((question) {
        if ((questions.indexOf(question) % 2) == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SurveyQuestionPieChart(
                visitors: visitors,
                title: '質問${questions.indexOf(question) + 1}',
                questionIndex: questions.indexOf(question),
                width: width / 3,
              ),
              SurveyQuestionPieChart(
                visitors: visitors,
                title: '質問${questions.indexOf(question) + 2}',
                questionIndex: questions.indexOf(question) + 1,
                width: width / 3,
              ),
            ],
          );
        } else {
          return SurveyQuestionPieChart(
            visitors: visitors,
            title: '質問${questions.indexOf(question) + 1}',
            questionIndex: questions.indexOf(question),
            width: width / 3,
          );
        }
      }).toList(),
    );
  }
}
