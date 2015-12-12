part of ld34;

class Shader {
  GL.Program program;
  Shader(String vSS, String fSS) {
    var vertex = compile(vSS, GL.VERTEX_SHADER);
    var fragment = compile(fSS, GL.FRAGMENT_SHADER);
    program = link(vertex, fragment);
  }
  
  GL.Shader compile(String src, int type) {
    GL.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, src);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
      print(src);
      throw gl.getShaderInfoLog(shader);
    }
    return shader;
  }
  
  GL.Program link(GL.Shader vertex, GL.Shader fragment) {
    GL.Program program = gl.createProgram();
    gl.attachShader(program, vertex);
    gl.attachShader(program, fragment);
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, GL.LINK_STATUS)) { throw gl.getProgramInfoLog(program); }
    return program;
  }
  
  void use() {
    gl.useProgram(program);
  }
}

Shader shader = new Shader(
"""
precision mediump float;

attribute vec2 a_pos;
attribute vec4 a_col;
attribute vec2 a_tex;

uniform mat4 u_pMatrix;

varying vec4 v_col;
varying vec2 v_tex;

void main() {
  v_col = a_col;
  v_tex = a_tex/256.0;

  gl_Position = u_pMatrix * vec4(floor(a_pos), 0.5, 1.0);
}
""", """
precision mediump float;

varying vec4 v_col;
varying vec2 v_tex;

uniform sampler2D u_tex;

void main() {
  vec4 col = texture2D(u_tex, v_tex);
  if (col.a < 0.5) { discard; }
  gl_FragColor = col*v_col;
}
""");
