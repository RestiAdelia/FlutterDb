class Note {
  final int? id;
  final String title;
  final String content;
  final String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? date,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        date: date ?? this.date,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'],
      content: map['content'],
      date: map['date'],
    );
  }
}
