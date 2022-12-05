import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wikigame/business/classic_mode_bloc/classic_mode_state.dart';
import 'package:wikigame/data/repositories/wiki_repo.dart';
import 'package:wikigame/data/services/game_handler.dart';

class ClassicModeBloc extends Cubit<ClassicModeState> {
  ClassicModeBloc() : super(ClassicModeInitial());

  final _repo = GetIt.I<WikiRepo>();

  late GameHandler _handler;

  Future<void> load() async {
    emit(ClassicModeLoading());

    try {
      final articles = await _repo.getRandomArticles(2);

      if (articles.length < 2) {
        emit(ClassicModeError());
        return;
      }

      _handler = GameHandler.newGame(articles[0], articles[1]);
      emit(ClassicModeLoaded(_handler));
    } catch (e, stackTrace) {
      log('Error loading articles', error: e, stackTrace: stackTrace);
      emit(ClassicModeError());
    }
  }
}
