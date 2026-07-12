import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:get/get.dart';

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
              onPressed: null,//() => Get.to(() => GameScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
