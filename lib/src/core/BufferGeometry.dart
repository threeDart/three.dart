part of three;

class BufferGeometry {

	int id;

	// attributes
	Map attributes;

	// attributes typed arrays are kept only if dynamic flag is set
	bool _dynamic;

	// boundings
	var boundingBox;
	var boundingSphere;

	bool hasTangents;

	// for compatibility
	List morphTargets;

	bool verticesNeedUpdate, normalsNeedUpdate, tangentsNeedUpdate;
	bool elementsNeedUpdate, uvsNeedUpdate,colorsNeedUpdate;

	var offsets;

	BufferGeometry() :
		id = GeometryCount ++,
		attributes = {},
		_dynamic = false,
		boundingBox = null,
		boundingSphere = null,
		hasTangents = false,
		morphTargets = [];

	applyMatrix ( matrix ) {

		var positionArray;
		var normalArray;

		if ( this.attributes[ "position" ] ) positionArray = this.attributes[ "position" ].array;
		if ( this.attributes[ "normal" ] ) normalArray = this.attributes[ "normal" ].array;

		if ( positionArray != null) {

			matrix.multiplyVector3Array( positionArray );
			this.verticesNeedUpdate = true;

		}

		if ( normalArray != null ) {

			var matrixRotation = new Matrix4();
			matrixRotation.extractRotation( matrix );

			matrixRotation.multiplyVector3Array( normalArray );
			this.normalsNeedUpdate = true;

		}

	}

	computeBoundingBox () {

		if ( boundingBox == null ) {

			this.boundingBox = new BoundingBox(
				min: new Vector3( double.INFINITY, double.INFINITY, double.INFINITY ),
				max: new Vector3( -double.INFINITY, -double.INFINITY, -double.INFINITY )
			);

		}

		var positions = this.attributes[ "position" ].array;

		if ( positions ) {

			var bb = this.boundingBox;
			var x, y, z;

			for ( var i = 0, il = positions.length; i < il; i += 3 ) {

				x = positions[ i ];
				y = positions[ i + 1 ];
				z = positions[ i + 2 ];

				// bounding box

				if ( x < bb.min.x ) {

					bb.min.x = x;

				} else if ( x > bb.max.x ) {

					bb.max.x = x;

				}

				if ( y < bb.min.y ) {

					bb.min.y = y;

				} else if ( y > bb.max.y ) {

					bb.max.y = y;

				}

				if ( z < bb.min.z ) {

					bb.min.z = z;

				} else if ( z > bb.max.z ) {

					bb.max.z = z;

				}

			}

		}

		if ( positions == null || positions.length == 0 ) {

			this.boundingBox.min.set( 0, 0, 0 );
			this.boundingBox.max.set( 0, 0, 0 );

		}

	}

	computeBoundingSphere() {

		if ( ! this.boundingSphere ) this.boundingSphere = new BoundingSphere( radius: 0 );

		var positions = this.attributes[ "position" ].array;

		if ( positions ) {

			var radiusSq, maxRadiusSq = 0;
			var x, y, z;

			for ( var i = 0, il = positions.length; i < il; i += 3 ) {

				x = positions[ i ];
				y = positions[ i + 1 ];
				z = positions[ i + 2 ];

				radiusSq =  x * x + y * y + z * z;
				if ( radiusSq > maxRadiusSq ) maxRadiusSq = radiusSq;

			}

			this.boundingSphere.radius = Math.sqrt( maxRadiusSq );

		}

	}

