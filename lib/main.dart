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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to Spelit Buttons Game!", style: TextStyle(fontSize: 48)),
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
            Text("Choose level", style: TextStyle(fontSize: 30)), // onPressed: () => Get.to(() => GameScreen()),
            ElevatedButton(child: Text("Level 1"), onPressed: () => Get.to(() => GameScreen())),
            ElevatedButton(child: Text("Level 2"), onPressed: null),
            ElevatedButton(child: Text("Level 3"), onPressed: null),
          ],
        ),
      )
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: EasyGame(),
    );
  }
}

class EasyGame extends FlameGame {
  var score = 0;
  EasyGame() {
    add(TapCircle1());
  }
  incrementScore() {
    score++;
    /*if (score >= 10) {
      Get.offAll(() => ResultScreen(score: score));
    }*/
  }
}

class TapCircle1 extends CircleComponent with HasGameReference<EasyGame>, TapCallbacks, HasVisibility {
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
    game.incrementScore();
    isVisible = false;
    timeUntilNextAppearance = 1 + random.nextDouble() * 3;
  }
}

