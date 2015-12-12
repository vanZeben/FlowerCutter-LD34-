part of ld34;
class Shader {
  GL.Program program; // Program to use for theses 
  Shader(String vertexShaderSource, String fragmentShaderSource) {
    var vertexShader = compile(vertexShaderSource, GL.VERTEX_SHADER); //compile our vertex shader
    var fragmentShader = compile(fragmentShaderSource, GL.FRAGMENT_SHADER); // compile our fragment shader
    program = link(vertexShader, fragmentShader); // link it to the program
  }
  
  GL.Shader compile(String source, int type) {
    GL.Shader shader = gl.createShader(type); // create empty shader
    gl.shaderSource(shader, source); // set source of shader to the source
    gl.compileShader(shader); // compile the shader
    if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {print(source);throw gl.getShaderInfoLog(shader);} // throw any compilation errors
    return shader; 
  }
  
  GL.Program link(GL.Shader vertex, GL.Shader fragment) {
    GL.Program program = gl.createProgram(); // create empty program
    gl.attachShader(program, vertex); // attach vertex shader to the program
    gl.attachShader(program, fragment); // attach fragment shader to the program
    gl.linkProgram(program); // actually link the shaders to the program
    if (!gl.getProgramParameter(program, GL.LINK_STATUS)) throw gl.getProgramInfoLog(program); // throw any link errors
    return program;
  }
  
  // Ease of use function that allows us to use a specific shader without exposing any internal data
  void use() {
    gl.useProgram(program);
  }
}

Shader testShader = new Shader(
    /* Vertex Shader */ """
  precision highp float;
  
  attribute vec2 a_pos;
  attribute vec4 a_col;
  attribute vec2 a_tex;

  uniform mat4 u_pMatrix;

  varying vec4 v_col;
  varying vec2 v_tex;

  void main() {
    v_col = a_col;
    v_tex = a_tex/256.0;

    gl_Position = u_pMatrix*vec4(floor(a_pos), 0.5, 1.0); 
  } 
""",/* Fragment Shader */ """
  precision highp float;
      
  varying vec4 v_col;
  varying vec2 v_tex;

  uniform sampler2D u_tex;

  void main() {
    vec4 col = texture2D(u_tex, v_tex);
    if (col.a<0.5) discard;
    gl_FragColor = col*v_col;
  }
""");