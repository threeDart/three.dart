#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');
#import('package:three.dart/extras/SceneUtils.dart', prefix:'SceneUtils');
#import('package:three.dart/extras/GeometryUtils.dart', prefix:'GeometryUtils');

class NyanCat {
  Math.Random rand = new Math.Random();
  var container, stats;
  var camera, scene, renderer, poptart, face, feet, tail;
  var stars, numStars=10, rainbow, rainChunk, numRainChunks=30;
  var mouseX = 0, mouseY = 0;
  var windowHalfX = window.innerWidth / 2;
  var windowHalfY = window.innerHeight / 2;
  var deltaSum=0, 
      tick=0, 
      frame=0, 
      running=true;
//  var song = document.createElement('audio'), song2 = document.createElement('audio');
  AudioElement song, song2;
  
  NyanCat() {
    song = new AudioElement();
    song2 = new AudioElement();
   
    document.body.elements.add(song);
    document.body.elements.add(song2);

    song.src = "nyanlooped.mp3";
    song2.src = "nyanslow.mp3";
    song.loop = true;
    song2.loop = true;
    song.play();
    
    document.on.mouseMove.add(onDocumentMouseMove, false);
    document.on.mouseDown.add(onDocumentMouseDown, false);
  }
  
  run() {
    init();
    animate(0);
  }
  
  init(){
    container = new DivElement();
    document.body.elements.add(container);

    camera = new PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 0.1, 10000 );
    camera.position.z = 30;
    camera.position.x = 0;
    camera.position.y = 0;
    
    scene = new Scene();
    // TODO: FogExp2 does not inherit correctly. 
    scene.fog = new FogExp2( 0x003366, 0.0095 );
    
    //POPTART
    poptart = new Object3D();
    //    object     x    y    z    w    h    d   color
    helper( poptart,   0,  -2,  -1,  21,  14,   3, 0x222222);
    helper( poptart,   1,  -1,  -1,  19,  16,   3, 0x222222);
    helper( poptart,   2,   0,  -1,  17,  18,   3, 0x222222);
    
    helper( poptart,   1,  -2,-1.5,  19,  14,   4, 0xffcc99);
    helper( poptart,   2,  -1,-1.5,  17,  16,   4, 0xffcc99);
    
    helper( poptart,   2,  -4,   2,  17,  10,  .6, 0xff99ff);
    helper( poptart,   3,  -3,   2,  15,  12,  .6, 0xff99ff);
    helper( poptart,   4,  -2,   2,  13,  14,  .6, 0xff99ff);
    
    helper( poptart,   4,  -4,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   9,  -3,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,  12,  -3,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,  16,  -5,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   8,  -7,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   5,  -9,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   9, -10,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   3, -11,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   7, -13,   2,   1,   1,  .7, 0xff3399);
    helper( poptart,   4, -14,   2,   1,   1,  .7, 0xff3399);
    
    poptart.position.x=-10.5;
    poptart.position.y=9;
    scene.add( poptart );
    
    //FEET
    feet = new Object3D();
    helper( feet,   0,  -2, .49,  3,  3,   1, 0x222222);
    helper( feet,   1,  -1, .49,  3,  3,   1, 0x222222);
    helper( feet,   1,  -2,-.01,  2,  2,   2, 0x999999);
    helper( feet,   2,  -1,-.01,  2,  2,   2, 0x999999);
    
    helper( feet,   6,  -2, -.5,  3,  3,   1, 0x222222);
    helper( feet,   6,  -2, -.5,  4,  2,   1, 0x222222);
    helper( feet,   7,  -2,-.99,  2,  2,   2, 0x999999);
    
    helper( feet,   16, -3, .49,  3,  2,   1, 0x222222);
    helper( feet,   15, -2, .49,  3,  2,   1, 0x222222);
    helper( feet,   15, -2,-.01,  2,  1,   2, 0x999999);
    helper( feet,   16, -3,-.01,  2,  1,   2, 0x999999);
    
