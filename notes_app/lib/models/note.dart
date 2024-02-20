class Note {
  final int? id;
  final String title;
  final String content;

  Note({this.id, required this.title, required this.content});

  // Convert a Note object into a map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Implement fromMap constructor to convert a map into a Note object.
  // This is used to convert database query results back into a Note object.
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
