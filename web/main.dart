library ld34;

import 'dart:html';
import 'dart:web_gl' as GL;
import 'dart:async';

import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:game_loop/game_loop_html.dart';
import 'dart:convert';

part 'utils.dart';
part 'shader.dart';
part 'texture.dart';
part 'sprites.dart';
part 'level.dart';
part 'entity.dart';

const int GAME_WIDTH = 420;
const int GAME_HEIGHT = 240;
const double GAME_SCALE = 2.0;

GL.RenderingContext gl;

Matrix4 pMatrix;
class Game {
  static Game instance;
  CanvasElement canvas;
  GameLoopHtml gameLoop;
  GameLevel activeLevel;
  Game() {
    instance = this;
    canvas = querySelector("#game");
    gameLoop = new GameLoopHtml(canvas);

    gl = canvas.getContext("webgl");
    if (gl == null) { gl = canvas.getContext("experimental-webgl"); }
    if (gl == null) { querySelector("#webgl_missing").setAttribute("style", "display: inline");
    } else { start(); }
  }

  void resize() {
    int w = window.innerWidth;
    int h = window.innerHeight;
    double xScale = w / GAME_WIDTH;
    double yScale = h / GAME_HEIGHT;

    if (xScale < yScale) {
      int newHeight = (GAME_HEIGHT * xScale).floor();
      canvas.setAttribute("style", "position: absolute; width: ${w}px; height: ${GAME_HEIGHT * xScale}px; left:0px;top:${(h-newHeight)/2}px");
    } else {
      int newWidth = (GAME_WIDTH * yScale).floor();
      canvas.setAttribute("style", "position: absolute; width: ${GAME_WIDTH * yScale}px; height: ${h}px; left:${(w-newWidth)/2}px;top:0px");
    }
  }

  void start() {
    resize();
    window.onResize.listen((event) => resize());

    new Texture("tex/sprites.png");
    new Texture("tex/entities.png");
    Texture.loadAll();
    
    pMatrix = makeOrthographicMatrix(0.0, GAME_WIDTH, GAME_HEIGHT, 0.0, -10.0, 10.0).scale(GAME_SCALE, GAME_SCALE, 1.0);
    
    activeLevel = new GameLevel(new Level("lvl/lvl_2.json"));
    
    gameLoop.addTimer(render, 0.001, periodic: true);
    gameLoop.start();
  }

  void render(GameLoopTimer timer) {
    double time = timer.gameLoop.gameTime * 1000;
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.1, 0.1, 0.1, 1.0);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
    activeLevel.render(time, timer.gameLoop.dt);
  }
}

void main() {
  new Game();
}