    helper( feet,   21, -3, -.5,  3,  2,   1, 0x222222);
    helper( feet,   20, -2, -.5,  3,  2,   1, 0x222222);
    helper( feet,   20, -2,-.99,  2,  1,   2, 0x999999);
    helper( feet,   21, -3,-.99,  2,  1,   2, 0x999999);
    
    feet.position.x=-12.5;
    feet.position.y=-6;
    scene.add( feet );
    
    //TAIL
    tail=new Object3D();
    helper( tail,   0,  0,-.25,  4,  3, 1.5, 0x222222);
    helper( tail,   1, -1,-.25,  4,  3, 1.5, 0x222222);
    helper( tail,   2, -2,-.25,  4,  3, 1.5, 0x222222);
    helper( tail,   3, -3,-.25,  4,  3, 1.5, 0x222222);
    helper( tail,   1, -1, -.5,  2,  1,   2, 0x999999);
    helper( tail,   2, -2, -.5,  2,  1,   2, 0x999999);
    helper( tail,   3, -3, -.5,  2,  1,   2, 0x999999);
    helper( tail,   4, -4, -.5,  2,  1,   2, 0x999999);
    
    tail.position.x=-16.5;
    tail.position.y=2;
    scene.add( tail );
    
    //FACE
    face=new Object3D();
    helper(    face,   2,  -3,  -3,  12,   9,   4, 0x222222);
    helper(    face,   0,  -5,   0,  16,   5,   1, 0x222222);
    helper(    face,   1,  -1,   0,   4,  10,   1, 0x222222);
    helper(    face,  11,  -1,   0,   4,  10,   1, 0x222222);
    helper(    face,   3, -11,   0,  10,   2,   1, 0x222222);
    helper(    face,   2,   0,   0,   2,   2,   1, 0x222222);
    helper(    face,   4,  -2,   0,   2,   2,   1, 0x222222);
    helper(    face,  12,   0,   0,   2,   2,   1, 0x222222);
    helper(    face,  10,  -2,   0,   2,   2,   1, 0x222222);
    
    helper(    face,   1, -5,   .5,  14,   5,   1, 0x999999);
    helper(    face,   3, -4,   .5,  10,   8,   1, 0x999999);
    helper(    face,   2, -1,   .5,   2,  10,   1, 0x999999);
    helper(    face,  12, -1,   .5,   2,  10,   1, 0x999999);
    helper(    face,   4, -2,   .5,   1,   2,   1, 0x999999);
    helper(    face,   5, -3,   .5,   1,   1,   1, 0x999999);
    helper(    face,  11, -2,   .5,   1,   2,   1, 0x999999);
    helper(    face,  10, -3,   .5,   1,   1,   1, 0x999999);
    //Eyes
    helper(    face,   4,  -6,  .6,   2,   2,   1, 0x222222);
    helper(    face,  11,  -6,  .6,   2,   2,   1, 0x222222);
    helper(    face,3.99,-5.99, .6,1.01,1.01,1.01, 0xffffff);
    helper(   face,10.99,-5.99, .6,1.01,1.01,1.01, 0xffffff);
    //MOUTH
    helper(    face,   5, -10,  .6,   7,   1,   1, 0x222222);
    helper(    face,   5,  -9,  .6,   1,   2,   1, 0x222222);
    helper(    face,   8,  -9,  .6,   1,   2,   1, 0x222222);
    helper(    face,  11,  -9,  .6,   1,   2,   1, 0x222222);
    //CHEEKS
    helper(    face,   2,  -8,  .6,   2,   2, .91, 0xff9999);
    helper(    face,  13,  -8,  .6,   2,   2, .91, 0xff9999);
    
    face.position.x=-.5;
    face.position.y=4;
    face.position.z=4;
    scene.add(face);
    
