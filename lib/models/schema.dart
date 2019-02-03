part of '../main.dart';

class Lesson {
  final String name;

  Lesson(
    @required this.name,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
  };
}

class Bullet {
  final String text;

  Bullet(
      @required this.text,
      );

  Map<String, dynamic> toJson() => {
    'text': text,
    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
  };
}