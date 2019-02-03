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

void createBullet(String uid, String lesson_id, Bullet bullet ) {
  CollectionReference lessons = Firestore.instance.collection('users')
      .document(uid)
      .collection('lessons')
      .document(lesson_id)
      .collection('regular_input');
  Firestore.instance.runTransaction((Transaction tx) async {
    var _result = await lessons.add(bullet.toJson());
  });
}