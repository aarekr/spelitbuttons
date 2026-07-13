import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome to Spelit Buttons Game!", style: TextStyle(fontSize: 32)),
              Padding(
                padding: EdgeInsets.all(16),
              ),
              ElevatedButton(
                child: Text(
                  "Start",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () => Get.to(() => LevelScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
      Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Choose level", style: TextStyle(fontSize: 30)),
            ElevatedButton(child: Text("Level 1"), onPressed: () => Get.to(() => GameScreen(level: 1))),
            ElevatedButton(child: Text("Level 2"), onPressed: () => Get.to(() => GameScreen(level: 2))),
            ElevatedButton(child: Text("Level 3"), onPressed: () => Get.to(() => GameScreen(level: 3))),
          ],
        ),
      )
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int gameTime;
  const ResultScreen({required this.score, required this.gameTime});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You got $score points in $gameTime seconds!", 
              style: TextStyle(fontSize: 30)
            ),
            Padding(padding: EdgeInsets.all(16),),
            ElevatedButton(
              child: Text("Back to start", style: TextStyle(fontSize: 24)),
              onPressed: () => Get.to(() => StartScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final int level;
  const GameScreen({required this.level});
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SpelitGame(level: level),
    );
  }
}

class SpelitGame extends FlameGame {
  final int level;
  var gameFinished = false;
  var gameTime;
  var timeLeft;
  var score = 0;
  SpelitGame({required this.level}) {
    if (this.level == 1) {
      timeLeft = gameTime = 10;
    } else if (this.level == 2) {
      timeLeft = gameTime = 30;
    } else {
      timeLeft = gameTime = 60;
    }
    add(TapCircle1());
    add(TapCircle2());
    add(TapCircle3());
    add(TapCircle4());
  }
  @override
  void update(double dt) {
    super.update(dt);
    timeLeft -= dt;
    if (timeLeft <= 0 && !gameFinished) {
      gameFinished = true;
      Get.offAll(() => ResultScreen(score: score, gameTime: gameTime));
    }
  }
  incrementScore() {
    score++;
    if (score >= 5) {
      Get.offAll(() => ResultScreen(score: score, gameTime: gameTime));
    }
  }
}

class TapCircle1 extends CircleComponent with HasGameReference<SpelitGame>, TapCallbacks, HasVisibility {
  final Random random = Random();
  double timeUntilNextAppearance = 2.0;
  double visibleTime = 1.0;
  TapCircle1()
    : super(
      position: Vector2(200, 200),
      radius: 70,
    ) {
      paint.color = Colors.blue;
      isVisible = false;
    }
  @override
  void update(double dt) {
    super.update(dt);
    if (!isVisible) {
      timeUntilNextAppearance -= dt;
      if (timeUntilNextAppearance <= 0) {
        isVisible = true;
        visibleTime = 1.0;
      }
    } else {
      visibleTime -= dt;
      if (visibleTime <= 0) {
        isVisible = false;
        timeUntilNextAppearance = 1 + random.nextDouble() * 3;
      }
    }
  }
  @override
  void onTapDown(TapDownEvent event) {
    if (isVisible) {
      game.incrementScore();
    }
    isVisible = false;
    timeUntilNextAppearance = 1 + random.nextDouble() * 3;
  }
}

class TapCircle2 extends CircleComponent with HasGameReference<SpelitGame>, TapCallbacks, HasVisibility {
  final Random random = Random();
  double timeUntilNextAppearance = 2.0;
  double visibleTime = 1.0;
  TapCircle2()
    : super(
      position: Vector2(350, 200),
      radius: 70,
    ) {
      paint.color = Colors.green;
      isVisible = false;
    }
  @override
  void update(double dt) {
    super.update(dt);
    if (!isVisible) {
      timeUntilNextAppearance -= dt;
      if (timeUntilNextAppearance <= 0) {
        isVisible = true;
        visibleTime = 1.0;
      }
    } else {
      visibleTime -= dt;
      if (visibleTime <= 0) {
        isVisible = false;
        timeUntilNextAppearance = 1 + random.nextDouble() * 3;
      }
    }
  }
  @override
  void onTapDown(TapDownEvent event) {
    if (isVisible) {
      game.incrementScore();
    }
    isVisible = false;
    timeUntilNextAppearance = 1 + random.nextDouble() * 3;
  }
}

class TapCircle3 extends CircleComponent with HasGameReference<SpelitGame>, TapCallbacks, HasVisibility {
  final Random random = Random();
  double timeUntilNextAppearance = 2.0;
  double visibleTime = 1.0;
  TapCircle3()
    : super(
      position: Vector2(500, 200),
      radius: 70,
    ) {
      paint.color = Colors.orange;
      isVisible = false;
    }
  @override
  void update(double dt) {
    super.update(dt);
    if (!isVisible) {
      timeUntilNextAppearance -= dt;
      if (timeUntilNextAppearance <= 0) {
        isVisible = true;
        visibleTime = 1.0;
      }
    } else {
      visibleTime -= dt;
      if (visibleTime <= 0) {
        isVisible = false;
        timeUntilNextAppearance = 1 + random.nextDouble() * 3;
      }
    }
  }
  @override
  void onTapDown(TapDownEvent event) {
    if (isVisible) {
      game.incrementScore();
    }
    isVisible = false;
    timeUntilNextAppearance = 1 + random.nextDouble() * 3;
  }
}

class TapCircle4 extends CircleComponent with HasGameReference<SpelitGame>, TapCallbacks, HasVisibility {
  final Random random = Random();
  double timeUntilNextAppearance = 2.0;
  double visibleTime = 1.0;
  TapCircle4()
    : super(
      position: Vector2(650, 200),
      radius: 70,
    ) {
      paint.color = Colors.red;
      isVisible = false;
    }
  @override
  void update(double dt) {
    super.update(dt);
    if (!isVisible) {
      timeUntilNextAppearance -= dt;
      if (timeUntilNextAppearance <= 0) {
        isVisible = true;
        visibleTime = 1.0;
      }
    } else {
      visibleTime -= dt;
      if (visibleTime <= 0) {
        isVisible = false;
        timeUntilNextAppearance = 1 + random.nextDouble() * 3;
      }
    }
  }
  @override
  void onTapDown(TapDownEvent event) {
    if (isVisible) {
      game.incrementScore();
    }
    isVisible = false;
    timeUntilNextAppearance = 1 + random.nextDouble() * 3;
  }
}
