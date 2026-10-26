import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/model/article_model.dart';
import 'package:news_app/features/providers/news_provider.dart';
import 'package:news_app/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    test('Valid email passes validation', () {
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('developer@company.org'), isNull);
    });

    test('Invalid or empty email returns error message', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email(null), 'Email is required');
      expect(Validators.email('invalid-email'), 'Enter a valid email address');
      expect(Validators.email('test@.com'), 'Enter a valid email address');
    });

    test('Password validator checks minimum length', () {
      expect(Validators.password(null), 'Password is required');
      expect(Validators.password(''), 'Password is required');
      expect(Validators.password('12345'),
          'Password must be at least 6 characters');
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('securePassword!'), isNull);
    });

    test('Confirm password validator ensures matching values', () {
      expect(Validators.confirmPassword('', '123456'),
          'Please confirm your password');
      expect(Validators.confirmPassword('123457', '123456'),
          'Passwords do not match');
      expect(Validators.confirmPassword('123456', '123456'), isNull);
    });
  });

  group('Article Model Tests', () {
    test('Article fromJson deserializes correctly', () {
      final json = {
        'title': 'Flutter 3.27 Released',
        'urlToImage': 'https://example.com/flutter.png',
        'description': 'Exciting new features in Flutter.',
        'content': 'Full article text content goes here.',
        'url': 'https://example.com/flutter-article',
      };

      final article = Article.fromJson(json);

      expect(article.title, 'Flutter 3.27 Released');
      expect(article.image, 'https://example.com/flutter.png');
      expect(article.description, 'Exciting new features in Flutter.');
      expect(article.content, 'Full article text content goes here.');
      expect(article.url, 'https://example.com/flutter-article');
    });

    test('Article toJson serializes correctly', () {
      final article = Article(
        title: 'Tech News',
        image: 'https://example.com/img.jpg',
        description: 'Tech overview',
        content: 'Content',
        url: 'https://example.com/tech',
      );

      final map = article.toJson();

      expect(map['title'], 'Tech News');
      expect(map['image'], 'https://example.com/img.jpg');
      expect(map['url'], 'https://example.com/tech');
    });
  });

  group('NewsState Tests', () {
    test('NewsState initial values are correct', () {
      const state = NewsState();
      expect(state.loading, isFalse);
      expect(state.loadingMore, isFalse);
      expect(state.hasMore, isTrue);
      expect(state.articles, isEmpty);
      expect(state.page, 1);
      expect(state.category, 'business');
      expect(state.error, isNull);
    });

    test('NewsState copyWith updates error and articles correctly', () {
      const state = NewsState();
      final updated = state.copyWith(
        error: 'Network error',
        loading: false,
      );

      expect(updated.error, 'Network error');
      expect(updated.loading, isFalse);

      final cleared = updated.copyWith(clearError: true);
      expect(cleared.error, isNull);
    });
  });
}
