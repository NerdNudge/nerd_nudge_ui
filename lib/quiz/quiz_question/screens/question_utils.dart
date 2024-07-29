class QuestionUtils {
  static bool isAnswerCorrect(var completeQuiz, bool didTimerEnd) {
    if(didTimerEnd)
      return false;

    if(completeQuiz['selected_answers'].toString().isEmpty)
      return false;

    if(completeQuiz['selected_answers'][0] == completeQuiz['right_answer'])
      return true;

    return false;
  }
}