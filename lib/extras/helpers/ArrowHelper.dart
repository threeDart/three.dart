part of three;

class ArrowHelper extends Object3D {

  Line line;
  Mesh cone;

  ArrowHelper(dir, [Vector3 origin = null, double length = 20.0, hex = 0xffff00] ) : super() {

    var lineGeometry = new Geometry();
    lineGeometry.vertices.add( new Vector3.zero() );
    lineGeometry.vertices.add( new Vector3( 0.0, 1.0, 0.0 ) );

    this.line = new Line( lineGeometry, new LineBasicMaterial( color: hex ) );
    this.add( this.line );

    var coneGeometry = new CylinderGeometry( 0.0, 0.05, 0.25, 5, 1 );

    this.cone = new Mesh( coneGeometry, new MeshBasicMaterial( color: hex ) );
    this.cone.position.setValues( 0.0, 1.0, 0.0 );
    this.add( this.cone );

    if ( origin != null ) this.position = origin;

    this.setDirection( dir );
    this.setLength( length );
  }

  setDirection( dir ) {

    var axis = new Vector3( 0.0, 1.0, 0.0 ).cross( dir );

    var radians = Math.acos( new Vector3( 0.0, 1.0, 0.0 ).dot( dir.clone().normalize() ) );

    this.matrix = new Matrix4.identity().rotate( axis.normalize(), radians );

    this.rotation = calcEulerFromRotationMatrix( this.matrix, this.eulerOrder );
  }

  Vector3 setLength(double length ) => scale.setValues( length, length, length );

}
