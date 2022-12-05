import 'package:flutter/material.dart';
import 'package:wikigame/data/models/wiki_article.dart';
import 'package:wikigame/data/services/game_handler.dart';

@immutable
abstract class ClassicModeState {}
class ClassicModeInitial extends ClassicModeState {}
class ClassicModeLoading extends ClassicModeState {}

class ClassicModeLoaded extends ClassicModeState {
  ClassicModeLoaded(this.currentGame);
  
  final GameHandler currentGame;
}

class ClassicModeError extends ClassicModeState {}
