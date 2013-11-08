part of three;

class Sprite extends Object3D {
  Color color;
  Texture map;

  int blending;
  int blendSrc;

  int blendDst;
  int blendEquation;

  bool useScreenCoordinates;
  bool mergeWith3D;
  bool affectedByDistance;
  bool scaleByViewport;

  Vector2 alignment;

  Vector3 rotation3d;

  num opacity;

  Vector2 uvOffset, uvScale;

  Sprite({  num hexColor: 0xffffff,
            this.map,
            this.blending: NormalBlending,
            this.blendSrc: SrcAlphaFactor,
            this.blendDst: OneMinusSrcAlphaFactor,
            this.blendEquation: AddEquation,

            this.useScreenCoordinates: true,

            bool mergeWith3D: null,
            bool affectedByDistance: null,
            bool scaleByViewport: null,

            Vector2 alignment: null})

            : color = new Color(hexColor),
              uvOffset = new Vector2.zero(),
              uvScale = new Vector2(1.0, 1.0),
              opacity = 1,
              super() {

    if (map == null) map = new Texture();
    if (mergeWith3D == null)  this.mergeWith3D = !useScreenCoordinates;
    if (affectedByDistance == null)  this.affectedByDistance = !useScreenCoordinates;
    if (scaleByViewport == null)  this.scaleByViewport = !affectedByDistance;

    if (alignment == null) this.alignment = SpriteAlignment.center;

    rotation3d = rotation;
  }
}

class SpriteAlignment {
  static Vector2 _topLeft;
  static Vector2 get topLeft => (_topLeft == null) ? _topLeft = new Vector2( 1.0, -1.0 ): _topLeft;
  static Vector2 _topCenter;
  static Vector2 get topCenter => (_topCenter == null) ? _topCenter = new Vector2( 0.0, -1.0 ): _topCenter;
  static Vector2 _topRight;
  static Vector2 get topRight => (_topRight == null) ? _topRight = new Vector2( -1.0, -1.0 ): _topRight;
  static Vector2 _centerLeft;
  static Vector2 get centerLeft => (_centerLeft == null) ? _centerLeft = new Vector2( 1.0, 0.0 ): _centerLeft;
  static Vector2 _center;
  static Vector2 get center => (_center == null) ? _center = new Vector2.zero(): _center;
  static Vector2 _centerRight;
  static Vector2 get centerRight => (_centerRight == null) ? _centerRight = new Vector2( -1.0, 0.0 ): _centerRight;
  static Vector2 _bottomLeft;
  static Vector2 get bottomLeft => (_bottomLeft == null) ? _bottomLeft = new Vector2( 1.0, 1.0 ): _bottomLeft;
  static Vector2 _bottomCenter;
  static Vector2 get bottomCenter => (_bottomCenter == null) ? _bottomCenter = new Vector2( 0.0, 1.0 ): _bottomCenter;
  static Vector2 _bottomRight;
  static Vector2 get bottomRight => (_bottomRight == null) ? _bottomRight = new Vector2( -1.0, 1.0 ): _bottomRight;
}
