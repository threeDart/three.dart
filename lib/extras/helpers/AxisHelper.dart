part of three;

class AxisHelper extends Object3D {
  AxisHelper() {
    var lineGeometry = new Geometry();
    lineGeometry.vertices.add( new Vector3() );
    lineGeometry.vertices.add( new Vector3( 0, 100, 0 ) );

    var coneGeometry = new CylinderGeometry( 0, 5, 25, 5, 1 );

    var line, cone;

    // x

    line = new Line( lineGeometry, new LineBasicMaterial( color: 0xff0000 ) );
    line.rotation.z = - Math.PI / 2;
    this.add( line );

    cone = new Mesh( coneGeometry, new MeshBasicMaterial( color: 0xff0000 ) );
    cone.position.x = 100;
    cone.rotation.z = - Math.PI / 2;
    this.add( cone );

    // y

    line = new Line( lineGeometry, new LineBasicMaterial( color: 0x00ff00 ) );
    this.add( line );

    cone = new Mesh( coneGeometry, new MeshBasicMaterial( color: 0x00ff00 ) );
    cone.position.y = 100;
    this.add( cone );

    // z

    line = new Line( lineGeometry, new LineBasicMaterial( color: 0x0000ff ) );
    line.rotation.x = Math.PI / 2;
    this.add( line );

    cone = new Mesh( coneGeometry, new MeshBasicMaterial( color: 0x0000ff ) );
    cone.position.z = 100;
    cone.rotation.x = Math.PI / 2;
    this.add( cone );
  }
}
