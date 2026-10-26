import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/model/article_model.dart';
import 'package:news_app/features/repository/news_repository_impl.dart';

final newsRepoProvider = Provider<NewsRepositoryImpl>(
  (ref) => NewsRepositoryImpl(),
);

class NewsState {
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final List<Article> articles;
  final int page;
  final String category;
  final String? error;

  const NewsState({
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = true,
    this.articles = const [],
    this.page = 1,
    this.category = 'business',
    this.error,
  });

  NewsState copyWith({
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    List<Article>? articles,
    int? page,
    String? category,
    String? error,
    bool clearError = false,
  }) {
    return NewsState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      articles: articles ?? this.articles,
      page: page ?? this.page,
      category: category ?? this.category,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  final NewsRepositoryImpl repo;

  NewsNotifier(this.repo) : super(const NewsState());

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return AppStrings.networkError;
      }
      if (error.response?.data is Map &&
          error.response?.data['message'] != null) {
        return error.response!.data['message'].toString();
      }
      return 'Server error (${error.response?.statusCode ?? 'unknown'}). Please try again.';
    }
    return AppStrings.genericError;
  }

  Future<void> fetch(String category) async {
    try {
      state = state.copyWith(
        loading: true,
        page: 1,
        category: category,
        articles: [],
        hasMore: true,
        clearError: true,
      );

      final data = await repo.getNews(category, 1);

      state = state.copyWith(
        loading: false,
        articles: data,
        hasMore: data.isNotEmpty,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: _handleError(e),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore || state.loading) return;

    try {
      state = state.copyWith(loadingMore: true);

      final nextPage = state.page + 1;

      final data = await repo.getNews(state.category, nextPage);

      state = state.copyWith(
        loadingMore: false,
        page: nextPage,
        hasMore: data.isNotEmpty,
        articles: [...state.articles, ...data],
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false);
    }
  }

  Future<void> refresh() async {
    await fetch(state.category);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    try {
      state = state.copyWith(
        loading: true,
        page: 1,
        category: query,
        articles: [],
        hasMore: true,
        clearError: true,
      );

      final data = await repo.searchNews(query, 1);

      state = state.copyWith(
        loading: false,
        articles: data,
        hasMore: data.isNotEmpty,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: _handleError(e),
      );
    }
  }

  Future<void> loadMoreSearch() async {
    if (!state.hasMore || state.loadingMore || state.loading) return;

    try {
      state = state.copyWith(loadingMore: true);

      final nextPage = state.page + 1;

      final data = await repo.searchNews(state.category, nextPage);

      state = state.copyWith(
        loadingMore: false,
        page: nextPage,
        hasMore: data.isNotEmpty,
        articles: [...state.articles, ...data],
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false);
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final repo = ref.read(newsRepoProvider);
  return NewsNotifier(repo);
});
