part of three;

class SkinnedMesh extends Mesh {
	bool useVertexTexture;
	num boneTextureWidth, boneTextureHeight;
	List bones;
	List boneMatrices;
	Matrix4 identityMatrix;
	DataTexture boneTexture;

	SkinnedMesh( geometry, material, {this.useVertexTexture: true} )
      : identityMatrix = new Matrix4.identity(),
        bones = [],
        boneMatrices = [],
        super(geometry, material) {

    var gbone, bone;
    var p, q, s;

    if ( geometry["bones"] != null ) {

      for( gbone in geometry["bones"]) {

        p = gbone.pos;
        q = gbone.rotq;
        s = gbone.scl;

        bone = addBone();

        bone.name = gbone.name;
        bone.position.set( p[0], p[1], p[2] );
        bone.quaternion.set( q[0], q[1], q[2], q[3] );
        bone.useQuaternion = true;

        if ( s != null ) {

          bone.scale.set( s[0], s[1], s[2] );

        } else {

          bone.scale.set( 1, 1, 1 );

        }

      }

      for ( var b = 0; b < this.bones.length; b ++ ) {

        gbone = geometry["bones"][ b ];
        bone = bones[ b ];

        if ( gbone.parent == -1 ) {

          this.add( bone );

        } else {

          bones[ gbone.parent ].add( bone );

        }

      }

      //

      var nBones = bones.length;

      if ( useVertexTexture ) {

        // layout (1 matrix = 4 pixels)
        //  RGBA RGBA RGBA RGBA (=> column1, column2, column3, column4)
        //  with  8x8  pixel texture max   16 bones  (8 * 8  / 4)
        //     16x16 pixel texture max   64 bones (16 * 16 / 4)
        //     32x32 pixel texture max  256 bones (32 * 32 / 4)
        //     64x64 pixel texture max 1024 bones (64 * 64 / 4)

        var size;

        if ( nBones > 256 ) {
          size = 64;
        } else if ( nBones > 64 ) {
          size = 32;
        } else if ( nBones > 16 ) {
          size = 16;
        } else {
          size = 8;
        }

        boneTextureWidth = size;
        boneTextureHeight = size;
        boneMatrices = new Float32List( boneTextureWidth * boneTextureHeight * 4 ); // 4 floats per RGBA pixel
        boneTexture = new DataTexture( boneMatrices, boneTextureWidth, boneTextureHeight, RGBAFormat, type: FloatType );
        boneTexture.minFilter = NearestFilter;
        boneTexture.magFilter = NearestFilter;
        boneTexture.generateMipmaps = false;
        boneTexture.flipY = false;

      } else {

        boneMatrices = new Float32List( 16 * nBones );

      }

      pose();

    }
	}

	addBone( {Bone bone} ) {

	  if ( bone == null ) {
	    bone = new Bone( this );
	  }

	  bones.add( bone );

	  return bone;

	}

	updateMatrixWorld({force: false}) {

	  if(matrixAutoUpdate) updateMatrix();

	  // update matrixWorld

	  if ( matrixWorldNeedsUpdate || force ) {

	    if ( parent != null) {

	      matrixWorld = parent.matrixWorld * matrix;

	    } else {

	      matrixWorld.setFrom( matrix );

	    }

	    matrixWorldNeedsUpdate = false;

	    force = true;

	  }

	  // update children
	  children.forEach((child) {

	    if ( child is Bone ) {
	      child.update( identityMatrix, false );
	    } else {
	      child.updateMatrixWorld( true );
	    }

	  });

	  // flatten bone matrices to array

	  var b, bl = this.bones.length,
	      ba = this.bones,
	      bm = this.boneMatrices;

	  for ( b = 0; b < bl; b ++ ) {
	    ba[ b ].skinMatrix.flattenToArrayOffset( bm, b * 16 );

	  }

	  if ( useVertexTexture ) {
	    boneTexture.needsUpdate = true;
	  }

	}

	/*
	 * Pose
	 */

	pose() {

	  updateMatrixWorld( force: true );

	  var bim, bone;

	  List<Matrix4> boneInverses = [];

	  for ( var b = 0; b < bones.length; b ++ ) {

	    bone = bones[ b ];

	    var inverseMatrix = bone.skinMatrix.clone();
	    inverseMatrix.invert();

	    boneInverses.add( inverseMatrix );

	    bone.skinMatrix.flattenToArrayOffset( boneMatrices, b * 16 );

	  }

	  // project vertices to local

	  if ( geometry["skinVerticesA"] == null ) {

	    geometry["skinVerticesA"] = [];
	    geometry["skinVerticesA"] = [];

	    var orgVertex, vertex;

	    for ( var i = 0; i < geometry.skinIndices.length; i ++ ) {

	      orgVertex = geometry.vertices[ i ];

	      var indexA = geometry.skinIndices[ i ].x;
	      var indexB = geometry.skinIndices[ i ].y;

	      vertex = new Vector3( orgVertex.x, orgVertex.y, orgVertex.z );
	      geometry["skinVerticesA"].add(vertex.applyProjection(boneInverses[indexA]));

	      vertex = new Vector3( orgVertex.x, orgVertex.y, orgVertex.z );
	      geometry["skinVerticesA"].add(vertex.applyProjection(boneInverses[indexB]));

	      // todo: add more influences

	      // normalize weights

	      if ( geometry.skinWeights[ i ].x + geometry.skinWeights[ i ].y != 1 ) {

	        var len = ( 1.0 - ( geometry.skinWeights[ i ].x + geometry.skinWeights[ i ].y ) ) * 0.5;
	        geometry.skinWeights[ i ].x += len;
	        geometry.skinWeights[ i ].y += len;

	      }

	    }

	  }

	}

}