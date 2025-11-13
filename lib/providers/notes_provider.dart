import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/quote_service.dart';

class QuotesProvider extends ChangeNotifier {
  final List<Quote> _quotes = [];
  Quote? _currentQuote;
  bool _isLoading = false;
  String? _lastError;

  // Sample quotes data - Fallback nếu API fail
  static final List<Quote> _sampleQuotes = [
    Quote(
      id: '1',
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
    ),
    Quote(
      id: '2',
      text: 'Life is what happens when you\'re busy making other plans.',
      author: 'John Lennon',
    ),
    Quote(
      id: '3',
      text:
          'The future belongs to those who believe in the beauty of their dreams.',
      author: 'Eleanor Roosevelt',
    ),
    Quote(
      id: '4',
      text:
          'It is during our darkest moments that we must focus to see the light.',
      author: 'Aristotle',
    ),
    Quote(
      id: '5',
      text: 'The only impossible journey is the one you never begin.',
      author: 'Tony Robbins',
    ),
    Quote(
      id: '6',
      text:
          'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
    ),
    Quote(
      id: '7',
      text: 'The way to get started is to quit talking and begin doing.',
      author: 'Walt Disney',
    ),
    Quote(
      id: '8',
      text: 'Innovation distinguishes between a leader and a follower.',
      author: 'Steve Jobs',
    ),
    Quote(
      id: '9',
      text:
          'Your time is limited, don\'t waste it living someone else\'s life.',
      author: 'Steve Jobs',
    ),
    Quote(
      id: '10',
      text: 'Be yourself; everyone else is already taken.',
      author: 'Oscar Wilde',
    ),
  ];

  // Getters
  List<Quote> get quotes => List.unmodifiable(_quotes);
  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  List<Quote> get favoriteQuotes => _quotes.where((q) => q.isFavorite).toList();
  int get favoritesCount => favoriteQuotes.length;
  String? get lastError => _lastError;

  QuotesProvider() {
    _initializeQuotes();
  }

  /// Initialize quotes from ZenQuotes API
  Future<void> _initializeQuotes() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      // Fetch all quotes từ API
      final apiQuotes = await QuoteService.fetchAllQuotes();
      _quotes.addAll(apiQuotes);

      // Load favorites từ local storage
      await _loadFavorites();

      // Select first quote
      if (_quotes.isNotEmpty) {
        _currentQuote = _quotes[0];
      }

      debugPrint('Initialized ${_quotes.length} quotes from API');
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error initializing quotes from API: $e');

      // Fallback to local sample data
      try {
        _quotes.addAll(_sampleQuotes);
        await _loadFavorites();
        if (_quotes.isNotEmpty) {
          _currentQuote = _quotes[0];
        }
        debugPrint('Fallback to ${_quotes.length} sample quotes');
      } catch (fallbackError) {
        debugPrint('Error loading fallback data: $fallbackError');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get a new random quote từ API
  Future<void> getRandomQuote() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final randomQuote = await QuoteService.fetchRandomQuote();

      // Check if quote exists in _quotes, if not add it
      if (!_quotes.any((q) => q.text == randomQuote.text)) {
        _quotes.add(randomQuote);
      }

      _currentQuote = randomQuote;
      debugPrint('Fetched random quote: ${randomQuote.text}');
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error fetching random quote: $e');

      // Fallback: select random from existing quotes
      if (_quotes.isNotEmpty) {
        final random = DateTime.now().millisecond % _quotes.length;
        _currentQuote = _quotes[random];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get today's quote từ API
  Future<void> getTodayQuote() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final todayQuote = await QuoteService.fetchTodayQuote();

      // Check if quote exists in _quotes, if not add it
      if (!_quotes.any((q) => q.text == todayQuote.text)) {
        _quotes.add(todayQuote);
      }

      _currentQuote = todayQuote;
      debugPrint('Fetched today quote: ${todayQuote.text}');
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error fetching today quote: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh all quotes từ API
  Future<void> refreshQuotes() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      _quotes.clear();
      final apiQuotes = await QuoteService.fetchAllQuotes();
      _quotes.addAll(apiQuotes);

      await _loadFavorites();

      if (_quotes.isNotEmpty) {
        _currentQuote = _quotes[0];
      }

      debugPrint('Refreshed ${_quotes.length} quotes from API');
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error refreshing quotes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Quote quote) async {
    final index = _quotes.indexWhere((q) => q.id == quote.id);
    if (index != -1) {
      _quotes[index] = _quotes[index].copyWith(
        isFavorite: !_quotes[index].isFavorite,
      );
      await _saveFavorites();
      notifyListeners();
    }
  }

  /// Save favorites to shared preferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = _quotes
          .where((q) => q.isFavorite)
          .map((q) => q.id)
          .toList();
      await prefs.setStringList('favorite_quotes', favoriteIds);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  /// Load favorites from shared preferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_quotes') ?? [];

      for (var i = 0; i < _quotes.length; i++) {
        if (favoriteIds.contains(_quotes[i].id)) {
          _quotes[i] = _quotes[i].copyWith(isFavorite: true);
        }
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Remove a favorite quote
  Future<void> removeFavorite(String quoteId) async {
    final index = _quotes.indexWhere((q) => q.id == quoteId);
    if (index != -1) {
      _quotes[index] = _quotes[index].copyWith(isFavorite: false);
      await _saveFavorites();
      notifyListeners();
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    for (var i = 0; i < _quotes.length; i++) {
      if (_quotes[i].isFavorite) {
        _quotes[i] = _quotes[i].copyWith(isFavorite: false);
      }
    }
    await _saveFavorites();
    notifyListeners();
  }
}
