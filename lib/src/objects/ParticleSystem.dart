part of three;

class ParticleSystem extends Object3D {
  Geometry geometry;
  Material material;
  bool sortParticles;

  ParticleSystem(this.geometry, [this.material = null]) : sortParticles = false, super() {
  	if (material == null) {
  		material = new ParticleBasicMaterial( color: new Math.Random().nextDouble() * 0xffffff );
  	}

  	if ( geometry != null) {
  		// calc bound radius
  		if( geometry.boundingSphere == null) {
  			geometry.computeBoundingSphere();
  		}
  		boundRadius = geometry.boundingSphere.radius;
  	}

  	frustumCulled = false;
  }

}