part of three;

abstract class Renderer {
  Element get domElement;
  void render( Scene scene, Camera camera );
  void setSize( num width, num height );
}
