import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _getNewQuote() {
    _animationController.reset();
    Provider.of<QuotesProvider>(context, listen: false).getRandomQuote();
    _animationController.forward();
  }

  void _getTodayQuote() {
    _animationController.reset();
    Provider.of<QuotesProvider>(context, listen: false).getTodayQuote();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Quotes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade900,
              Colors.purple.shade700,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: Consumer<QuotesProvider>(
          builder: (context, quotesProvider, child) {
            final currentQuote = quotesProvider.currentQuote;

            if (quotesProvider.isLoading || currentQuote == null) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Colors.grey.shade100,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      size: 48,
                                      color: Colors.purple.shade900.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      currentQuote.text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            height: 1.6,
                                            color: Colors.grey.shade800,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '— ${currentQuote.author}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.purple.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () {
                                quotesProvider.toggleFavorite(currentQuote);
                              },
                              backgroundColor: currentQuote.isFavorite
                                  ? Colors.red.shade400
                                  : Colors.white.withValues(alpha: 0.3),
                              foregroundColor: currentQuote.isFavorite
                                  ? Colors.white
                                  : Colors.white,
                              icon: Icon(
                                currentQuote.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 28,
                              ),
                              label: Text(
                                currentQuote.isFavorite
                                    ? 'Đã thích'
                                    : 'Yêu thích',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            FloatingActionButton.extended(
                              onPressed: _getNewQuote,
                              backgroundColor: Colors.amber.shade400,
                              foregroundColor: Colors.white,
                              icon: const Icon(Icons.refresh, size: 28),
                              label: const Text(
                                'Quote mới',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FloatingActionButton.extended(
                          onPressed: _getTodayQuote,
                          backgroundColor: Colors.greenAccent.shade400,
                          foregroundColor: Colors.white,
                          icon: const Icon(Icons.today, size: 28),
                          label: const Text(
                            'Quote của ngày',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
