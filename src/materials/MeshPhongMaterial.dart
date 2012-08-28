class MeshPhongMaterial extends Material implements ITextureMapMaterial {
  
  Color color;
  Color ambient;
  Color emissive;
  Color specular;
  num shininess;
  
  bool metal;
  bool perPixel;

  bool wrapAround;
  Vector3 wrapRGB;

  Texture map;

  var lightMap;

  var bumpMap;
  num bumpScale;

  var specularMap;

  var envMap;
  int combine;
  num reflectivity;
  num refractionRatio;

  int shading;

  bool wireframe;
  num wireframeLinewidth;
  var wireframeLinecap;
  var wireframeLinejoin;

  bool skinning;
  bool morphTargets;
  bool morphNormals;
  
  int vertexColors;
  bool fog;
  
  MeshPhongMaterial( Map parameters ) : super( parameters ) {

    color = parameters['color'] != null ? parameters['color'] : new Color( 0xffffff ); // diffuse
    ambient = parameters['ambient'] != null ? parameters['ambient'] : new Color( 0xffffff );
    emissive = parameters['emissive'] != null ? parameters['emissive'] : new Color( 0x000000 );
    specular = parameters['specular'] != null ? parameters['specular'] : new Color( 0x111111 );
    shininess = parameters['shininess'] != null ? parameters['shininess'] : 30;

    metal = parameters['metal'] != null ? parameters['metal'] : false;
    perPixel = parameters['perPixel'] != null ? parameters['perPixel'] : false;

    wrapAround = parameters['wrapAround'] != null ? parameters['wrapAround'] : false;
    wrapRGB = parameters['wrapRGB'] != null ? parameters['wrapRGB'] : new Vector3( 1, 1, 1 );

    map = parameters['map'];

    lightMap = parameters['lightMap'];

    bumpMap = parameters['bumpMap'];
    bumpScale = parameters['bumpScale'] != null ? parameters['bumpScale'] : 1;

    specularMap = parameters['specularMap'] != null ? parameters['specularMap'] : null;

    envMap = parameters['envMap'];
    combine = parameters['combine'] != null ? parameters['combine'] : Three.MultiplyOperation;
    reflectivity = parameters['reflectivity'] != null ? parameters['reflectivity'] : 1;
    refractionRatio = parameters['refractionRatio'] != null ? parameters['refractionRatio'] : 0.98;

    fog = parameters['fog'] != null ? parameters['fog'] : true;

    shading = parameters['shading'] != null ? parameters['shading'] : Three.SmoothShading;

    wireframe = parameters['wireframe'] != null ? parameters['wireframe'] : false;
    wireframeLinewidth = parameters['wireframeLinewidth'] != null ? parameters['wireframeLinewidth'] : 1;
    wireframeLinecap = parameters['wireframeLinecap'] != null ? parameters['wireframeLinecap'] : 'round';
    wireframeLinejoin = parameters['wireframeLinejoin'] != null ? parameters['wireframeLinejoin'] : 'round';

    vertexColors = parameters['vertexColors'] != null ? parameters['vertexColors'] : Three.NoColors;

    skinning = parameters['skinning'] != null ? parameters['skinning'] : false;
    morphTargets = parameters['morphTargets'] != null ? parameters['morphTargets'] : false;
    morphNormals = parameters['morphNormals'] != null ? parameters['morphNormals'] : false;

  }
}
