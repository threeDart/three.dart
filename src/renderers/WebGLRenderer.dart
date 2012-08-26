class WebGLRenderer implements Renderer {

  CanvasElement canvas;
  
  WebGLRenderer( [this.canvas] ) {
    if (canvas == null) {
        canvas = new CanvasElement();
    }
  }
  
    
}
