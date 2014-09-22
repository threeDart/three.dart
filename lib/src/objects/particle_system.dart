part of three;

class ParticleSystem extends Object3D {

  bool sortParticles;

  ParticleSystem(Geometry geometry, [Material material = null]) : sortParticles = false, super() {
  	if (material == null) {
  		material = new ParticleBasicMaterial( color: new Math.Random().nextDouble() * 0xffffff );
  	}
    this.material= material;

  	if ( geometry != null) {
  		// calc bound radius
  		if( geometry.boundingSphere == null) {
  			geometry.computeBoundingSphere();
  		}
  		boundRadius = geometry.boundingSphere.radius;
  		this.geometry = geometry;
  	}

  	frustumCulled = false;
  }

}