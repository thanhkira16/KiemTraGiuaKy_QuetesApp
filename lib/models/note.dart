class Quote {
  final String id;
  final String text;
  final String author;
  bool isFavorite;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    this.isFavorite = false,
  });

  // Convert Quote to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'author': author, 'isFavorite': isFavorite};
  }

  // Create Quote from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  // Copy with method
  Quote copyWith({bool? isFavorite}) {
    return Quote(
      id: id,
      text: text,
      author: author,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
