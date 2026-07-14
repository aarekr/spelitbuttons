import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:get/get.dart';
import 'dart:math';

class Breakpoints {
  static const mobile = 500;
  static const tablet = 700;
}

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
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(child: Text("Level 1"), onPressed: () => Get.to(() => GameScreen(level: 1))),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(child: Text("Level 2"), onPressed: () => Get.to(() => GameScreen(level: 2))),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(child: Text("Level 3"), onPressed: () => Get.to(() => GameScreen(level: 3))),
          ],
        ),
      )
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String endReason;
  final int level;
  final int score;
  final double timeUsed;
  const ResultScreen({required this.endReason, required this.level, required this.score, required this.timeUsed});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            endReason == "time"
              ? Text("Unfortunately you didn't pass the level...", 
                  style: TextStyle(fontSize: 30)
                )
              : Column(children: [
                  Text("You passed level $level!", 
                    style: TextStyle(fontSize: 30)
                  ),
                  Text("You got $score points in ${timeUsed.toStringAsFixed(2)} seconds!", 
                    style: TextStyle(fontSize: 30)
                  ),
                ]),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(
              child: Text("Play again", style: TextStyle(fontSize: 24)),
              onPressed: () => Get.to(() => LevelScreen()),
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
  bool gameFinished = false;
  //String endReason = "";
  double gameTime = 0.0;
  double timeLeft = 0.0;
  int score = 0;
  SpelitGame({required this.level});
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print("Screen size: ${size.x} x ${size.y}");
    if (level == 1) {
      timeLeft = gameTime = 10.0;
    } else if (level == 2) {
      timeLeft = gameTime = 30.0;
    } else {
      timeLeft = gameTime = 60.0;
    }
    double x1Position = size.x > 800 ? (size.x-800-(size.x-800)/2+4) : 0.5*size.x/100;
    double x2Position = size.x > 800 ? (size.x-800-(size.x-800)/2+204) : 25.5*size.x/100;
    double x3Position = size.x > 800 ? (size.x-800-(size.x-800)/2+404) : 50.5*size.x/100;
    double x4Position = size.x > 800 ? (size.x-800-(size.x-800)/2+604) : 75.5*size.x/100;
    add(TapCircle1(size.x, size.y, x1Position));
    add(TapCircle2(size.x, size.y, x2Position));
    add(TapCircle3(size.x, size.y, x3Position));
    add(TapCircle4(size.x, size.y, x4Position));
  }
  @override
  void update(double dt) {
    super.update(dt);
    timeLeft -= dt;
    if (timeLeft <= 0 && !gameFinished) {
      gameFinished = true;
      Get.offAll(() => ResultScreen(endReason: "time", level: level, score: score, timeUsed: gameTime-timeLeft));
    }
  }
  incrementScore() {
    score++;
    if (level == 1 && score >= 3) {
      Get.offAll(() => ResultScreen(endReason: "score", level: level, score: score, timeUsed: gameTime-timeLeft));
    } else if (level == 2 && score >= 15) {
      Get.offAll(() => ResultScreen(endReason: "score", level: level, score: score, timeUsed: gameTime-timeLeft));
    } else if (level == 3 && score >= 50) {
      Get.offAll(() => ResultScreen(endReason: "score", level: level, score: score, timeUsed: gameTime-timeLeft));
    }
  }
}

class TapCircle1 extends CircleComponent with HasGameRef<SpelitGame>, TapCallbacks, HasVisibility {
  final Random random = Random();
  double timeUntilNextAppearance = 2.0;
  double visibleTime = 1.0;
  double x = 0.0;
  double y = 0.0;
  TapCircle1(x, y, x1Position)
    : super(
      position: Vector2(x1Position, 200),
      radius: min(x*0.115, 192/2),
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
  double x = 0.0;
  double y = 0.0;
  TapCircle2(x, y, x2Position)
    : super(
      position: Vector2(x2Position, 200),
      radius: min(x*0.115, 192/2),
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
  double x = 0.0;
  double y = 0.0;
  TapCircle3(x, y, x3Position)
    : super(
      position: Vector2(x3Position, 200),
      radius: min(x*0.115, 192/2),
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
  double x = 0.0;
  double y = 0.0;
  TapCircle4(x, y, x4Position)
    : super(
      position: Vector2(x4Position, 200),
      radius: min(x*0.115, 192/2),
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
