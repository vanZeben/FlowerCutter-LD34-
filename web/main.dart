library ld34;

import 'dart:html';
import 'dart:web_gl' as GL;

import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:game_loop/game_loop_html.dart';

part 'shader.dart';
part 'texture.dart';
part 'sprites.dart';

const int GAME_WIDTH = 420;
const int GAME_HEIGHT = 240;
const double GAME_SCALE = 2.0;

GL.RenderingContext gl;

Matrix4 pMatrix;
class Game {
    CanvasElement canvas;
    GameLoopHtml gameLoop;
    Game() {
      canvas = querySelector("#game");
      
      gameLoop = new GameLoopHtml(canvas);
      
      gl = canvas.getContext("webgl");
      if (gl == null) { gl = canvas.getContext("experimental-webgl"); }
      if (gl == null) { querySelector("#webgl_missing").setAttribute("style", "display: inline"); }
      else { start(); }
    }
    void resize() {
      int w = window.innerWidth;
      int h = window.innerHeight;
      double xScale = w/GAME_WIDTH;
      double yScale = h/GAME_HEIGHT;
      
      if (xScale < yScale) {
        canvas.setAttribute("style", "width: ${w}px; height: ${GAME_HEIGHT * xScale}px;");
      } else {
        canvas.setAttribute("style", "width: ${GAME_WIDTH * yScale}px; height: ${h}px;");
      }     
    }
    Sprites test;
    Sprite base;
    void start() {
      resize();
      window.onResize.listen((event) => resize());

      pMatrix = makeOrthographicMatrix(0.0, GAME_WIDTH, GAME_HEIGHT, 0.0, -10.0, 10.0).scale(GAME_SCALE, GAME_SCALE, 1.0);
      
      Texture sprites = new Texture("tex/sprites.png");
      Texture.loadAll();
      
      test = new Sprites(shader, sprites.texture);
      base = new Sprite(1.0 * 16.0, 0.0, 16.0, 16.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, false);
      test.addSprite(base);
      
      gameLoop.addTimer(render, 0.001, periodic: true);
      gameLoop.start();
    }
    
    void render(GameLoopTimer timer) {
      double time = timer.gameLoop.gameTime * 1000;
      gl.viewport(0, 0, canvas.width, canvas.height);
      gl.clearColor(0.1, 0.1, 0.1, 1.0);
      gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
      
      base.x = time * 0.01;
      test.render(new Matrix4.identity());
    }
}

void main() {
  new Game();
}
