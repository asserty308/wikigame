import 'package:get_it/get_it.dart';
import 'package:wikigame/data/repositories/wiki_repo.dart';

void registerDependencies() {
  GetIt.I.registerLazySingleton(WikiRepo.new);
}