    //RAINBOW
    rainbow=new Object3D();
    for(var c=0;c<numRainChunks-1;c++){
      var yOffset=8;
      if(c%2==1) yOffset=7;
      var xOffset=(-c*8)-16.5;
      helper( rainbow,xOffset,yOffset,    0, 8, 3, 1, 0xff0000);
      helper( rainbow,xOffset,yOffset-3,  0, 8, 3, 1, 0xff9900);
      helper( rainbow,xOffset,yOffset-6,  0, 8, 3, 1, 0xffff00);
      helper( rainbow,xOffset,yOffset-9,  0, 8, 3, 1, 0x33ff00);
      helper( rainbow,xOffset,yOffset-12, 0, 8, 3, 1, 0x0099ff);
      helper( rainbow,xOffset,yOffset-15, 0, 8, 3, 1, 0x6633ff);
    }
    scene.add( rainbow );
    
    rainChunk=new Object3D();
    helper( rainChunk, -16.5,  7,  0, 8,  3,   1, 0xff0000);
    helper( rainChunk, -16.5,  4,  0, 8,  3,   1, 0xff9900);
    helper( rainChunk, -16.5,  1,  0, 8,  3,   1, 0xffff00);
    helper( rainChunk, -16.5, -2,  0, 8,  3,   1, 0x33ff00);
    helper( rainChunk, -16.5, -5,  0, 8,  3,   1, 0x0099ff);
    helper( rainChunk, -16.5, -8,  0, 8,  3,   1, 0x6633ff);
    rainChunk.position.x-=(8*(numRainChunks-1));
    scene.add( rainChunk );
    
    stars=new List();
    for(var state=0;state<6;state++){
      stars.add(new List());
      for(var c=0;c<numStars;c++){
        var star = new Object3D();
        star.position.x=rand.nextDouble() * 200 - 100;
        star.position.y=rand.nextDouble() * 200 - 100;
        star.position.z=rand.nextDouble() * 200 - 100;
        buildStar(star, state);
        scene.add( star );
        stars[state].add(star);
      }
    }
    
    var pointLight = new PointLight( 0xFFFFFF );
    pointLight.position.z = 1000;
    scene.add(pointLight);
    