	computeVertexNormals() {

		if ( this.attributes[ "position" ] && this.attributes[ "index" ] ) {

			var i, il;
			var j, jl;

			var nVertexElements = this.attributes[ "position" ].array.length;

			if ( this.attributes[ "normal" ] == null ) {

			  var normal = new dynamic();
			  normal.itemSize = 3;
			  normal.array = new Float32Array( nVertexElements );
			  normal.numItems = nVertexElements;
				this.attributes[ "normal" ] = normal;

			} else {

				// reset existing normals to zero
			  il = attributes[ "normal" ].array.length;

				for ( i = 0; i < il; i ++ ) {

					attributes[ "normal" ].array[ i ] = 0;

				}

			}

			var indices = this.attributes[ "index" ].array;
			var positions = this.attributes[ "position" ].array;
			var normals = this.attributes[ "normal" ].array;

			var vA, vB, vC, x, y, z,

			pA = new Vector3(),
			pB = new Vector3(),
			pC = new Vector3(),

			cb = new Vector3(),
			ab = new Vector3();

			jl = offsets.length;
			for ( j = 0; j < jl; ++ j ) {

				var start = offsets[ j ].start;
				var count = offsets[ j ].count;
				var index = offsets[ j ].index;

				il = start + count;
				for ( i = start; i < il; i += 3 ) {

					vA = index + indices[ i ];
					vB = index + indices[ i + 1 ];
					vC = index + indices[ i + 2 ];

					x = positions[ vA * 3 ];
					y = positions[ vA * 3 + 1 ];
					z = positions[ vA * 3 + 2 ];
					pA.setValues( x, y, z );

					x = positions[ vB * 3 ];
					y = positions[ vB * 3 + 1 ];
					z = positions[ vB * 3 + 2 ];
					pB.setValues( x, y, z );

					x = positions[ vC * 3 ];
					y = positions[ vC * 3 + 1 ];
					z = positions[ vC * 3 + 2 ];
					pC.setValues( x, y, z );

					cb.sub( pC, pB );
					ab.sub( pA, pB );
					cb.crossSelf( ab );

					normals[ vA * 3 ] += cb.x;
					normals[ vA * 3 + 1 ] += cb.y;
					normals[ vA * 3 + 2 ] += cb.z;

					normals[ vB * 3 ] += cb.x;
					normals[ vB * 3 + 1 ] += cb.y;
					normals[ vB * 3 + 2 ] += cb.z;

					normals[ vC * 3 ] += cb.x;
					normals[ vC * 3 + 1 ] += cb.y;
					normals[ vC * 3 + 2 ] += cb.z;

				}

			}

			// normalize normals
			il = normals.length;
			for ( i = 0; i < il; i += 3 ) {

				x = normals[ i ];
				y = normals[ i + 1 ];
				z = normals[ i + 2 ];

				var n = 1.0 / Math.sqrt( x * x + y * y + z * z );

				normals[ i ] *= n;
				normals[ i + 1 ] *= n;
				normals[ i + 2 ] *= n;

			}

			normalsNeedUpdate = true;

		}

	}

