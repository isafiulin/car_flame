import 'dart:math';
import 'package:car_flame/game/car_race.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class Competitor<T> extends SpriteGroupComponent<T>
    with HasGameRef<CarRace>, CollisionCallbacks {
  final hitbox = CircleHitbox();

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 150;

  Competitor({
    super.position,
  }) : super(
          size: Vector2.all(40), // Устанавливаем размер на 40x40
          priority: 2,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    hitbox.radius = 20; // Устанавливаем радиус хитбокса на 20
    await add(hitbox);
    final points = getRandomPositionOfEnemy();

    position = Vector2(points.xPoint, points.yPoint);
  }

  void _move(double dt) {
    _velocity.y = direction * speed;

    position += _velocity * dt;
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }

  ({double xPoint, double yPoint}) getRandomPositionOfEnemy() {
    final random = Random();
    final randomXPoint =
        50 + random.nextInt((gameRef.size.x.toInt() - 100) - 50);

    // Появление врагов в верхней части экрана по оси Y
    final randomYPoint = -size.y; // выше экрана

    return (
      xPoint: randomXPoint.toDouble(),
      yPoint: randomYPoint.toDouble(),
    );
  }
}

enum EnemyPlatformState { only }

class EnemyPlatform extends Competitor<EnemyPlatformState> {
  EnemyPlatform({
    super.position,
    double speed = 150,
  }) {
    this.speed = speed;
  }

  final List<String> enemy = [
    'enemy_1',
    'enemy_2',
    'enemy_3',
    'enemy_4',
    'enemy_5'
  ];

  @override
  Future<void>? onLoad() async {
    int enemyIndex = Random().nextInt(enemy.length);

    String enemySprite = enemy[enemyIndex];

    sprites = <EnemyPlatformState, Sprite>{
      EnemyPlatformState.only:
          await gameRef.loadSprite('game/$enemySprite.png'),
    };

    current = EnemyPlatformState.only;

    return super.onLoad();
  }
}
