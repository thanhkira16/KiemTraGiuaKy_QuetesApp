import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/note.dart';

class QuoteService {
  static const String baseUrl = 'https://zenquotes.io/api';

  /// Lấy 1 quote ngẫu nhiên
  /// GET /random
  static Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/random'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final quote = data[0];
          return Quote(
            id: '${DateTime.now().millisecondsSinceEpoch}',
            text: quote['q'] ?? 'No content',
            author: quote['a']?.replaceAll(RegExp(r',\s*'), '') ?? 'Unknown',
          );
        }
        throw Exception('Empty response');
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching random quote: $e');
    }
  }

  /// Lấy quote của ngày
  /// GET /today
  static Future<Quote> fetchTodayQuote() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/today'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final quote = data[0];
          return Quote(
            id: 'today_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}',
            text: quote['q'] ?? 'No content',
            author: quote['a']?.replaceAll(RegExp(r',\s*'), '') ?? 'Unknown',
          );
        }
        throw Exception('Empty response');
      } else {
        throw Exception('Failed to load today quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching today quote: $e');
    }
  }

  /// Lấy danh sách 50 quote ngẫu nhiên
  /// GET /quotes
  static Future<List<Quote>> fetchAllQuotes() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/quotes'))
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isEmpty) {
          throw Exception('Empty response');
        }

        final quotes = data.asMap().entries.map((entry) {
          final quote = entry.value;
          return Quote(
            id: '${entry.key}_${DateTime.now().millisecondsSinceEpoch}',
            text: quote['q'] ?? 'No content',
            author: quote['a']?.replaceAll(RegExp(r',\s*'), '') ?? 'Unknown',
          );
        }).toList();

        return quotes;
      } else {
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all quotes: $e');
    }
  }

  /// Lấy quote từ một tác giả cụ thể
  static Future<List<Quote>> fetchQuotesByAuthor(String author) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/quotes?author=$author'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final quotes = data.map((quote) {
          return Quote(
            id: '${DateTime.now().millisecondsSinceEpoch}_${quote.hashCode}',
            text: quote['q'] ?? 'No content',
            author: quote['a']?.replaceAll(RegExp(r',\s*'), '') ?? 'Unknown',
          );
        }).toList();
        return quotes;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quotes by author: $e');
    }
  }
}