    renderer = new WebGLRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.elements.add( renderer.domElement );
  }
  animate(t){
    window.requestAnimationFrame(animate);
    //requestAnimationFrame( animate );
    render(t);
  }
  render(t){
    var delta = t; //clock.getDelta();
    if(running) deltaSum+=delta;
    if(deltaSum>.07){
      deltaSum=deltaSum%.07;
      frame=(frame+1)%12;
      for(var c=0;c<numStars;c++){
        var tempX=stars[5][c].position.x,
            tempY=stars[5][c].position.y,
            tempZ=stars[5][c].position.z;
        for(var state=5;state>0;state--){
          var star=stars[state][c];
          var star2=stars[state-1][c];
          star.position.x=star2.position.x-8;
          star.position.y=star2.position.y;
          star.position.z=star2.position.z;
          
          if(star.position.x<-100){
            star.position.x+=200;
            star.position.y = rand.nextDouble() * 200 - 100;
            star.position.z = rand.nextDouble() * 200 - 100;
          }
        }
        stars[0][c].position.x=tempX;
        stars[0][c].position.y=tempY;
        stars[0][c].position.z=tempZ;
      }
      switch(frame){
        case 0://2nd frame
        face.position.x++;
        feet.position.x++;
        break;
        case 1:
          face.position.y--;
          feet.position.x++;
          feet.position.y--;
          poptart.position.y--;
          rainbow.position.x-=9;
          rainChunk.position.x+=(8*(numRainChunks-1))-1;
          break;
        case 2:
          feet.position.x--;
          break;
        case 3:
          face.position.x--;
          feet.position.x--;
          rainbow.position.x+=9;
          rainChunk.position.x-=(8*(numRainChunks-1))-1;
          break;
        case 4:
          face.position.y++;
          break;
        case 5:
          poptart.position.y++;
          feet.position.y++;
          rainbow.position.x-=9;
          rainChunk.position.x+=(8*(numRainChunks-1))-1;
          break;
        case 6://8th frame
        face.position.x++;
        feet.position.x++;
        break;
        case 7:
          poptart.position.y--;
          face.position.y--;
          feet.position.x++;
          feet.position.y--;
          rainbow.position.x+=9;
          rainChunk.position.x-=(8*(numRainChunks-1))-1;
          break;
        case 8:
          feet.position.x--;
          break;
        case 9:
          face.position.x--;
          feet.position.x--;
          rainbow.position.x-=9;
          rainChunk.position.x+=(8*(numRainChunks-1))-1;
          break;
        case 10:
          face.position.y++;
          break;
        case 11://1st frame
        poptart.position.y++;
        feet.position.y++;
        rainbow.position.x+=9;
        rainChunk.position.x-=(8*(numRainChunks-1))-1;
        break;
      }
    }
    camera.position.x += ( mouseX - camera.position.x ) * .005;
    camera.position.y += ( - mouseY - camera.position.y ) * .005;
    camera.lookAt( scene.position );
    renderer.render( scene, camera );
  }
  
  helper(o, x, y, z, w, h, d, c){
    var material = new MeshLambertMaterial(color: c);
    var geometry = new CubeGeometry(w, h, d, 1, 1, 1);
    var mesh = new Mesh( geometry, material );
    mesh.position.x=x+(w/2);
    mesh.position.y=y-(h/2);
    mesh.position.z=z+(d/2);
    o.add( mesh );
  }
  
  buildStar(star, state) {
    switch(state){
      case 0:
        helper( star, 0, 0, 0, 1, 1, 1, 0xffffff);
        break;
      case 1:
        helper( star, 1, 0, 0, 1, 1, 1, 0xffffff);
        helper( star,-1, 0, 0, 1, 1, 1, 0xffffff);
        helper( star, 0, 1, 0, 1, 1, 1, 0xffffff);
        helper( star, 0,-1, 0, 1, 1, 1, 0xffffff);
        break;
      case 2:
        helper( star, 1, 0, 0, 2, 1, 1, 0xffffff);
        helper( star,-2, 0, 0, 2, 1, 1, 0xffffff);
        helper( star, 0, 2, 0, 1, 2, 1, 0xffffff);
        helper( star, 0,-1, 0, 1, 2, 1, 0xffffff);
        break;
      case 3:
        helper( star, 0, 0, 0, 1, 1, 1, 0xffffff);
        helper( star, 2, 0, 0, 2, 1, 1, 0xffffff);
        helper( star,-3, 0, 0, 2, 1, 1, 0xffffff);
        helper( star, 0, 3, 0, 1, 2, 1, 0xffffff);
        helper( star, 0,-2, 0, 1, 2, 1, 0xffffff);
        break;
      case 4:
        helper( star, 0, 3, 0, 1, 1, 1, 0xffffff);
        helper( star, 2, 2, 0, 1, 1, 1, 0xffffff);
        helper( star, 3, 0, 0, 1, 1, 1, 0xffffff);
        helper( star, 2,-2, 0, 1, 1, 1, 0xffffff);
        helper( star, 0,-3, 0, 1, 1, 1, 0xffffff);
        helper( star,-2,-2, 0, 1, 1, 1, 0xffffff);
        helper( star,-3, 0, 0, 1, 1, 1, 0xffffff);
        helper( star,-2, 2, 0, 1, 1, 1, 0xffffff);
        break;
      case 5:
        helper( star, 2, 0, 0, 1, 1, 1, 0xffffff);
        helper( star,-2, 0, 0, 1, 1, 1, 0xffffff);
        helper( star, 0, 2, 0, 1, 1, 1, 0xffffff);
        helper( star, 0,-2, 0, 1, 1, 1, 0xffffff);
        break;
    }
  }
  onDocumentMouseMove(event){
    mouseX = ( event.clientX - windowHalfX );
    mouseY = ( event.clientY - windowHalfY );
  }
  onDocumentMouseDown(event){
    running=!running;
    if(running){
      song.play();
      song2.pause();
    }else{
      song.pause();
      song2.play();
    }
  }
  
}

void main() {
  new NyanCat().run();
}