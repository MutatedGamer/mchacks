part of './main.dart';

void createLesson(String uid, Lesson lesson) {
  CollectionReference lessons = Firestore.instance.collection('users')
          .document(uid)
          .collection('lessons');
  Firestore.instance.runTransaction((Transaction tx) async {
    var _result = await lessons.add(lesson.toJson());
  });
}

void deleteLesson(String uid, String lesson_id) {
  Firestore.instance.collection('users')
        .document(uid)
        .collection('lessons')
        .document(lesson_id)
        .delete();
}

void createBullet(String uid, String lesson_id, Bullet bullet ) async {
  CollectionReference lessons = Firestore.instance.collection('users')
      .document(uid)
      .collection('lessons')
      .document(lesson_id)
      .collection('regular_input');
  Firestore.instance.runTransaction((Transaction tx) async {
    var _result = await lessons.add(bullet.toJson());
  });
  final keyword = await Watson.getShortestKeyword(bullet.text);
  final fillInTheBlank = Watson.createFillInTheBlankAsString(bullet.text, keyword);
  Study study = new Study(keyword, fillInTheBlank);

  CollectionReference study_lessons = Firestore.instance.collection('users')
      .document(uid)
      .collection('lessons')
      .document(lesson_id)
      .collection('study_questions');
  Firestore.instance.runTransaction((Transaction tx) async {
    var _result = await study_lessons.add(study.toJson());
  });

}