import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikigame/business/classic_mode_bloc/classic_mode_bloc.dart';
import 'package:wikigame/business/classic_mode_bloc/classic_mode_state.dart';
import 'package:wikigame/data/models/game_mode.dart';
import 'package:wikigame/ui/widgets/article_tile.dart';

class GamePage extends StatelessWidget {
  GamePage({
    super.key,
    required this.gameMode,
  }) {
    _bloc.load();
  }

  final GameMode gameMode;

  final _bloc = ClassicModeBloc();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Center(
      child: _blocConsumer,
    ),
  );

  Widget get _blocConsumer => BlocBuilder(
    bloc: _bloc,
    builder: (context, state) {
      if (state is ClassicModeLoaded) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ArticleTile(article: state.currentGame.from),
            const Icon(Icons.arrow_forward),
            ArticleTile(article: state.currentGame.to),
          ],
        );
      }

      return const Text('Lädt...');
    }, 
  );
}
