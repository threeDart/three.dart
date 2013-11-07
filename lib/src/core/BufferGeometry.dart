// r58
// TODO - dispatch events
part of three;

class GeometryAttribute<T> {
  static final String POSITION = "position";
  static final String NORMAL = "normal";
  static final String INDEX = "index";
  static final String UV = "uv";
  static final String TANGENT = "tangent";
  static final String COLOR = "color";
  int numItems, itemSize;
  T array;

  // Used in WebGL Renderer
  Buffer buffer;

  GeometryAttribute._internal(this.numItems, this.itemSize, this.array);

  factory GeometryAttribute.float32(int numItems, [int itemSize = 1]) =>
    new GeometryAttribute<Float32List>._internal(numItems, itemSize, new Float32List(numItems));

  factory GeometryAttribute.int16(int numItems, [int itemSize = 1]) =>
      new GeometryAttribute<Int16List>._internal(numItems, itemSize, new Int16List(numItems));

}

class Chunk {
  int start, count, index;
  Chunk({this.start, this.count, this.index});
}

// TODO - Create a IGeometry with only the necessary interface methods
class BufferGeometry implements Geometry {

	int id = GeometryCount ++;

	// attributes
	Map<String, GeometryAttribute> attributes = {};

  // offsets for chunks when using indexed elements
	List<Chunk> offsets = [];

	// attributes typed arrays are kept only if dynamic flag is set
	bool _dynamic = false;

	// boundings
	var boundingBox = null;
	var boundingSphere = null;

	bool hasTangents;

	// for compatibility
	List morphTargets = [];
	List morphNormals = [];

	applyMatrix ( Matrix4 matrix ) {

		var positionArray;
		var normalArray;

		if ( aPosition != null ) positionArray = aPosition.array;
		if ( aNormal != null ) normalArray = aNormal.array;

		if ( positionArray != null) {

			multiplyVector3Array(matrix, positionArray);
			this["verticesNeedUpdate"] = true;

		}

		if ( normalArray != null ) {

			var matrixRotation = new Matrix4.identity();
			extractRotation( matrixRotation, matrix );

			multiplyVector3Array(matrixRotation, normalArray );
			this["normalsNeedUpdate"] = true;

		}

	}

	computeBoundingBox () {

		if ( boundingBox == null ) {

			boundingBox = new BoundingBox(
				min: new Vector3( double.INFINITY, double.INFINITY, double.INFINITY ),
				max: new Vector3( -double.INFINITY, -double.INFINITY, -double.INFINITY )
			);

		}

		var positions = aPosition.array;

		if ( positions ) {

			var bb = boundingBox;
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

			boundingBox.min.setValues( 0, 0, 0 );
			boundingBox.max.setValues( 0, 0, 0 );

		}

	}

	computeBoundingSphere() {

		if ( boundingSphere == null ) boundingSphere = new BoundingSphere( radius: 0 );

		var positions = aPosition.array;

		if ( positions != null ) {

			var radiusSq, maxRadiusSq = 0;
			var x, y, z;

			for ( var i = 0, il = positions.length; i < il; i += 3 ) {

				x = positions[ i ];
				y = positions[ i + 1 ];
				z = positions[ i + 2 ];

				radiusSq =  x * x + y * y + z * z;
				if ( radiusSq > maxRadiusSq ) maxRadiusSq = radiusSq;

			}

			boundingSphere.radius = Math.sqrt( maxRadiusSq );

		}

	}

	computeVertexNormals() {

		if ( aPosition != null && aIndex != null ) {

			var i, il;
			var j, jl;

			if ( aNormal == null ) {

				attributes[ GeometryAttribute.NORMAL ] = new GeometryAttribute.float32(aPosition.numItems, 3);

			} else {

				// reset existing normals to zero
			  il = aNormal.array.length;

				for ( i = 0; i < il; i ++ ) {

					attributes[ "normal" ].array[ i ] = 0.0;

				}

			}

			var indices = aIndex.array;
			var positions = aPosition.array;
			var normals = aNormal.array;

			var vA, vB, vC, x, y, z,

			pA = new Vector3.zero(),
			pB = new Vector3.zero(),
			pC = new Vector3.zero(),

			cb = new Vector3.zero(),
			ab = new Vector3.zero();

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

					cb = pC - pB;
					ab = pA - pB;
					cb = cb.cross( ab );

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

			this["normalsNeedUpdate"] = true;

		}

	}