	computeTangents() {

		// based on http://www.terathon.com/code/tangent.html
		// (per vertex tangents)

		if ( attributes[ "index" ] == null ||
			   attributes[ "position" ] == null ||
			   attributes[ "normal" ] == null ||
			   attributes[ "uv" ] == null ) {

			print( "Missing required attributes (index, position, normal or uv) in BufferGeometry.computeTangents()" );
			return;

		}

		var indices = attributes[ "index" ].array;
		var positions = attributes[ "position" ].array;
		var normals = attributes[ "normal" ].array;
		var uvs = attributes[ "uv" ].array;

		var nVertices = positions.length / 3;

		if ( attributes[ "tangent" ] == null ) {

			var nTangentElements = 4 * nVertices;

			var tangent = new dynamic();
			tangent.itemSize = 4;
			tangent.array = new Float32Array( nTangentElements );
      tangent.numItems = nTangentElements;
			attributes[ "tangent" ] = tangent;

		}

		var tangents = attributes[ "tangent" ].array;

		List<Vector3> tan1 = [], tan2 = [];

		for ( var k = 0; k < nVertices; k ++ ) {

			tan1[ k ] = new Vector3();
			tan2[ k ] = new Vector3();

		}

		var xA, yA, zA,
			xB, yB, zB,
			xC, yC, zC,

			uA, vA,
			uB, vB,
			uC, vC,

			x1, x2, y1, y2, z1, z2,
			s1, s2, t1, t2, r;

		var sdir = new Vector3(),
		    tdir = new Vector3();

		var handleTriangle = ( a, b, c ) {

			xA = positions[ a * 3 ];
			yA = positions[ a * 3 + 1 ];
			zA = positions[ a * 3 + 2 ];

			xB = positions[ b * 3 ];
			yB = positions[ b * 3 + 1 ];
			zB = positions[ b * 3 + 2 ];

			xC = positions[ c * 3 ];
			yC = positions[ c * 3 + 1 ];
			zC = positions[ c * 3 + 2 ];

			uA = uvs[ a * 2 ];
			vA = uvs[ a * 2 + 1 ];

			uB = uvs[ b * 2 ];
			vB = uvs[ b * 2 + 1 ];

			uC = uvs[ c * 2 ];
			vC = uvs[ c * 2 + 1 ];

			x1 = xB - xA;
			x2 = xC - xA;

			y1 = yB - yA;
			y2 = yC - yA;

			z1 = zB - zA;
			z2 = zC - zA;

			s1 = uB - uA;
			s2 = uC - uA;

			t1 = vB - vA;
			t2 = vC - vA;

			r = 1.0 / ( s1 * t2 - s2 * t1 );

			sdir.setValues(
				( t2 * x1 - t1 * x2 ) * r,
				( t2 * y1 - t1 * y2 ) * r,
				( t2 * z1 - t1 * z2 ) * r
			);

			tdir.setValues(
				( s1 * x2 - s2 * x1 ) * r,
				( s1 * y2 - s2 * y1 ) * r,
				( s1 * z2 - s2 * z1 ) * r
			);

			tan1[ a ].addSelf( sdir );
			tan1[ b ].addSelf( sdir );
			tan1[ c ].addSelf( sdir );

			tan2[ a ].addSelf( tdir );
			tan2[ b ].addSelf( tdir );
			tan2[ c ].addSelf( tdir );

		};

		var i, il;
		var j, jl;
		var iA, iB, iC;

		jl = offsets.length;
		for ( j = 0; j < jl; ++ j ) {

			var start = offsets[ j ].start;
			var count = offsets[ j ].count;
			var index = offsets[ j ].index;

			il = start + count;
			for ( i = start; i < il; i += 3 ) {

				iA = index + indices[ i ];
				iB = index + indices[ i + 1 ];
				iC = index + indices[ i + 2 ];

				handleTriangle( iA, iB, iC );

			}

		}

		var tmp = new Vector3(),
		    tmp2 = new Vector3();
		var n = new Vector3(),
		    n2 = new Vector3();
		var w, t, test;
		var nx, ny, nz;

		var handleVertex = ( v ) {

			n.x = normals[ v * 3 ];
			n.y = normals[ v * 3 + 1 ];
			n.z = normals[ v * 3 + 2 ];

			n2.copy( n );

			t = tan1[ v ];

			// Gram-Schmidt orthogonalize

			tmp.copy( t );
			tmp.subSelf( n.multiplyScalar( n.dot( t ) ) ).normalize();

			// Calculate handedness

			tmp2.cross( n2, t );
			test = tmp2.dot( tan2[ v ] );
			w = ( test < 0.0 ) ? -1.0 : 1.0;

			tangents[ v * 4 ] 	  = tmp.x;
			tangents[ v * 4 + 1 ] = tmp.y;
			tangents[ v * 4 + 2 ] = tmp.z;
			tangents[ v * 4 + 3 ] = w;

		};

		jl = offsets.length;
		for ( j = 0; j < jl; ++ j ) {

			var start = offsets[ j ].start;
			var count = offsets[ j ].count;
			var index = offsets[ j ].index;

			il = start + count;
			for ( i = start; i < il; i += 3 ) {

				iA = index + indices[ i ];
				iB = index + indices[ i + 1 ];
				iC = index + indices[ i + 2 ];

				handleVertex( iA );
				handleVertex( iB );
				handleVertex( iC );

			}

		}

		hasTangents = true;
		tangentsNeedUpdate = true;

	}

}