import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  final int number;
  final String text;

  NumberTriviaModel({@required this.number, @required this.text})
      : super(number: number, text: text);

  NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap)
      : number = (jsonMap["number"] as num).toInt(),
        text = jsonMap["text"];

  Map<String, dynamic> toJson() => {
        "number": number,
        "text": text,
      };
}
