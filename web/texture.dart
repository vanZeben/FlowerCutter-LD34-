part of ld34;

class Texture {
  static List<Texture> _all = new List<Texture>();
  static void loadAll() {
    for (Texture tex in _all) {
      tex.load();
    }
  }
  static Texture get(String url) {
    for (Texture tex in _all) {
      if (tex.url == url) {
        return tex;
      }
    }
    Texture tex = new Texture(url);
    tex.load();
    return tex;
  }
  
  String url;
  GL.Texture texture;
  bool loaded = false;
  Texture(this.url) {
    _all.add(this);
  }
  
  load() {
    ImageElement img = new ImageElement();
    texture = gl.createTexture();
    img.onLoad.listen((e) {
      gl.bindTexture(GL.TEXTURE_2D, texture);
      gl.texImage2DImage(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, img);
      gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
      gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
      loaded = true;
    });
    img.src = url;
  }
  
  use() {
    if (!loaded) { return; }
    gl.bindTexture(GL.TEXTURE_2D, texture);
  }
}