import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/datasource/remote/itunes_remote_datasource.dart';
import '../../data/datasource/local/sqlite_database_helper.dart';
import '../../data/repository/music_repository_impl.dart';
import '../../data/repository/local_repository_impl.dart';
import '../../domain/repositories/music_repository.dart';
import '../../domain/repositories/local_repository.dart';

// --- Core Providers ---

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // Optional: Add interceptors for logging, etc.
  return dio;
});

final dbHelperProvider = Provider<SqliteDatabaseHelper>((ref) {
  return SqliteDatabaseHelper.instance;
});

// --- Repository Providers ---

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final remoteDatasource = ItunesRemoteDatasource(dio);
  return MusicRepositoryImpl(remoteDatasource);
});

final localRepositoryProvider = Provider<LocalRepository>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return LocalRepositoryImpl(dbHelper);
});
