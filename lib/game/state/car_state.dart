import 'package:car_flame/game/car_race.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameManager extends Component with HasGameRef<CarRace> {
  GameManager();

  Character character = Character.tesla;
  double moveSpeed = 700;
  ValueNotifier<int> score = ValueNotifier(0);

  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;
  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }

  void selectCharacter(Character selectedCharcter, double moveSpeed) {
    character = selectedCharcter;
    moveSpeed = moveSpeed;
  }
}

enum GameState { intro, playing, gameOver }
