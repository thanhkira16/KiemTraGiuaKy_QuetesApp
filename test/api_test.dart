import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('ZenQuotes API Tests', () {
    test('Test /random endpoint', () async {
      // Test ZenQuotes API random endpoint
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/random'))
          .timeout(const Duration(seconds: 10));

      expect(response.statusCode, 200);

      final data = jsonDecode(response.body) as List;
      expect(data.isNotEmpty, true);

      final quote = data[0];
      expect(quote['q'], isNotNull); // Quote text
      expect(quote['a'], isNotNull); // Author

      print('✅ Random Quote API Test Passed');
      print('Quote: ${quote['q']}');
      print('Author: ${quote['a']}');
    });

    test('Test /today endpoint', () async {
      // Test ZenQuotes API today endpoint
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/today'))
          .timeout(const Duration(seconds: 10));

      expect(response.statusCode, 200);

      final data = jsonDecode(response.body) as List;
      expect(data.isNotEmpty, true);

      final quote = data[0];
      expect(quote['q'], isNotNull);
      expect(quote['a'], isNotNull);

      print('✅ Today Quote API Test Passed');
      print('Today Quote: ${quote['q']}');
      print('Author: ${quote['a']}');
    });

    test('Test /quotes endpoint', () async {
      // Test ZenQuotes API quotes endpoint
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/quotes'))
          .timeout(const Duration(seconds: 15));

      expect(response.statusCode, 200);

      final data = jsonDecode(response.body) as List;
      expect(data.length, 50); // Should return 50 quotes

      // Check first quote structure
      final quote = data[0];
      expect(quote['q'], isNotNull);
      expect(quote['a'], isNotNull);

      print('✅ Quotes List API Test Passed');
      print('Total quotes received: ${data.length}');
      print('First quote: ${quote['q']} - ${quote['a']}');
    });
  });
}