	computeTangents() {

		// based on http://www.terathon.com/code/tangent.html
		// (per vertex tangents)

		if ( aIndex == null || aPosition == null || aNormal == null || aUV == null ) {

			print( "Missing required attributes (index, position, normal or uv) in BufferGeometry.computeTangents()" );
			return;

		}

		var indices = aIndex.array;
		var positions = aPosition.array;
		var normals = aNormal.array;
		var uvs = aUV.array;

		var nVertices = aPosition.numItems ~/ 3;

		if ( aTangent == null ) {

			attributes[ "tangent" ] = new GeometryAttribute.float32(nVertices, 4);

		}

		var tangents = aTangent.array;

		List<Vector3> tan1 = [], tan2 = [];

		for ( var k = 0; k < nVertices; k ++ ) {

			tan1[ k ] = new Vector3.zero();
			tan2[ k ] = new Vector3.zero();

		}

		var xA, yA, zA,
			xB, yB, zB,
			xC, yC, zC,

			uA, vA,
			uB, vB,
			uC, vC,

			x1, x2, y1, y2, z1, z2,
			s1, s2, t1, t2, r;

		var sdir = new Vector3.zero(),
		    tdir = new Vector3.zero();

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

			tan1[ a ].add( sdir );
			tan1[ b ].add( sdir );
			tan1[ c ].add( sdir );

			tan2[ a ].add( tdir );
			tan2[ b ].add( tdir );
			tan2[ c ].add( tdir );

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

		var tmp = new Vector3.zero(),
		    tmp2 = new Vector3.zero();
		var n = new Vector3.zero(),
		    n2 = new Vector3.zero();
		var w, t, test;
		var nx, ny, nz;

		var handleVertex = ( v ) {

			n.x = normals[ v * 3 ];
			n.y = normals[ v * 3 + 1 ];
			n.z = normals[ v * 3 + 2 ];

			n2.setFrom( n );

			t = tan1[ v ];

			// Gram-Schmidt orthogonalize

			tmp.setFrom( t );
			tmp.sub( n.scale( n.dot( t ) ) ).normalize();

			// Calculate handedness

			tmp2 = n2.cross( t );
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
		this["tangentsNeedUpdate"] = true;

	}

  // dynamic is a reserved word in Dart
  bool get isDynamic => _dynamic;
  set isDynamic(bool value) => _dynamic = value;

  // default attributes
  GeometryAttribute<Float32List> get aPosition => attributes[GeometryAttribute.POSITION];
  set aPosition(a){ attributes[GeometryAttribute.POSITION] = a; }

  GeometryAttribute<Float32List> get aNormal => attributes[GeometryAttribute.NORMAL];
  set aNormal(a){ attributes[GeometryAttribute.NORMAL] = a; }

  GeometryAttribute<Int16List> get aIndex => attributes[GeometryAttribute.INDEX];
  set aIndex(a){ attributes[GeometryAttribute.INDEX] = a; }

  GeometryAttribute<Float32List> get aUV => attributes[GeometryAttribute.UV];
  set aUV(a){ attributes[GeometryAttribute.UV] = a; }

  GeometryAttribute<Float32List> get aTangent => attributes[GeometryAttribute.TANGENT];
  set aTangent(a){ attributes[GeometryAttribute.TANGENT] = a; }

  GeometryAttribute<Float32List> get aColor => attributes[GeometryAttribute.COLOR];
  set aColor(a){ attributes[GeometryAttribute.COLOR] = a; }

  noSuchMethod(Invocation invocation) {
    throw new Exception('Unimplemented ${invocation.memberName}');
  }

	 // Quick hack to allow setting new properties (used by the renderer)
  Map __data;

  get _data {
    if (__data == null) {
      __data = {};
    }
    return __data;
  }

  operator [] (String key) => _data[key];
  operator []= (String key, value) => _data[key] = value;

}