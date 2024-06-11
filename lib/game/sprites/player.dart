import 'dart:async';
import 'package:car_flame/game/car_race.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState {
  left,
  right,
  center,
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<CarRace>, KeyboardHandler, CollisionCallbacks {
  Player({
    required this.character,
    this.moveSpeed = 700,
  }) : super(
          size: Vector2(79, 109),
          anchor: Anchor.center,
          priority: 1,
        );
  double moveSpeed;
  Character character;

  int hAxisInput = 0;
  int vAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  final int movingUpInput = -1;
  final int movingDownInput = 1;
  Vector2 _velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox());
    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    _velocity.x = hAxisInput * moveSpeed;
    _velocity.y = vAxisInput * moveSpeed;

    position += _velocity * dt;

    final double playerHorizontalCenter = size.x / 1.7;
    final double playerVerticalCenter = size.y / 2;

    // Ограничиваем движение игрока по горизонтали
    if (position.x < playerHorizontalCenter) {
      position.x = playerHorizontalCenter;
    }
    if (position.x > gameRef.size.x - playerHorizontalCenter) {
      position.x = gameRef.size.x - playerHorizontalCenter;
    }

    // Ограничиваем движение игрока по вертикали
    if (position.y < playerVerticalCenter) {
      position.y = playerVerticalCenter;
    }
    if (position.y > gameRef.size.y - playerVerticalCenter) {
      position.y = gameRef.size.y - playerVerticalCenter;
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    gameRef.onLose();
    return;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    hAxisInput = 0;
    vAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      moveUp();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      moveDown();
    }

    return true;
  }

  void moveLeft() {
    hAxisInput = movingLeftInput;
    current = PlayerState.left;
  }

  void moveRight() {
    hAxisInput = movingRightInput;
    current = PlayerState.right;
  }

  void moveUp() {
    vAxisInput = movingUpInput;
  }

  void moveDown() {
    vAxisInput = movingDownInput;
  }

  void resetDirection() {
    hAxisInput = 0;
    vAxisInput = 0;
  }

  void reset() {
    _velocity = Vector2.zero();
    current = PlayerState.center;
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  Future<void> _loadCharacterSprites() async {
    final left = await gameRef.loadSprite('game/${character.name}.png');
    final right = await gameRef.loadSprite('game/${character.name}.png');
    final center = await gameRef.loadSprite('game/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
    };
  }
}
