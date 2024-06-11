import 'dart:math';
import 'package:car_flame/game/car_race.dart';
import 'package:car_flame/game/sprites/competitor.dart';
import 'package:car_flame/game/state/car_state.dart';
import 'package:flame/components.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<CarRace> {
  ObjectManager();
  int enemyLevel = 1;
  int maxEnemies = 5;
  double enemySpawnInterval = 2.0;
  double timeSinceLastSpawn = 0.0;
  double enemySpeed = 150;

  @override
  void onMount() {
    super.onMount();

    addEnemy(enemyLevel, 3); // Добавляем три врага при запуске
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.gameManager.state == GameState.playing) {
      gameRef.gameManager.increaseScore();

      timeSinceLastSpawn += dt;
      if (timeSinceLastSpawn >= enemySpawnInterval) {
        timeSinceLastSpawn = 0.0;
        addEnemy(enemyLevel, 1); // Добавляем одного врага с интервалом
      }

      if (gameRef.gameManager.score.value >= 3000) {
        enemyLevel = 2;
        maxEnemies = 10;
        enemySpeed = 200; // Увеличиваем скорость врагов при достижении 3000 очков
      }

      _cleanupEnemies();
    }
  }

  final Map<String, bool> specialPlatforms = {
    'enemy': false,
  };

  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  void addEnemy(int level, int count) {
    if (_enemies.length >= maxEnemies) {
      return; // Ограничение на количество врагов
    }

    switch (level) {
      case 1:
        enableSpecialty('enemy');
        break;
    }

    for (int i = 0; i < count; i++) {
      _maybeAddEnemy();
    }
  }

  final List<EnemyPlatform> _enemies = [];
  void _maybeAddEnemy() {
    if (specialPlatforms['enemy'] != true) {
      return;
    }

    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;
    var currentY = -(_rand.nextInt(gameRef.size.y.floor()) / 3) - 50;

    var enemy = EnemyPlatform(
      position: Vector2(
        currentX,
        currentY,
      ),
      speed: enemySpeed, // Передаем скорость врага
    );

    add(enemy);
    _enemies.add(enemy);
  }

  void _cleanupEnemies() {
    _enemies.removeWhere((enemy) {
      if (enemy.position.y > gameRef.size.y) {
        enemy.removeFromParent();
        return true;
      }
      return false;
    });
  }
}
