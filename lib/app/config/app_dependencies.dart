import 'package:get_it/get_it.dart';
import 'package:wikigame/app/data/datasources/wiki_api.dart';
import 'package:wikigame/app/data/repositories/wiki_repository.dart';

class AppDependencies {
  static void register() {
    _registerDatasources();
    _registerRepositories();
  }

  static void _registerDatasources() {
    GetIt.I.registerLazySingleton(() => WikiAPI());
  }

  static void _registerRepositories() {
    GetIt.I.registerLazySingleton(() => WikiRepository());
  }
} 