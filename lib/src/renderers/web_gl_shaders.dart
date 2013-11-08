// r54
part of three;

var __ShaderChunk;

get ShaderChunk  {
  if (__ShaderChunk == null) {
    __ShaderChunk = {
// FOG

  "fog_pars_fragment": [

    "#ifdef USE_FOG",

      "uniform vec3 fogColor;",

      "#ifdef FOG_EXP2",

        "uniform float fogDensity;",

      "#else",

        "uniform float fogNear;",
        "uniform float fogFar;",

      "#endif",

    "#endif"

  ].join("\n"),

  "fog_fragment": [

    "#ifdef USE_FOG",

      "float depth = gl_FragCoord.z / gl_FragCoord.w;",

      "#ifdef FOG_EXP2",

        "const float LOG2 = 1.442695;",
        "float fogFactor = exp2( - fogDensity * fogDensity * depth * depth * LOG2 );",
        "fogFactor = 1.0 - clamp( fogFactor, 0.0, 1.0 );",

      "#else",

        "float fogFactor = smoothstep( fogNear, fogFar, depth );",

      "#endif",

      "gl_FragColor = mix( gl_FragColor, vec4( fogColor, gl_FragColor.w ), fogFactor );",

    "#endif"

  ].join("\n"),

  // ENVIRONMENT MAP

  "envmap_pars_fragment": [

    "#ifdef USE_ENVMAP",

      "uniform float reflectivity;",
      "uniform samplerCube envMap;",
      "uniform float flipEnvMap;",
      "uniform int combine;",

      "#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP )",

        "uniform bool useRefract;",
        "uniform float refractionRatio;",

      "#else",

        "varying vec3 vReflect;",

      "#endif",

    "#endif"

  ].join("\n"),

  "envmap_fragment": [

    "#ifdef USE_ENVMAP",

      "vec3 reflectVec;",

      "#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP )",

        "vec3 cameraToVertex = normalize( vWorldPosition - cameraPosition );",

        "if ( useRefract ) {",

          "reflectVec = refract( cameraToVertex, normal, refractionRatio );",

        "} else { ",

          "reflectVec = reflect( cameraToVertex, normal );",

        "}",

      "#else",

        "reflectVec = vReflect;",

      "#endif",

      "#ifdef DOUBLE_SIDED",

        "float flipNormal = ( -1.0 + 2.0 * float( gl_FrontFacing ) );",
        "vec4 cubeColor = textureCube( envMap, flipNormal * vec3( flipEnvMap * reflectVec.x, reflectVec.yz ) );",

      "#else",

        "vec4 cubeColor = textureCube( envMap, vec3( flipEnvMap * reflectVec.x, reflectVec.yz ) );",

      "#endif",

      "#ifdef GAMMA_INPUT",

        "cubeColor.xyz *= cubeColor.xyz;",

      "#endif",

      "if ( combine == 1 ) {",

        "gl_FragColor.xyz = mix( gl_FragColor.xyz, cubeColor.xyz, specularStrength * reflectivity );",

      "} else if ( combine == 2 ) {",

        "gl_FragColor.xyz += cubeColor.xyz * specularStrength * reflectivity;",

      "} else {",

        "gl_FragColor.xyz = mix( gl_FragColor.xyz, gl_FragColor.xyz * cubeColor.xyz, specularStrength * reflectivity );",

      "}",

    "#endif"

  ].join("\n"),

  "envmap_pars_vertex": [

    "#if defined( USE_ENVMAP ) && ! defined( USE_BUMPMAP ) && ! defined( USE_NORMALMAP )",

      "varying vec3 vReflect;",

      "uniform float refractionRatio;",
      "uniform bool useRefract;",

    "#endif"

  ].join("\n"),

  "worldpos_vertex" : [

    "#if defined( USE_ENVMAP ) || defined( PHONG ) || defined( LAMBERT ) || defined ( USE_SHADOWMAP )",

      "#ifdef USE_SKINNING",

        "vec4 worldPosition = modelMatrix * skinned;",

      "#endif",

      "#if defined( USE_MORPHTARGETS ) && ! defined( USE_SKINNING )",

        "vec4 worldPosition = modelMatrix * vec4( morphed, 1.0 );",

      "#endif",

      "#if ! defined( USE_MORPHTARGETS ) && ! defined( USE_SKINNING )",

        "vec4 worldPosition = modelMatrix * vec4( position, 1.0 );",

      "#endif",

    "#endif"

  ].join("\n"),

  "envmap_vertex" : [

    "#if defined( USE_ENVMAP ) && ! defined( USE_BUMPMAP ) && ! defined( USE_NORMALMAP )",

      "vec3 worldNormal = mat3( modelMatrix[ 0 ].xyz, modelMatrix[ 1 ].xyz, modelMatrix[ 2 ].xyz ) * objectNormal;",
      "worldNormal = normalize( worldNormal );",

      "vec3 cameraToVertex = normalize( worldPosition.xyz - cameraPosition );",

      "if ( useRefract ) {",

        "vReflect = refract( cameraToVertex, worldNormal, refractionRatio );",

      "} else {",

        "vReflect = reflect( cameraToVertex, worldNormal );",

      "}",

    "#endif"

  ].join("\n"),

  // COLOR MAP (particles)

  "map_particle_pars_fragment": [

    "#ifdef USE_MAP",

      "uniform sampler2D map;",

    "#endif"

  ].join("\n"),


  "map_particle_fragment": [

    "#ifdef USE_MAP",

      "gl_FragColor = gl_FragColor * texture2D( map, vec2( gl_PointCoord.x, 1.0 - gl_PointCoord.y ) );",

    "#endif"

  ].join("\n"),

  // COLOR MAP (triangles)

  "map_pars_vertex": [

    "#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP )",

      "varying vec2 vUv;",
      "uniform vec4 offsetRepeat;",

    "#endif"

  ].join("\n"),

  "map_pars_fragment": [

    "#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP )",

      "varying vec2 vUv;",

    "#endif",

    "#ifdef USE_MAP",

      "uniform sampler2D map;",

    "#endif"

  ].join("\n"),

  "map_vertex": [

    "#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP )",

      "vUv = uv * offsetRepeat.zw + offsetRepeat.xy;",

    "#endif"

  ].join("\n"),

  "map_fragment": [

    "#ifdef USE_MAP",

      "vec4 texelColor = texture2D( map, vUv );",

      "#ifdef GAMMA_INPUT",

        "texelColor.xyz *= texelColor.xyz;",

      "#endif",

      "gl_FragColor = gl_FragColor * texelColor;",

    "#endif"

  ].join("\n"),

  // LIGHT MAP

  "lightmap_pars_fragment": [

    "#ifdef USE_LIGHTMAP",

      "varying vec2 vUv2;",
      "uniform sampler2D lightMap;",

    "#endif"

  ].join("\n"),

  "lightmap_pars_vertex": [

    "#ifdef USE_LIGHTMAP",

      "varying vec2 vUv2;",

    "#endif"

  ].join("\n"),

  "lightmap_fragment": [

    "#ifdef USE_LIGHTMAP",

      "gl_FragColor = gl_FragColor * texture2D( lightMap, vUv2 );",

    "#endif"

  ].join("\n"),

  "lightmap_vertex": [

    "#ifdef USE_LIGHTMAP",

      "vUv2 = uv2;",

    "#endif"

  ].join("\n"),

  // BUMP MAP

  "bumpmap_pars_fragment": [

    "#ifdef USE_BUMPMAP",

      "uniform sampler2D bumpMap;",
      "uniform float bumpScale;",

      // Derivative maps - bump mapping unparametrized surfaces by Morten Mikkelsen
      //  http://mmikkelsen3d.blogspot.sk/2011/07/derivative-maps.html

      // Evaluate the derivative of the height w.r.t. screen-space using forward differencing (listing 2)

      "vec2 dHdxy_fwd() {",

        "vec2 dSTdx = dFdx( vUv );",
        "vec2 dSTdy = dFdy( vUv );",

        "float Hll = bumpScale * texture2D( bumpMap, vUv ).x;",
        "float dBx = bumpScale * texture2D( bumpMap, vUv + dSTdx ).x - Hll;",
        "float dBy = bumpScale * texture2D( bumpMap, vUv + dSTdy ).x - Hll;",

        "return vec2( dBx, dBy );",

      "}",

      "vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy ) {",

        "vec3 vSigmaX = dFdx( surf_pos );",
        "vec3 vSigmaY = dFdy( surf_pos );",
        "vec3 vN = surf_norm;",   // normalized

        "vec3 R1 = cross( vSigmaY, vN );",
        "vec3 R2 = cross( vN, vSigmaX );",

        "float fDet = dot( vSigmaX, R1 );",

        "vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 );",
        "return normalize( abs( fDet ) * surf_norm - vGrad );",

      "}",

    "#endif"

  ].join("\n"),

  // NORMAL MAP

  "normalmap_pars_fragment": [

    "#ifdef USE_NORMALMAP",

      "uniform sampler2D normalMap;",
      "uniform vec2 normalScale;",

      // Per-Pixel Tangent Space Normal Mapping
      // http://hacksoflife.blogspot.ch/2009/11/per-pixel-tangent-space-normal-mapping.html

      "vec3 perturbNormal2Arb( vec3 eye_pos, vec3 surf_norm ) {",

        "vec3 q0 = dFdx( eye_pos.xyz );",
        "vec3 q1 = dFdy( eye_pos.xyz );",
        "vec2 st0 = dFdx( vUv.st );",
        "vec2 st1 = dFdy( vUv.st );",

        "vec3 S = normalize(  q0 * st1.t - q1 * st0.t );",
        "vec3 T = normalize( -q0 * st1.s + q1 * st0.s );",
        "vec3 N = normalize( surf_norm );",

        "vec3 mapN = texture2D( normalMap, vUv ).xyz * 2.0 - 1.0;",
        "mapN.xy = normalScale * mapN.xy;",
        "mat3 tsn = mat3( S, T, N );",
        "return normalize( tsn * mapN );",

      "}",

    "#endif"

  ].join("\n"),

  // SPECULAR MAP

  "specularmap_pars_fragment": [

    "#ifdef USE_SPECULARMAP",

      "uniform sampler2D specularMap;",

    "#endif"

  ].join("\n"),

  "specularmap_fragment": [

    "float specularStrength;",

    "#ifdef USE_SPECULARMAP",

      "vec4 texelSpecular = texture2D( specularMap, vUv );",
      "specularStrength = texelSpecular.r;",

    "#else",

      "specularStrength = 1.0;",

    "#endif"

  ].join("\n"),

  // LIGHTS LAMBERT

  "lights_lambert_pars_vertex": [

    "uniform vec3 ambient;",
    "uniform vec3 diffuse;",
    "uniform vec3 emissive;",

    "uniform vec3 ambientLightColor;",

    "#if MAX_DIR_LIGHTS > 0",

      "uniform vec3 directionalLightColor[ MAX_DIR_LIGHTS ];",
      "uniform vec3 directionalLightDirection[ MAX_DIR_LIGHTS ];",

    "#endif",

    "#if MAX_HEMI_LIGHTS > 0",

      "uniform vec3 hemisphereLightSkyColor[ MAX_HEMI_LIGHTS ];",
      "uniform vec3 hemisphereLightGroundColor[ MAX_HEMI_LIGHTS ];",
      "uniform vec3 hemisphereLightDirection[ MAX_HEMI_LIGHTS ];",

    "#endif",

    "#if MAX_POINT_LIGHTS > 0",

      "uniform vec3 pointLightColor[ MAX_POINT_LIGHTS ];",
      "uniform vec3 pointLightPosition[ MAX_POINT_LIGHTS ];",
      "uniform float pointLightDistance[ MAX_POINT_LIGHTS ];",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

      "uniform vec3 spotLightColor[ MAX_SPOT_LIGHTS ];",
      "uniform vec3 spotLightPosition[ MAX_SPOT_LIGHTS ];",
      "uniform vec3 spotLightDirection[ MAX_SPOT_LIGHTS ];",
      "uniform float spotLightDistance[ MAX_SPOT_LIGHTS ];",
      "uniform float spotLightAngleCos[ MAX_SPOT_LIGHTS ];",
      "uniform float spotLightExponent[ MAX_SPOT_LIGHTS ];",

    "#endif",

    "#ifdef WRAP_AROUND",

      "uniform vec3 wrapRGB;",

    "#endif"

  ].join("\n"),

  "lights_lambert_vertex": [

    "vLightFront = vec3( 0.0 );",

    "#ifdef DOUBLE_SIDED",

      "vLightBack = vec3( 0.0 );",

    "#endif",

    "transformedNormal = normalize( transformedNormal );",

    "#if MAX_DIR_LIGHTS > 0",

    "for( int i = 0; i < MAX_DIR_LIGHTS; i ++ ) {",

      "vec4 lDirection = viewMatrix * vec4( directionalLightDirection[ i ], 0.0 );",
      "vec3 dirVector = normalize( lDirection.xyz );",

      "float dotProduct = dot( transformedNormal, dirVector );",
      "vec3 directionalLightWeighting = vec3( max( dotProduct, 0.0 ) );",

      "#ifdef DOUBLE_SIDED",

        "vec3 directionalLightWeightingBack = vec3( max( -dotProduct, 0.0 ) );",

        "#ifdef WRAP_AROUND",

          "vec3 directionalLightWeightingHalfBack = vec3( max( -0.5 * dotProduct + 0.5, 0.0 ) );",

        "#endif",

      "#endif",

      "#ifdef WRAP_AROUND",

        "vec3 directionalLightWeightingHalf = vec3( max( 0.5 * dotProduct + 0.5, 0.0 ) );",
        "directionalLightWeighting = mix( directionalLightWeighting, directionalLightWeightingHalf, wrapRGB );",

        "#ifdef DOUBLE_SIDED",

          "directionalLightWeightingBack = mix( directionalLightWeightingBack, directionalLightWeightingHalfBack, wrapRGB );",

        "#endif",

      "#endif",

      "vLightFront += directionalLightColor[ i ] * directionalLightWeighting;",

      "#ifdef DOUBLE_SIDED",

        "vLightBack += directionalLightColor[ i ] * directionalLightWeightingBack;",

      "#endif",

    "}",

    "#endif",

    "#if MAX_POINT_LIGHTS > 0",

      "for( int i = 0; i < MAX_POINT_LIGHTS; i ++ ) {",

        "vec4 lPosition = viewMatrix * vec4( pointLightPosition[ i ], 1.0 );",
        "vec3 lVector = lPosition.xyz - mvPosition.xyz;",

        "float lDistance = 1.0;",
        "if ( pointLightDistance[ i ] > 0.0 )",
          "lDistance = 1.0 - min( ( length( lVector ) / pointLightDistance[ i ] ), 1.0 );",

        "lVector = normalize( lVector );",
        "float dotProduct = dot( transformedNormal, lVector );",

        "vec3 pointLightWeighting = vec3( max( dotProduct, 0.0 ) );",

        "#ifdef DOUBLE_SIDED",

          "vec3 pointLightWeightingBack = vec3( max( -dotProduct, 0.0 ) );",

          "#ifdef WRAP_AROUND",

            "vec3 pointLightWeightingHalfBack = vec3( max( -0.5 * dotProduct + 0.5, 0.0 ) );",

          "#endif",

        "#endif",

        "#ifdef WRAP_AROUND",

          "vec3 pointLightWeightingHalf = vec3( max( 0.5 * dotProduct + 0.5, 0.0 ) );",
          "pointLightWeighting = mix( pointLightWeighting, pointLightWeightingHalf, wrapRGB );",

          "#ifdef DOUBLE_SIDED",

            "pointLightWeightingBack = mix( pointLightWeightingBack, pointLightWeightingHalfBack, wrapRGB );",

          "#endif",

        "#endif",

        "vLightFront += pointLightColor[ i ] * pointLightWeighting * lDistance;",

        "#ifdef DOUBLE_SIDED",

          "vLightBack += pointLightColor[ i ] * pointLightWeightingBack * lDistance;",

        "#endif",

      "}",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

    "for( int i = 0; i < MAX_SPOT_LIGHTS; i ++ ) {",

    "vec4 lPosition = viewMatrix * vec4( spotLightPosition[ i ], 1.0 );",
    "vec3 lVector = lPosition.xyz - mvPosition.xyz;",

    "float spotEffect = dot( spotLightDirection[ i ], normalize( spotLightPosition[ i ] - worldPosition.xyz ) );",

    "if ( spotEffect > spotLightAngleCos[ i ] ) {",

    "spotEffect = max( pow( spotEffect, spotLightExponent[ i ] ), 0.0 );",

    "float lDistance = 1.0;",
    "if ( spotLightDistance[ i ] > 0.0 )",
    "lDistance = 1.0 - min( ( length( lVector ) / spotLightDistance[ i ] ), 1.0 );",

    "lVector = normalize( lVector );",

    "float dotProduct = dot( transformedNormal, lVector );",
    "vec3 spotLightWeighting = vec3( max( dotProduct, 0.0 ) );",

    "#ifdef DOUBLE_SIDED",

    "vec3 spotLightWeightingBack = vec3( max( -dotProduct, 0.0 ) );",

    "#ifdef WRAP_AROUND",

    "vec3 spotLightWeightingHalfBack = vec3( max( -0.5 * dotProduct + 0.5, 0.0 ) );",

    "#endif",

    "#endif",

    "#ifdef WRAP_AROUND",

    "vec3 spotLightWeightingHalf = vec3( max( 0.5 * dotProduct + 0.5, 0.0 ) );",
    "spotLightWeighting = mix( spotLightWeighting, spotLightWeightingHalf, wrapRGB );",

    "#ifdef DOUBLE_SIDED",

    "spotLightWeightingBack = mix( spotLightWeightingBack, spotLightWeightingHalfBack, wrapRGB );",

    "#endif",

    "#endif",

    "vLightFront += spotLightColor[ i ] * spotLightWeighting * lDistance * spotEffect;",

    "#ifdef DOUBLE_SIDED",

    "vLightBack += spotLightColor[ i ] * spotLightWeightingBack * lDistance * spotEffect;",

    "#endif",

    "}",

    "}",

    "#endif",

    "#if MAX_HEMI_LIGHTS > 0",

      "for( int i = 0; i < MAX_HEMI_LIGHTS; i ++ ) {",

        "vec4 lDirection = viewMatrix * vec4( hemisphereLightDirection[ i ], 0.0 );",
        "vec3 lVector = normalize( lDirection.xyz );",

        "float dotProduct = dot( transformedNormal, lVector );",

        "float hemiDiffuseWeight = 0.5 * dotProduct + 0.5;",
        "float hemiDiffuseWeightBack = -0.5 * dotProduct + 0.5;",

        "vLightFront += mix( hemisphereLightGroundColor[ i ], hemisphereLightSkyColor[ i ], hemiDiffuseWeight );",

        "#ifdef DOUBLE_SIDED",

          "vLightBack += mix( hemisphereLightGroundColor[ i ], hemisphereLightSkyColor[ i ], hemiDiffuseWeightBack );",

        "#endif",

      "}",

    "#endif",

    "vLightFront = vLightFront * diffuse + ambient * ambientLightColor + emissive;",

    "#ifdef DOUBLE_SIDED",

      "vLightBack = vLightBack * diffuse + ambient * ambientLightColor + emissive;",

    "#endif"

  ].join("\n"),

  // LIGHTS PHONG

  "lights_phong_pars_vertex": [

    "#ifndef PHONG_PER_PIXEL",

    "#if MAX_POINT_LIGHTS > 0",

      "uniform vec3 pointLightPosition[ MAX_POINT_LIGHTS ];",
      "uniform float pointLightDistance[ MAX_POINT_LIGHTS ];",

      "varying vec4 vPointLight[ MAX_POINT_LIGHTS ];",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

      "uniform vec3 spotLightPosition[ MAX_SPOT_LIGHTS ];",
      "uniform float spotLightDistance[ MAX_SPOT_LIGHTS ];",

      "varying vec4 vSpotLight[ MAX_SPOT_LIGHTS ];",

    "#endif",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0 || defined( USE_BUMPMAP )",

      "varying vec3 vWorldPosition;",

    "#endif"

  ].join("\n"),


  "lights_phong_vertex": [

    "#ifndef PHONG_PER_PIXEL",

    "#if MAX_POINT_LIGHTS > 0",

      "for( int i = 0; i < MAX_POINT_LIGHTS; i ++ ) {",

        "vec4 lPosition = viewMatrix * vec4( pointLightPosition[ i ], 1.0 );",
        "vec3 lVector = lPosition.xyz - mvPosition.xyz;",

        "float lDistance = 1.0;",
        "if ( pointLightDistance[ i ] > 0.0 )",
          "lDistance = 1.0 - min( ( length( lVector ) / pointLightDistance[ i ] ), 1.0 );",

        "vPointLight[ i ] = vec4( lVector, lDistance );",

      "}",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

      "for( int i = 0; i < MAX_SPOT_LIGHTS; i ++ ) {",

        "vec4 lPosition = viewMatrix * vec4( spotLightPosition[ i ], 1.0 );",
        "vec3 lVector = lPosition.xyz - mvPosition.xyz;",

        "float lDistance = 1.0;",
        "if ( spotLightDistance[ i ] > 0.0 )",
          "lDistance = 1.0 - min( ( length( lVector ) / spotLightDistance[ i ] ), 1.0 );",

        "vSpotLight[ i ] = vec4( lVector, lDistance );",

      "}",

    "#endif",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0 || defined( USE_BUMPMAP )",

      "vWorldPosition = worldPosition.xyz;",

    "#endif"

  ].join("\n"),

  "lights_phong_pars_fragment": [

    "uniform vec3 ambientLightColor;",

    "#if MAX_DIR_LIGHTS > 0",

      "uniform vec3 directionalLightColor[ MAX_DIR_LIGHTS ];",
      "uniform vec3 directionalLightDirection[ MAX_DIR_LIGHTS ];",

    "#endif",

    "#if MAX_HEMI_LIGHTS > 0",

      "uniform vec3 hemisphereLightSkyColor[ MAX_HEMI_LIGHTS ];",
      "uniform vec3 hemisphereLightGroundColor[ MAX_HEMI_LIGHTS ];",
      "uniform vec3 hemisphereLightDirection[ MAX_HEMI_LIGHTS ];",

    "#endif",

    "#if MAX_POINT_LIGHTS > 0",

      "uniform vec3 pointLightColor[ MAX_POINT_LIGHTS ];",

      "#ifdef PHONG_PER_PIXEL",

        "uniform vec3 pointLightPosition[ MAX_POINT_LIGHTS ];",
        "uniform float pointLightDistance[ MAX_POINT_LIGHTS ];",

      "#else",

        "varying vec4 vPointLight[ MAX_POINT_LIGHTS ];",

      "#endif",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

      "uniform vec3 spotLightColor[ MAX_SPOT_LIGHTS ];",
      "uniform vec3 spotLightPosition[ MAX_SPOT_LIGHTS ];",
      "uniform vec3 spotLightDirection[ MAX_SPOT_LIGHTS ];",
      "uniform float spotLightAngleCos[ MAX_SPOT_LIGHTS ];",
      "uniform float spotLightExponent[ MAX_SPOT_LIGHTS ];",

      "#ifdef PHONG_PER_PIXEL",

        "uniform float spotLightDistance[ MAX_SPOT_LIGHTS ];",

      "#else",

        "varying vec4 vSpotLight[ MAX_SPOT_LIGHTS ];",

      "#endif",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0 || defined( USE_BUMPMAP )",

      "varying vec3 vWorldPosition;",

    "#endif",

    "#ifdef WRAP_AROUND",

      "uniform vec3 wrapRGB;",

    "#endif",

    "varying vec3 vViewPosition;",
    "varying vec3 vNormal;"

  ].join("\n"),

  "lights_phong_fragment": [

    "vec3 normal = normalize( vNormal );",
    "vec3 viewPosition = normalize( vViewPosition );",

    "#ifdef DOUBLE_SIDED",

      "normal = normal * ( -1.0 + 2.0 * float( gl_FrontFacing ) );",

    "#endif",

    "#ifdef USE_NORMALMAP",

      "normal = perturbNormal2Arb( -viewPosition, normal );",

    "#elif defined( USE_BUMPMAP )",

      "normal = perturbNormalArb( -vViewPosition, normal, dHdxy_fwd() );",

    "#endif",

    "#if MAX_POINT_LIGHTS > 0",

      "vec3 pointDiffuse  = vec3( 0.0 );",
      "vec3 pointSpecular = vec3( 0.0 );",

      "for ( int i = 0; i < MAX_POINT_LIGHTS; i ++ ) {",

        "#ifdef PHONG_PER_PIXEL",

          "vec4 lPosition = viewMatrix * vec4( pointLightPosition[ i ], 1.0 );",
          "vec3 lVector = lPosition.xyz + vViewPosition.xyz;",

          "float lDistance = 1.0;",
          "if ( pointLightDistance[ i ] > 0.0 )",
            "lDistance = 1.0 - min( ( length( lVector ) / pointLightDistance[ i ] ), 1.0 );",

          "lVector = normalize( lVector );",

        "#else",

          "vec3 lVector = normalize( vPointLight[ i ].xyz );",
          "float lDistance = vPointLight[ i ].w;",

        "#endif",

        // diffuse

        "float dotProduct = dot( normal, lVector );",

        "#ifdef WRAP_AROUND",

          "float pointDiffuseWeightFull = max( dotProduct, 0.0 );",
          "float pointDiffuseWeightHalf = max( 0.5 * dotProduct + 0.5, 0.0 );",

          "vec3 pointDiffuseWeight = mix( vec3 ( pointDiffuseWeightFull ), vec3( pointDiffuseWeightHalf ), wrapRGB );",

        "#else",

          "float pointDiffuseWeight = max( dotProduct, 0.0 );",

        "#endif",

        "pointDiffuse  += diffuse * pointLightColor[ i ] * pointDiffuseWeight * lDistance;",

        // specular

        "vec3 pointHalfVector = normalize( lVector + viewPosition );",
        "float pointDotNormalHalf = max( dot( normal, pointHalfVector ), 0.0 );",
        "float pointSpecularWeight = specularStrength * max( pow( pointDotNormalHalf, shininess ), 0.0 );",

        "#ifdef PHYSICALLY_BASED_SHADING",

          // 2.0 => 2.0001 is hack to work around ANGLE bug

          "float specularNormalization = ( shininess + 2.0001 ) / 8.0;",

          "vec3 schlick = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( lVector, pointHalfVector ), 5.0 );",
          "pointSpecular += schlick * pointLightColor[ i ] * pointSpecularWeight * pointDiffuseWeight * lDistance * specularNormalization;",

        "#else",

          "pointSpecular += specular * pointLightColor[ i ] * pointSpecularWeight * pointDiffuseWeight * lDistance;",

        "#endif",

      "}",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

      "vec3 spotDiffuse  = vec3( 0.0 );",
      "vec3 spotSpecular = vec3( 0.0 );",

      "for ( int i = 0; i < MAX_SPOT_LIGHTS; i ++ ) {",

        "#ifdef PHONG_PER_PIXEL",

          "vec4 lPosition = viewMatrix * vec4( spotLightPosition[ i ], 1.0 );",
          "vec3 lVector = lPosition.xyz + vViewPosition.xyz;",

          "float lDistance = 1.0;",
          "if ( spotLightDistance[ i ] > 0.0 )",
            "lDistance = 1.0 - min( ( length( lVector ) / spotLightDistance[ i ] ), 1.0 );",

          "lVector = normalize( lVector );",

        "#else",

          "vec3 lVector = normalize( vSpotLight[ i ].xyz );",
          "float lDistance = vSpotLight[ i ].w;",

        "#endif",

        "float spotEffect = dot( spotLightDirection[ i ], normalize( spotLightPosition[ i ] - vWorldPosition ) );",

        "if ( spotEffect > spotLightAngleCos[ i ] ) {",

          "spotEffect = max( pow( spotEffect, spotLightExponent[ i ] ), 0.0 );",

          // diffuse

          "float dotProduct = dot( normal, lVector );",

          "#ifdef WRAP_AROUND",

            "float spotDiffuseWeightFull = max( dotProduct, 0.0 );",
            "float spotDiffuseWeightHalf = max( 0.5 * dotProduct + 0.5, 0.0 );",

            "vec3 spotDiffuseWeight = mix( vec3 ( spotDiffuseWeightFull ), vec3( spotDiffuseWeightHalf ), wrapRGB );",

          "#else",

            "float spotDiffuseWeight = max( dotProduct, 0.0 );",

          "#endif",

          "spotDiffuse += diffuse * spotLightColor[ i ] * spotDiffuseWeight * lDistance * spotEffect;",

          // specular

          "vec3 spotHalfVector = normalize( lVector + viewPosition );",
          "float spotDotNormalHalf = max( dot( normal, spotHalfVector ), 0.0 );",
          "float spotSpecularWeight = specularStrength * max( pow( spotDotNormalHalf, shininess ), 0.0 );",

          "#ifdef PHYSICALLY_BASED_SHADING",

            // 2.0 => 2.0001 is hack to work around ANGLE bug

            "float specularNormalization = ( shininess + 2.0001 ) / 8.0;",

            "vec3 schlick = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( lVector, spotHalfVector ), 5.0 );",
            "spotSpecular += schlick * spotLightColor[ i ] * spotSpecularWeight * spotDiffuseWeight * lDistance * specularNormalization * spotEffect;",

          "#else",

            "spotSpecular += specular * spotLightColor[ i ] * spotSpecularWeight * spotDiffuseWeight * lDistance * spotEffect;",

          "#endif",

        "}",

      "}",

    "#endif",

    "#if MAX_DIR_LIGHTS > 0",

      "vec3 dirDiffuse  = vec3( 0.0 );",
      "vec3 dirSpecular = vec3( 0.0 );" ,

      "for( int i = 0; i < MAX_DIR_LIGHTS; i ++ ) {",

        "vec4 lDirection = viewMatrix * vec4( directionalLightDirection[ i ], 0.0 );",
        "vec3 dirVector = normalize( lDirection.xyz );",

        // diffuse

        "float dotProduct = dot( normal, dirVector );",

        "#ifdef WRAP_AROUND",

          "float dirDiffuseWeightFull = max( dotProduct, 0.0 );",
          "float dirDiffuseWeightHalf = max( 0.5 * dotProduct + 0.5, 0.0 );",

          "vec3 dirDiffuseWeight = mix( vec3( dirDiffuseWeightFull ), vec3( dirDiffuseWeightHalf ), wrapRGB );",

        "#else",

          "float dirDiffuseWeight = max( dotProduct, 0.0 );",

        "#endif",

        "dirDiffuse  += diffuse * directionalLightColor[ i ] * dirDiffuseWeight;",

        // specular

        "vec3 dirHalfVector = normalize( dirVector + viewPosition );",
        "float dirDotNormalHalf = max( dot( normal, dirHalfVector ), 0.0 );",
        "float dirSpecularWeight = specularStrength * max( pow( dirDotNormalHalf, shininess ), 0.0 );",

        "#ifdef PHYSICALLY_BASED_SHADING",

          /*
          // fresnel term from skin shader
          "const float F0 = 0.128;",

          "float base = 1.0 - dot( viewPosition, dirHalfVector );",
          "float exponential = pow( base, 5.0 );",

          "float fresnel = exponential + F0 * ( 1.0 - exponential );",
          */

          /*
          // fresnel term from fresnel shader
          "const float mFresnelBias = 0.08;",
          "const float mFresnelScale = 0.3;",
          "const float mFresnelPower = 5.0;",

          "float fresnel = mFresnelBias + mFresnelScale * pow( 1.0 + dot( normalize( -viewPosition ), normal ), mFresnelPower );",
          */

          // 2.0 => 2.0001 is hack to work around ANGLE bug

          "float specularNormalization = ( shininess + 2.0001 ) / 8.0;",

          //"dirSpecular += specular * directionalLightColor[ i ] * dirSpecularWeight * dirDiffuseWeight * specularNormalization * fresnel;",

          "vec3 schlick = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( dirVector, dirHalfVector ), 5.0 );",
          "dirSpecular += schlick * directionalLightColor[ i ] * dirSpecularWeight * dirDiffuseWeight * specularNormalization;",

        "#else",

          "dirSpecular += specular * directionalLightColor[ i ] * dirSpecularWeight * dirDiffuseWeight;",

        "#endif",

      "}",

    "#endif",

    "#if MAX_HEMI_LIGHTS > 0",

      "vec3 hemiDiffuse  = vec3( 0.0 );",
      "vec3 hemiSpecular = vec3( 0.0 );" ,

      "for( int i = 0; i < MAX_HEMI_LIGHTS; i ++ ) {",

        "vec4 lDirection = viewMatrix * vec4( hemisphereLightDirection[ i ], 0.0 );",
        "vec3 lVector = normalize( lDirection.xyz );",

        // diffuse

        "float dotProduct = dot( normal, lVector );",
        "float hemiDiffuseWeight = 0.5 * dotProduct + 0.5;",

        "vec3 hemiColor = mix( hemisphereLightGroundColor[ i ], hemisphereLightSkyColor[ i ], hemiDiffuseWeight );",

        "hemiDiffuse += diffuse * hemiColor;",

        // specular (sky light)

        "vec3 hemiHalfVectorSky = normalize( lVector + viewPosition );",
        "float hemiDotNormalHalfSky = 0.5 * dot( normal, hemiHalfVectorSky ) + 0.5;",
        "float hemiSpecularWeightSky = specularStrength * max( pow( hemiDotNormalHalfSky, shininess ), 0.0 );",

        // specular (ground light)

        "vec3 lVectorGround = -lVector;",

        "vec3 hemiHalfVectorGround = normalize( lVectorGround + viewPosition );",
        "float hemiDotNormalHalfGround = 0.5 * dot( normal, hemiHalfVectorGround ) + 0.5;",
        "float hemiSpecularWeightGround = specularStrength * max( pow( hemiDotNormalHalfGround, shininess ), 0.0 );",

        "#ifdef PHYSICALLY_BASED_SHADING",

          "float dotProductGround = dot( normal, lVectorGround );",

          // 2.0 => 2.0001 is hack to work around ANGLE bug

          "float specularNormalization = ( shininess + 2.0001 ) / 8.0;",

          "vec3 schlickSky = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( lVector, hemiHalfVectorSky ), 5.0 );",
          "vec3 schlickGround = specular + vec3( 1.0 - specular ) * pow( 1.0 - dot( lVectorGround, hemiHalfVectorGround ), 5.0 );",
          "hemiSpecular += hemiColor * specularNormalization * ( schlickSky * hemiSpecularWeightSky * max( dotProduct, 0.0 ) + schlickGround * hemiSpecularWeightGround * max( dotProductGround, 0.0 ) );",

        "#else",

          "hemiSpecular += specular * hemiColor * ( hemiSpecularWeightSky + hemiSpecularWeightGround ) * hemiDiffuseWeight;",

        "#endif",

      "}",

    "#endif",

    "vec3 totalDiffuse = vec3( 0.0 );",
    "vec3 totalSpecular = vec3( 0.0 );",

    "#if MAX_DIR_LIGHTS > 0",

      "totalDiffuse += dirDiffuse;",
      "totalSpecular += dirSpecular;",

    "#endif",

    "#if MAX_HEMI_LIGHTS > 0",

      "totalDiffuse += hemiDiffuse;",
      "totalSpecular += hemiSpecular;",

    "#endif",

    "#if MAX_POINT_LIGHTS > 0",

      "totalDiffuse += pointDiffuse;",
      "totalSpecular += pointSpecular;",

    "#endif",

    "#if MAX_SPOT_LIGHTS > 0",

      "totalDiffuse += spotDiffuse;",
      "totalSpecular += spotSpecular;",

    "#endif",

    "#ifdef METAL",

      "gl_FragColor.xyz = gl_FragColor.xyz * ( emissive + totalDiffuse + ambientLightColor * ambient + totalSpecular );",

    "#else",

      "gl_FragColor.xyz = gl_FragColor.xyz * ( emissive + totalDiffuse + ambientLightColor * ambient ) + totalSpecular;",

    "#endif"

  ].join("\n"),

  // VERTEX COLORS

  "color_pars_fragment": [

    "#ifdef USE_COLOR",

      "varying vec3 vColor;",

    "#endif"

  ].join("\n"),


  "color_fragment": [

    "#ifdef USE_COLOR",

      "gl_FragColor = gl_FragColor * vec4( vColor, opacity );",

    "#endif"

  ].join("\n"),

  "color_pars_vertex": [

    "#ifdef USE_COLOR",

      "varying vec3 vColor;",

    "#endif"

  ].join("\n"),


  "color_vertex": [

    "#ifdef USE_COLOR",

      "#ifdef GAMMA_INPUT",

        "vColor = color * color;",

      "#else",

        "vColor = color;",

      "#endif",

    "#endif"

  ].join("\n"),

  // SKINNING

  "skinning_pars_vertex": [

    "#ifdef USE_SKINNING",

      "#ifdef BONE_TEXTURE",

        "uniform sampler2D boneTexture;",

        "mat4 getBoneMatrix( const in float i ) {",

          "float j = i * 4.0;",
          "float x = mod( j, N_BONE_PIXEL_X );",
          "float y = floor( j / N_BONE_PIXEL_X );",

          "const float dx = 1.0 / N_BONE_PIXEL_X;",
          "const float dy = 1.0 / N_BONE_PIXEL_Y;",

          "y = dy * ( y + 0.5 );",

          "vec4 v1 = texture2D( boneTexture, vec2( dx * ( x + 0.5 ), y ) );",
          "vec4 v2 = texture2D( boneTexture, vec2( dx * ( x + 1.5 ), y ) );",
          "vec4 v3 = texture2D( boneTexture, vec2( dx * ( x + 2.5 ), y ) );",
          "vec4 v4 = texture2D( boneTexture, vec2( dx * ( x + 3.5 ), y ) );",

          "mat4 bone = mat4( v1, v2, v3, v4 );",

          "return bone;",

        "}",

      "#else",

        "uniform mat4 boneGlobalMatrices[ MAX_BONES ];",

        "mat4 getBoneMatrix( const in float i ) {",

          "mat4 bone = boneGlobalMatrices[ int(i) ];",
          "return bone;",

        "}",

      "#endif",

    "#endif"

  ].join("\n"),

  "skinbase_vertex": [

    "#ifdef USE_SKINNING",

      "mat4 boneMatX = getBoneMatrix( skinIndex.x );",
      "mat4 boneMatY = getBoneMatrix( skinIndex.y );",

    "#endif"

  ].join("\n"),

  "skinning_vertex": [

    "#ifdef USE_SKINNING",

      "#ifdef USE_MORPHTARGETS",

        "vec4 skinVertex = vec4( morphed, 1.0 );",

      "#else",

        "vec4 skinVertex = vec4( position, 1.0 );",

      "#endif",

      "vec4 skinned  = boneMatX * skinVertex * skinWeight.x;",
      "skinned    += boneMatY * skinVertex * skinWeight.y;",

    "#endif"

  ].join("\n"),

  // MORPHING

  "morphtarget_pars_vertex": [

    "#ifdef USE_MORPHTARGETS",

      "#ifndef USE_MORPHNORMALS",

      "uniform float morphTargetInfluences[ 8 ];",

      "#else",

      "uniform float morphTargetInfluences[ 4 ];",

      "#endif",

    "#endif"

  ].join("\n"),

  "morphtarget_vertex": [

    "#ifdef USE_MORPHTARGETS",

      "vec3 morphed = vec3( 0.0 );",
      "morphed += ( morphTarget0 - position ) * morphTargetInfluences[ 0 ];",
      "morphed += ( morphTarget1 - position ) * morphTargetInfluences[ 1 ];",
      "morphed += ( morphTarget2 - position ) * morphTargetInfluences[ 2 ];",
      "morphed += ( morphTarget3 - position ) * morphTargetInfluences[ 3 ];",

      "#ifndef USE_MORPHNORMALS",

      "morphed += ( morphTarget4 - position ) * morphTargetInfluences[ 4 ];",
      "morphed += ( morphTarget5 - position ) * morphTargetInfluences[ 5 ];",
      "morphed += ( morphTarget6 - position ) * morphTargetInfluences[ 6 ];",
      "morphed += ( morphTarget7 - position ) * morphTargetInfluences[ 7 ];",

      "#endif",

      "morphed += position;",

    "#endif"

  ].join("\n"),

  "default_vertex" : [

      "vec4 mvPosition;",

      "#ifdef USE_SKINNING",

        "mvPosition = modelViewMatrix * skinned;",

      "#endif",

      "#if !defined( USE_SKINNING ) && defined( USE_MORPHTARGETS )",

        "mvPosition = modelViewMatrix * vec4( morphed, 1.0 );",

      "#endif",

      "#if !defined( USE_SKINNING ) && ! defined( USE_MORPHTARGETS )",

        "mvPosition = modelViewMatrix * vec4( position, 1.0 );",

      "#endif",

      "gl_Position = projectionMatrix * mvPosition;"

  ].join("\n"),

  "morphnormal_vertex": [

    "#ifdef USE_MORPHNORMALS",

      "vec3 morphedNormal = vec3( 0.0 );",

      "morphedNormal +=  ( morphNormal0 - normal ) * morphTargetInfluences[ 0 ];",
      "morphedNormal +=  ( morphNormal1 - normal ) * morphTargetInfluences[ 1 ];",
      "morphedNormal +=  ( morphNormal2 - normal ) * morphTargetInfluences[ 2 ];",
      "morphedNormal +=  ( morphNormal3 - normal ) * morphTargetInfluences[ 3 ];",

      "morphedNormal += normal;",

    "#endif"

  ].join("\n"),

  "skinnormal_vertex": [

    "#ifdef USE_SKINNING",

      "mat4 skinMatrix = skinWeight.x * boneMatX;",
      "skinMatrix   += skinWeight.y * boneMatY;",

      "#ifdef USE_MORPHNORMALS",

      "vec4 skinnedNormal = skinMatrix * vec4( morphedNormal, 0.0 );",

      "#else",

      "vec4 skinnedNormal = skinMatrix * vec4( normal, 0.0 );",

      "#endif",

    "#endif"

  ].join("\n"),

  "defaultnormal_vertex": [

     "vec3 objectNormal;",

     "#ifdef USE_SKINNING",

        "objectNormal = skinnedNormal.xyz;",

     "#endif",

     "#if !defined( USE_SKINNING ) && defined( USE_MORPHNORMALS )",

        "objectNormal = morphedNormal;",

     "#endif",

     "#if !defined( USE_SKINNING ) && ! defined( USE_MORPHNORMALS )",

        "objectNormal = normal;",

     "#endif",

     "#ifdef FLIP_SIDED",

        "objectNormal = -objectNormal;",

     "#endif",

     "vec3 transformedNormal = normalMatrix * objectNormal;"

  ].join("\n"),

  // SHADOW MAP

  // based on SpiderGL shadow map and Fabien Sanglard's GLSL shadow mapping examples
  //  http://spidergl.org/example.php?id=6
  //  http://fabiensanglard.net/shadowmapping

  "shadowmap_pars_fragment": [

    "#ifdef USE_SHADOWMAP",

      "uniform sampler2D shadowMap[ MAX_SHADOWS ];",
      "uniform vec2 shadowMapSize[ MAX_SHADOWS ];",

      "uniform float shadowDarkness[ MAX_SHADOWS ];",
      "uniform float shadowBias[ MAX_SHADOWS ];",

      "varying vec4 vShadowCoord[ MAX_SHADOWS ];",

      "float unpackDepth( const in vec4 rgba_depth ) {",

        "const vec4 bit_shift = vec4( 1.0 / ( 256.0 * 256.0 * 256.0 ), 1.0 / ( 256.0 * 256.0 ), 1.0 / 256.0, 1.0 );",
        "float depth = dot( rgba_depth, bit_shift );",
        "return depth;",

      "}",

    "#endif"

  ].join("\n"),

  "shadowmap_fragment": [

    "#ifdef USE_SHADOWMAP",

      "#ifdef SHADOWMAP_DEBUG",

        "vec3 frustumColors[3];",
        "frustumColors[0] = vec3( 1.0, 0.5, 0.0 );",
        "frustumColors[1] = vec3( 0.0, 1.0, 0.8 );",
        "frustumColors[2] = vec3( 0.0, 0.5, 1.0 );",

      "#endif",

      "#ifdef SHADOWMAP_CASCADE",

        "int inFrustumCount = 0;",

      "#endif",

      "float fDepth;",
      "vec3 shadowColor = vec3( 1.0 );",

      "for( int i = 0; i < MAX_SHADOWS; i ++ ) {",

        "vec3 shadowCoord = vShadowCoord[ i ].xyz / vShadowCoord[ i ].w;",

        // "if ( something && something )"     breaks ATI OpenGL shader compiler
        // "if ( all( something, something ) )"  using this instead

        "bvec4 inFrustumVec = bvec4 ( shadowCoord.x >= 0.0, shadowCoord.x <= 1.0, shadowCoord.y >= 0.0, shadowCoord.y <= 1.0 );",
        "bool inFrustum = all( inFrustumVec );",

        // don't shadow pixels outside of light frustum
        // use just first frustum (for cascades)
        // don't shadow pixels behind far plane of light frustum

        "#ifdef SHADOWMAP_CASCADE",

          "inFrustumCount += int( inFrustum );",
          "bvec3 frustumTestVec = bvec3( inFrustum, inFrustumCount == 1, shadowCoord.z <= 1.0 );",

        "#else",

          "bvec2 frustumTestVec = bvec2( inFrustum, shadowCoord.z <= 1.0 );",

        "#endif",

        "bool frustumTest = all( frustumTestVec );",

        "if ( frustumTest ) {",

          "shadowCoord.z += shadowBias[ i ];",

          "#if defined( SHADOWMAP_TYPE_PCF )",

            // Percentage-close filtering
            // (9 pixel kernel)
            // http://fabiensanglard.net/shadowmappingPCF/

            "float shadow = 0.0;",

            /*
            // nested loops breaks shader compiler / validator on some ATI cards when using OpenGL
            // must enroll loop manually

            "for ( float y = -1.25; y <= 1.25; y += 1.25 )",
              "for ( float x = -1.25; x <= 1.25; x += 1.25 ) {",

                "vec4 rgbaDepth = texture2D( shadowMap[ i ], vec2( x * xPixelOffset, y * yPixelOffset ) + shadowCoord.xy );",

                // doesn't seem to produce any noticeable visual difference compared to simple "texture2D" lookup
                //"vec4 rgbaDepth = texture2DProj( shadowMap[ i ], vec4( vShadowCoord[ i ].w * ( vec2( x * xPixelOffset, y * yPixelOffset ) + shadowCoord.xy ), 0.05, vShadowCoord[ i ].w ) );",

                "float fDepth = unpackDepth( rgbaDepth );",

                "if ( fDepth < shadowCoord.z )",
                  "shadow += 1.0;",

            "}",

            "shadow /= 9.0;",

            */

            "const float shadowDelta = 1.0 / 9.0;",

            "float xPixelOffset = 1.0 / shadowMapSize[ i ].x;",
            "float yPixelOffset = 1.0 / shadowMapSize[ i ].y;",

            "float dx0 = -1.25 * xPixelOffset;",
            "float dy0 = -1.25 * yPixelOffset;",
            "float dx1 = 1.25 * xPixelOffset;",
            "float dy1 = 1.25 * yPixelOffset;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, dy0 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( 0.0, dy0 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, dy0 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, 0.0 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, 0.0 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, dy1 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( 0.0, dy1 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "fDepth = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, dy1 ) ) );",
            "if ( fDepth < shadowCoord.z ) shadow += shadowDelta;",

            "shadowColor = shadowColor * vec3( ( 1.0 - shadowDarkness[ i ] * shadow ) );",

          "#elif defined( SHADOWMAP_TYPE_PCF_SOFT )",

            // Percentage-close filtering
            // (9 pixel kernel)
            // http://fabiensanglard.net/shadowmappingPCF/

            "float shadow = 0.0;",

            "float xPixelOffset = 1.0 / shadowMapSize[ i ].x;",
            "float yPixelOffset = 1.0 / shadowMapSize[ i ].y;",

            "float dx0 = -1.0 * xPixelOffset;",
            "float dy0 = -1.0 * yPixelOffset;",
            "float dx1 = 1.0 * xPixelOffset;",
            "float dy1 = 1.0 * yPixelOffset;",

            "mat3 shadowKernel;",
            "mat3 depthKernel;",

            "depthKernel[0][0] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, dy0 ) ) );",
            "if ( depthKernel[0][0] < shadowCoord.z ) shadowKernel[0][0] = 0.25;",
            "else shadowKernel[0][0] = 0.0;",

            "depthKernel[0][1] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx0, 0.0 ) ) );",
            "if ( depthKernel[0][1] < shadowCoord.z ) shadowKernel[0][1] = 0.25;",
            "else shadowKernel[0][1] = 0.0;",

            "depthKernel[0][2] = unpackDepth( texture2D( shadowMap[ i], shadowCoord.xy + vec2( dx0, dy1 ) ) );",
            "if ( depthKernel[0][2] < shadowCoord.z ) shadowKernel[0][2] = 0.25;",
            "else shadowKernel[0][2] = 0.0;",

            "depthKernel[1][0] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( 0.0, dy0 ) ) );",
            "if ( depthKernel[1][0] < shadowCoord.z ) shadowKernel[1][0] = 0.25;",
            "else shadowKernel[1][0] = 0.0;",

            "depthKernel[1][1] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy ) );",
            "if ( depthKernel[1][1] < shadowCoord.z ) shadowKernel[1][1] = 0.25;",
            "else shadowKernel[1][1] = 0.0;",

            "depthKernel[1][2] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( 0.0, dy1 ) ) );",
            "if ( depthKernel[1][2] < shadowCoord.z ) shadowKernel[1][2] = 0.25;",
            "else shadowKernel[1][2] = 0.0;",

            "depthKernel[2][0] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, dy0 ) ) );",
            "if ( depthKernel[2][0] < shadowCoord.z ) shadowKernel[2][0] = 0.25;",
            "else shadowKernel[2][0] = 0.0;",

            "depthKernel[2][1] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, 0.0 ) ) );",
            "if ( depthKernel[2][1] < shadowCoord.z ) shadowKernel[2][1] = 0.25;",
            "else shadowKernel[2][1] = 0.0;",

            "depthKernel[2][2] = unpackDepth( texture2D( shadowMap[ i ], shadowCoord.xy + vec2( dx1, dy1 ) ) );",
            "if ( depthKernel[2][2] < shadowCoord.z ) shadowKernel[2][2] = 0.25;",
            "else shadowKernel[2][2] = 0.0;",

            "vec2 fractionalCoord = 1.0 - fract( shadowCoord.xy * shadowMapSize[i].xy );",

            "shadowKernel[0] = mix( shadowKernel[1], shadowKernel[0], fractionalCoord.x );",
            "shadowKernel[1] = mix( shadowKernel[2], shadowKernel[1], fractionalCoord.x );",

            "vec4 shadowValues;",
            "shadowValues.x = mix( shadowKernel[0][1], shadowKernel[0][0], fractionalCoord.y );",
            "shadowValues.y = mix( shadowKernel[0][2], shadowKernel[0][1], fractionalCoord.y );",
            "shadowValues.z = mix( shadowKernel[1][1], shadowKernel[1][0], fractionalCoord.y );",
            "shadowValues.w = mix( shadowKernel[1][2], shadowKernel[1][1], fractionalCoord.y );",

            "shadow = dot( shadowValues, vec4( 1.0 ) );",

            "shadowColor = shadowColor * vec3( ( 1.0 - shadowDarkness[ i ] * shadow ) );",

          "#else",

            "vec4 rgbaDepth = texture2D( shadowMap[ i ], shadowCoord.xy );",
            "float fDepth = unpackDepth( rgbaDepth );",

            "if ( fDepth < shadowCoord.z )",

              // spot with multiple shadows is darker

              "shadowColor = shadowColor * vec3( 1.0 - shadowDarkness[ i ] );",

              // spot with multiple shadows has the same color as single shadow spot

              //"shadowColor = min( shadowColor, vec3( shadowDarkness[ i ] ) );",

          "#endif",

        "}",


        "#ifdef SHADOWMAP_DEBUG",

          "#ifdef SHADOWMAP_CASCADE",

            "if ( inFrustum && inFrustumCount == 1 ) gl_FragColor.xyz *= frustumColors[ i ];",

          "#else",

            "if ( inFrustum ) gl_FragColor.xyz *= frustumColors[ i ];",

          "#endif",

        "#endif",

      "}",

      "#ifdef GAMMA_OUTPUT",

        "shadowColor *= shadowColor;",

      "#endif",

      "gl_FragColor.xyz = gl_FragColor.xyz * shadowColor;",

    "#endif"

  ].join("\n"),

  "shadowmap_pars_vertex": [

    "#ifdef USE_SHADOWMAP",

      "varying vec4 vShadowCoord[ MAX_SHADOWS ];",
      "uniform mat4 shadowMatrix[ MAX_SHADOWS ];",

    "#endif"

  ].join("\n"),

  "shadowmap_vertex": [

    "#ifdef USE_SHADOWMAP",

      "for( int i = 0; i < MAX_SHADOWS; i ++ ) {",

        "vShadowCoord[ i ] = shadowMatrix[ i ] * worldPosition;",

      "}",

    "#endif"

  ].join("\n"),

  // ALPHATEST

  "alphatest_fragment": [

    "#ifdef ALPHATEST",

      "if ( gl_FragColor.a < ALPHATEST ) discard;",

    "#endif"

  ].join("\n"),

  // LINEAR SPACE

  "linear_to_gamma_fragment": [

    "#ifdef GAMMA_OUTPUT",

      "gl_FragColor.xyz = sqrt( gl_FragColor.xyz );",

    "#endif"

  ].join("\n")
};
  }
  return __ShaderChunk;
}

class UniformsUtils {

  static Map<String, Uniform> merge( List<Map<String, Uniform>> uniformsLst) {

    var merged = {};

    uniformsLst.forEach((Map<String, Uniform> uniforms) {
      uniforms.forEach((k, uniform) {
        merged[k] = uniform.clone();
      });
    });

    return merged;

  }

  static clone( Map<String, Uniform> uniforms ) {
    var result = {};
    uniforms.forEach((k, uniform) {
      result[k] = uniform.clone();
    });
    return result;
  }

}

class Attribute<T> {
  String type;
  List<T> value;

  Float32List array;
  Buffer buffer;
  int size;

  String boundTo = null;
  bool needsUpdate = false;
  bool __webglInitialized = false;
  bool createUniqueBuffers = false;

  Attribute<T> __original;

  Attribute(this.type, this.value) {
    size = 1;
    if( type == "v2" ) { size = 2; }
    else if( type == "v3" ) { size = 3; }
    else if( type == "v4" ) { size = 4; }
    else if( type == "c"  ) { size = 3; }

    if (value == null) {
      value = [];
    }
  }

  Attribute clone() {
    var a = new Attribute(type, value);
    return a;
  }

  factory Attribute.color([List<num> hex]) => new Attribute<Color>("c", (hex != null) ? hex.map((h) => new Color(h)) : null);

  factory Attribute.float([List<double> v]) => new Attribute<double>("f", v);
  factory Attribute.int([List<int> v]) => new Attribute<int>("i", v);

  factory Attribute.vector2([List<Vector2> v]) => new Attribute<Vector2>("v2", v);
  factory Attribute.vector3([List<Vector3> v]) => new Attribute<Vector3>("v3", v);
  factory Attribute.vector4([List<Vector4> v]) => new Attribute<Vector4>("v4", v);
}

class Uniform<T> {
  String type;
  T _value;

  // cache the typed value
  bool _dirty = true;
  var _array;

  Uniform(this.type, value) {
    this.value = value;
  }

  T get value => _value;
  set value(v) {
     if (type == "f") {
       v = v.toDouble();
     }
    _dirty = true;
    _value = v;
  }

  get typedValue {
    if (!_dirty && (_array != null)) {
      return _array;
    }

    if ((type == "fv" || type == "fv1") && !(_value is Float32List)) {
      _array = new Float32List.fromList((_value as List).map((_) => _.toDouble()).toList());

    } else if ((type == "iv" || type == "iv1") && !(_value is Int32List)) {
      _array = new Int32List.fromList((_value as List).map((_) => _.toInt()).toList());

    } else if ( type == "v2v" ) { // array of THREE.Vector2

      var values = _value as List<Vector2>;

        if ( _array == null ) {
          _array = new Float32List( 2 * values.length );
        }

        var typedValues = _array as Float32List;
        var offset;

        for ( int i = 0; i < values.length; i ++ ) {

          offset = i * 2;

          typedValues[ offset ]   = values[ i ].x;
          typedValues[ offset + 1 ] = values[ i ].y;

        }

    } else if ( type == "v3v" ) { // array of THREE.Vector3

      var values = _value as List<Vector3>;

      if ( _array == null ) {
        _array = new Float32List( 3 * values.length );
      }

      var typedValues = _array as Float32List;
      var offset;

      for ( int i = 0; i < values.length; i ++ ) {

        offset = i * 3;

        typedValues[ offset ]   = values[ i ].x;
        typedValues[ offset + 1 ] = values[ i ].y;
        typedValues[ offset + 2 ] = values[ i ].z;

      }

    } else if ( type == "v4v" ) { // array of THREE.Vector4

      var values = _value as List<Vector4>;

      if ( _array == null ) {
        _array = new Float32List( 4 * values.length );
      }

      var typedValues = _array as Float32List;
      var offset;

      for ( int i = 0; i < values.length; i ++ ) {

        offset = i * 4;

        typedValues[ offset ]   = values[ i ].x;
        typedValues[ offset + 1 ] = values[ i ].y;
        typedValues[ offset + 2 ] = values[ i ].z;
        typedValues[ offset + 3 ] = values[ i ].w;

      }

    } else if ( type == "m2") { // single THREE.Matrix2

      _array = (_value as Matrix2).storage;

    } else if ( type == "m3") { // single THREE.Matrix3

      _array = (_value as Matrix3).storage;

    } else if ( type == "m4") { // single THREE.Matrix4

      _array = (_value as Matrix4).storage;

    } else if ( type == "m4v" ) { // array of THREE.Matrix4

      var lst = [];

      (_value as List<Matrix4>).forEach((m) { lst.addAll(m.storage); });
      _array = new Float32List.fromList(lst);

    } else {
      return _value;
    }

    return _array;
  }

  Uniform<T> clone() {
    var dst;

    if ( value is Color ||
        value is Vector2 ||
        value is Vector3 ||
        value is Vector4 ||
        value is Matrix4 ||
        value is Texture ) {

      dst = (value as dynamic).clone();

    } else if ( value is List ) {

      dst = new List.from(value as List);

    } else {

      dst = value;

    }

    return new Uniform( type, dst);
  }

  factory Uniform.color(num hex) => new Uniform<Color>("c", new Color(hex));

  factory Uniform.float([double v]) => new Uniform<double>("f", v);
  factory Uniform.floatv(List<double> v) => new Uniform<List<double>>("fv", v);
  factory Uniform.floatv1(List<double> v) => new Uniform<List<double>>("fv1", v);

  factory Uniform.int([int v]) => new Uniform<int>("i", v);
  factory Uniform.intv(List<int> v) => new Uniform<List<int>>("iv", v);
  factory Uniform.intv1(List<int> v) => new Uniform<List<int>>("iv1", v);

  factory Uniform.texture([Texture texture]) => new Uniform<Texture>("t", texture);
  factory Uniform.texturev([List<Texture> textures]) => new Uniform<List<Texture>>("tv", textures);

  factory Uniform.vector2v(List<Vector2> vectors) => new Uniform<List<Vector2>>("v2v", vectors);

  factory Uniform.vector2(double x, double y) => new Uniform<Vector2>("v2", new Vector2(x, y));
  factory Uniform.vector3(double x, double y, double z) => new Uniform<Vector3>("v3", new Vector3(x, y, z));
  factory Uniform.vector4(double x, double y, num z, double w) => new Uniform<Vector4>("v4", new Vector4(x, y, z, w));

  factory Uniform.matrix2(Matrix2 m) => new Uniform<Matrix2>("m2", m);
  factory Uniform.matrix3(Matrix3 m) => new Uniform<Matrix3>("m3", m);
  factory Uniform.matrix4(Matrix4 m) => new Uniform<Matrix4>("m4", m);

  factory Uniform.matrix4v(List<Matrix4> m) => new Uniform<List<Matrix4>>("m4v", m);
}

var __UniformsLib;

get UniformsLib {
  if (__UniformsLib == null) {
    __UniformsLib = {
  "common": {

    "diffuse" : new Uniform.color(0xeeeeee),
    "opacity" : new Uniform.float(1.0),

    "map" : new Uniform.texture(),
    "offsetRepeat" : new Uniform.vector4(0.0, 0.0, 1.0, 1.0),

    "lightMap" : new Uniform.texture(),
    "specularMap" : new Uniform.texture(),

    "envMap" : new Uniform.texture(),
    "flipEnvMap" : new Uniform.float(-1.0),
    "useRefract" : new Uniform.int(0),
    "reflectivity" : new Uniform.float(1.0),
    "refractionRatio" : new Uniform.float(0.98),
    "combine" : new Uniform.int(0),

    "morphTargetInfluences" : new Uniform.float(0.0)

  },

  "bump": {

    "bumpMap" : new Uniform.texture(),
    "bumpScale" : new Uniform.float(1.0)

  },

  "normalmap": {

    "normalMap" : new Uniform.texture(),
    "normalScale" : new Uniform.vector2(1.0, 1.0)

  },

  "fog" : {

    "fogDensity" : new Uniform.float(0.00025),
    "fogNear" : new Uniform.float(1.0),
    "fogFar" : new Uniform.float(2000.0),
    "fogColor" : new Uniform.color(0xffffff)

  },

  "lights": {

    "ambientLightColor" : new Uniform.floatv([]),

    "directionalLightDirection" : new Uniform.floatv([]),
    "directionalLightColor" : new Uniform.floatv([]),

    "hemisphereLightDirection" : new Uniform.floatv([]),
    "hemisphereLightSkyColor" : new Uniform.floatv([]),
    "hemisphereLightGroundColor" : new Uniform.floatv([]),

    "pointLightColor" : new Uniform.floatv([]),
    "pointLightPosition" : new Uniform.floatv([]),
    "pointLightDistance" : new Uniform.floatv1([]),

    "spotLightColor" : new Uniform.floatv([]),
    "spotLightPosition" : new Uniform.floatv([]),
    "spotLightDirection" : new Uniform.floatv([]),
    "spotLightDistance" : new Uniform.floatv1([]),
    "spotLightAngleCos" : new Uniform.floatv1([]),
    "spotLightExponent" : new Uniform.floatv1([])

  },

  "particle": {

    "psColor" : new Uniform.color(0xeeeeee),
    "opacity" : new Uniform.float(1.0),
    "size" : new Uniform.float(1.0),
    "scale" : new Uniform.float(1.0),
    "map" : new Uniform.texture(),

    "fogDensity" : new Uniform.float(0.00025),
    "fogNear" : new Uniform.float(1.0),
    "fogFar" : new Uniform.float(2000.0),
    "fogColor" : new Uniform.color(0xffffff)

  },

  "shadowmap": {

    "shadowMap": new Uniform.texturev([]),
    "shadowMapSize": new Uniform.vector2v([]),

    "shadowBias" : new Uniform.floatv1([]),
    "shadowDarkness": new Uniform.floatv1([]),

    "shadowMatrix" : new Uniform.matrix4v([]),

  }
};
}
return __UniformsLib;
}


var __ShaderLib;

get ShaderLib  {
  if (__ShaderLib == null) {
    __ShaderLib = {

'depth': {

    'uniforms': {

      "mNear": new Uniform.float(1.0),
      "mFar" :  new Uniform.float(2000.0),
      "opacity" :  new Uniform.float(1.0)

    },

    'vertexShader': [

      "void main() {",

        "gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );",

      "}"

    ].join("\n"),

    'fragmentShader': [

      "uniform float mNear;",
      "uniform float mFar;",
      "uniform float opacity;",

      "void main() {",

        "float depth = gl_FragCoord.z / gl_FragCoord.w;",
        "float color = 1.0 - smoothstep( mNear, mFar, depth );",
        "gl_FragColor = vec4( vec3( color ), opacity );",

      "}"

    ].join("\n")

  },

'normal': {

    'uniforms': {

      "opacity" : new Uniform.float(1.0)

    },

    'vertexShader': [

      "varying vec3 vNormal;",

      "void main() {",

        "vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",
        "vNormal = normalize( normalMatrix * normal );",

        "gl_Position = projectionMatrix * mvPosition;",

      "}"

    ].join("\n"),

    'fragmentShader': [

      "uniform float opacity;",
      "varying vec3 vNormal;",

      "void main() {",

        "gl_FragColor = vec4( 0.5 * normalize( vNormal ) + 0.5, opacity );",

      "}"

    ].join("\n")

  },

'basic': {
  'uniforms': UniformsUtils.merge( [UniformsLib[ "common" ],
                                    UniformsLib[ "fog" ],
                                    UniformsLib[ "shadowmap" ]] ),

  'vertexShader': [

                 ShaderChunk[ "map_pars_vertex" ],
                 ShaderChunk[ "lightmap_pars_vertex" ],
                 ShaderChunk[ "envmap_pars_vertex" ],
                 ShaderChunk[ "color_pars_vertex" ],
                 ShaderChunk[ "morphtarget_pars_vertex" ],
                 ShaderChunk[ "skinning_pars_vertex" ],
                 ShaderChunk[ "shadowmap_pars_vertex" ],

                 "void main() {",

                   ShaderChunk[ "map_vertex" ],
                   ShaderChunk[ "lightmap_vertex" ],
                   ShaderChunk[ "color_vertex" ],
                   ShaderChunk[ "skinbase_vertex" ],

                   "#ifdef USE_ENVMAP",

                    ShaderChunk[ "morphnormal_vertex" ],
                    ShaderChunk[ "skinnormal_vertex" ],
                    ShaderChunk[ "defaultnormal_vertex" ],

                   "#endif",

                   ShaderChunk[ "morphtarget_vertex" ],
                   ShaderChunk[ "skinning_vertex" ],
                   ShaderChunk[ "default_vertex" ],

                   ShaderChunk[ "worldpos_vertex" ],
                   ShaderChunk[ "envmap_vertex" ],
                   ShaderChunk[ "shadowmap_vertex" ],

                 "}"

                 ].join("\n"),

   'fragmentShader': [

                    "uniform vec3 diffuse;",
                    "uniform float opacity;",

                    ShaderChunk[ "color_pars_fragment" ],
                    ShaderChunk[ "map_pars_fragment" ],
                    ShaderChunk[ "lightmap_pars_fragment" ],
                    ShaderChunk[ "envmap_pars_fragment" ],
                    ShaderChunk[ "fog_pars_fragment" ],
                    ShaderChunk[ "shadowmap_pars_fragment" ],
                    ShaderChunk[ "specularmap_pars_fragment" ],

                    "void main() {",

                    "gl_FragColor = vec4( diffuse, opacity );",

                    ShaderChunk[ "map_fragment" ],
                    ShaderChunk[ "alphatest_fragment" ],
                    ShaderChunk[ "specularmap_fragment" ],
                    ShaderChunk[ "lightmap_fragment" ],
                    ShaderChunk[ "color_fragment" ],
                    ShaderChunk[ "envmap_fragment" ],
                    ShaderChunk[ "shadowmap_fragment" ],

                    ShaderChunk[ "linear_to_gamma_fragment" ],

                    ShaderChunk[ "fog_fragment" ],

                    "}"

                    ].join("\n")

  },

  'lambert': {

    'uniforms': UniformsUtils.merge( [

      UniformsLib[ "common" ],
      UniformsLib[ "fog" ],
      UniformsLib[ "lights" ],
      UniformsLib[ "shadowmap" ],

      {
        "ambient"  : new Uniform.color(0xffffff),
        "emissive" : new Uniform.color(0x000000),
        "wrapRGB"  : new Uniform.vector3(1.0, 1.0, 1.0)
      }

    ] ),

    'vertexShader': [

      "#define LAMBERT",

      "varying vec3 vLightFront;",

      "#ifdef DOUBLE_SIDED",

        "varying vec3 vLightBack;",

      "#endif",

      ShaderChunk[ "map_pars_vertex" ],
      ShaderChunk[ "lightmap_pars_vertex" ],
      ShaderChunk[ "envmap_pars_vertex" ],
      ShaderChunk[ "lights_lambert_pars_vertex" ],
      ShaderChunk[ "color_pars_vertex" ],
      ShaderChunk[ "morphtarget_pars_vertex" ],
      ShaderChunk[ "skinning_pars_vertex" ],
      ShaderChunk[ "shadowmap_pars_vertex" ],

      "void main() {",

        ShaderChunk[ "map_vertex" ],
        ShaderChunk[ "lightmap_vertex" ],
        ShaderChunk[ "color_vertex" ],

        ShaderChunk[ "morphnormal_vertex" ],
        ShaderChunk[ "skinbase_vertex" ],
        ShaderChunk[ "skinnormal_vertex" ],
        ShaderChunk[ "defaultnormal_vertex" ],

        ShaderChunk[ "morphtarget_vertex" ],
        ShaderChunk[ "skinning_vertex" ],
        ShaderChunk[ "default_vertex" ],

        ShaderChunk[ "worldpos_vertex" ],
        ShaderChunk[ "envmap_vertex" ],
        ShaderChunk[ "lights_lambert_vertex" ],
        ShaderChunk[ "shadowmap_vertex" ],

      "}"

    ].join("\n"),

    'fragmentShader': [

      "uniform float opacity;",

      "varying vec3 vLightFront;",

      "#ifdef DOUBLE_SIDED",

        "varying vec3 vLightBack;",

      "#endif",

      ShaderChunk[ "color_pars_fragment" ],
      ShaderChunk[ "map_pars_fragment" ],
      ShaderChunk[ "lightmap_pars_fragment" ],
      ShaderChunk[ "envmap_pars_fragment" ],
      ShaderChunk[ "fog_pars_fragment" ],
      ShaderChunk[ "shadowmap_pars_fragment" ],
      ShaderChunk[ "specularmap_pars_fragment" ],

      "void main() {",

        "gl_FragColor = vec4( vec3 ( 1.0 ), opacity );",

        ShaderChunk[ "map_fragment" ],
        ShaderChunk[ "alphatest_fragment" ],
        ShaderChunk[ "specularmap_fragment" ],

        "#ifdef DOUBLE_SIDED",

          //"float isFront = float( gl_FrontFacing );",
          //"gl_FragColor.xyz *= isFront * vLightFront + ( 1.0 - isFront ) * vLightBack;",

          "if ( gl_FrontFacing )",
            "gl_FragColor.xyz *= vLightFront;",
          "else",
            "gl_FragColor.xyz *= vLightBack;",

        "#else",

          "gl_FragColor.xyz *= vLightFront;",

        "#endif",

        ShaderChunk[ "lightmap_fragment" ],
        ShaderChunk[ "color_fragment" ],
        ShaderChunk[ "envmap_fragment" ],
        ShaderChunk[ "shadowmap_fragment" ],

        ShaderChunk[ "linear_to_gamma_fragment" ],

        ShaderChunk[ "fog_fragment" ],

      "}"

    ].join("\n")

  },

  'phong': {

    'uniforms': UniformsUtils.merge( [

      UniformsLib[ "common" ],
      UniformsLib[ "bump" ],
      UniformsLib[ "normalmap" ],
      UniformsLib[ "fog" ],
      UniformsLib[ "lights" ],
      UniformsLib[ "shadowmap" ],

      {
        "ambient"  : new Uniform.color(0xffffff),
        "emissive" : new Uniform.color(0x000000),
        "specular" : new Uniform.color(0x111111),
        "shininess": new Uniform.float(30.0),
        "wrapRGB"  : new Uniform.vector3(1.0, 1.0, 1.0)
      }

    ] ),

    'vertexShader': [

      "#define PHONG",

      "varying vec3 vViewPosition;",
      "varying vec3 vNormal;",

      ShaderChunk[ "map_pars_vertex" ],
      ShaderChunk[ "lightmap_pars_vertex" ],
      ShaderChunk[ "envmap_pars_vertex" ],
      ShaderChunk[ "lights_phong_pars_vertex" ],
      ShaderChunk[ "color_pars_vertex" ],
      ShaderChunk[ "morphtarget_pars_vertex" ],
      ShaderChunk[ "skinning_pars_vertex" ],
      ShaderChunk[ "shadowmap_pars_vertex" ],

      "void main() {",

        ShaderChunk[ "map_vertex" ],
        ShaderChunk[ "lightmap_vertex" ],
        ShaderChunk[ "color_vertex" ],

        ShaderChunk[ "morphnormal_vertex" ],
        ShaderChunk[ "skinbase_vertex" ],
        ShaderChunk[ "skinnormal_vertex" ],
        ShaderChunk[ "defaultnormal_vertex" ],

        "vNormal = normalize( transformedNormal );",

        ShaderChunk[ "morphtarget_vertex" ],
        ShaderChunk[ "skinning_vertex" ],
        ShaderChunk[ "default_vertex" ],

        "vViewPosition = -mvPosition.xyz;",

        ShaderChunk[ "worldpos_vertex" ],
        ShaderChunk[ "envmap_vertex" ],
        ShaderChunk[ "lights_phong_vertex" ],
        ShaderChunk[ "shadowmap_vertex" ],

      "}"

    ].join("\n"),

    'fragmentShader': [

      "uniform vec3 diffuse;",
      "uniform float opacity;",

      "uniform vec3 ambient;",
      "uniform vec3 emissive;",
      "uniform vec3 specular;",
      "uniform float shininess;",

      ShaderChunk[ "color_pars_fragment" ],
      ShaderChunk[ "map_pars_fragment" ],
      ShaderChunk[ "lightmap_pars_fragment" ],
      ShaderChunk[ "envmap_pars_fragment" ],
      ShaderChunk[ "fog_pars_fragment" ],
      ShaderChunk[ "lights_phong_pars_fragment" ],
      ShaderChunk[ "shadowmap_pars_fragment" ],
      ShaderChunk[ "bumpmap_pars_fragment" ],
      ShaderChunk[ "normalmap_pars_fragment" ],
      ShaderChunk[ "specularmap_pars_fragment" ],

      "void main() {",

        "gl_FragColor = vec4( vec3 ( 1.0 ), opacity );",

        ShaderChunk[ "map_fragment" ],
        ShaderChunk[ "alphatest_fragment" ],
        ShaderChunk[ "specularmap_fragment" ],

        ShaderChunk[ "lights_phong_fragment" ],

        ShaderChunk[ "lightmap_fragment" ],
        ShaderChunk[ "color_fragment" ],
        ShaderChunk[ "envmap_fragment" ],
        ShaderChunk[ "shadowmap_fragment" ],

        ShaderChunk[ "linear_to_gamma_fragment" ],

        ShaderChunk[ "fog_fragment" ],

      "}"

    ].join("\n")

  },

  'particle_basic': {

    'uniforms':  UniformsUtils.merge( [

      UniformsLib[ "particle" ],
      UniformsLib[ "shadowmap" ]

    ] ),

    'vertexShader': [

      "uniform float size;",
      "uniform float scale;",

      ShaderChunk[ "color_pars_vertex" ],
      ShaderChunk[ "shadowmap_pars_vertex" ],

      "void main() {",

        ShaderChunk[ "color_vertex" ],

        "vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",

        "#ifdef USE_SIZEATTENUATION",
          "gl_PointSize = size * ( scale / length( mvPosition.xyz ) );",
        "#else",
          "gl_PointSize = size;",
        "#endif",

        "gl_Position = projectionMatrix * mvPosition;",

        ShaderChunk[ "worldpos_vertex" ],
        ShaderChunk[ "shadowmap_vertex" ],

      "}"

    ].join("\n"),

    'fragmentShader': [

      "uniform vec3 psColor;",
      "uniform float opacity;",

      ShaderChunk[ "color_pars_fragment" ],
      ShaderChunk[ "map_particle_pars_fragment" ],
      ShaderChunk[ "fog_pars_fragment" ],
      ShaderChunk[ "shadowmap_pars_fragment" ],

      "void main() {",

        "gl_FragColor = vec4( psColor, opacity );",

        ShaderChunk[ "map_particle_fragment" ],
        ShaderChunk[ "alphatest_fragment" ],
        ShaderChunk[ "color_fragment" ],
        ShaderChunk[ "shadowmap_fragment" ],
        ShaderChunk[ "fog_fragment" ],

      "}"

    ].join("\n")

  },
  'dashed': {

    "uniforms": UniformsUtils.merge( [

      UniformsLib[ "common" ],
      UniformsLib[ "fog" ],

      {
        "scale": new Uniform.float(1.0),
        "dashSize": new Uniform.float(1.0),
        "totalSize": new Uniform.float(2.0)
      }

    ] ),

    "vertexShader": [

      "uniform float scale;",
      "attribute float lineDistance;",

      "varying float vLineDistance;",

      ShaderChunk[ "color_pars_vertex" ],

      "void main() {",

        ShaderChunk[ "color_vertex" ],

        "vLineDistance = scale * lineDistance;",

        "vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );",
        "gl_Position = projectionMatrix * mvPosition;",

      "}"

    ].join("\n"),

    "fragmentShader": [

      "uniform vec3 diffuse;",
      "uniform float opacity;",

      "uniform float dashSize;",
      "uniform float totalSize;",

      "varying float vLineDistance;",

      ShaderChunk[ "color_pars_fragment" ],
      ShaderChunk[ "fog_pars_fragment" ],

      "void main() {",

        "if ( mod( vLineDistance, totalSize ) > dashSize ) {",

          "discard;",

        "}",

        "gl_FragColor = vec4( diffuse, opacity );",

        ShaderChunk[ "color_fragment" ],
        ShaderChunk[ "fog_fragment" ],

      "}"

    ].join("\n")

  },
  // Depth encoding into RGBA texture
  //  based on SpiderGL shadow map example
  //    http://spidergl.org/example.php?id=6
  //  originally from
  //    http://www.gamedev.net/topic/442138-packing-a-float-into-a-a8r8g8b8-texture-shader/page__whichpage__1%25EF%25BF%25BD
  //  see also here:
  //    http://aras-p.info/blog/2009/07/30/encoding-floats-to-rgba-the-final/

  'depthRGBA': {

    'uniforms': {},

    'vertexShader': [

      ShaderChunk[ "morphtarget_pars_vertex" ],
      ShaderChunk[ "skinning_pars_vertex" ],

      "void main() {",

        ShaderChunk[ "skinbase_vertex" ],
        ShaderChunk[ "morphtarget_vertex" ],
        ShaderChunk[ "skinning_vertex" ],
        ShaderChunk[ "default_vertex" ],

      "}"

    ].join("\n"),

    'fragmentShader': [

      "vec4 pack_depth( const in float depth ) {",

        "const vec4 bit_shift = vec4( 256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0 );",
        "const vec4 bit_mask  = vec4( 0.0, 1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0 );",
        "vec4 res = fract( depth * bit_shift );",
        "res -= res.xxyz * bit_mask;",
        "return res;",

      "}",

      "void main() {",

        "gl_FragData[ 0 ] = pack_depth( gl_FragCoord.z );",

        //"gl_FragData[ 0 ] = pack_depth( gl_FragCoord.z / gl_FragCoord.w );",
        //"float z = ( ( gl_FragCoord.z / gl_FragCoord.w ) - 3.0 ) / ( 4000.0 - 3.0 );",
        //"gl_FragData[ 0 ] = pack_depth( z );",
        //"gl_FragData[ 0 ] = vec4( z, z, z, 1.0 );",

      "}"

    ].join("\n")

  }

    };
  }
  return __ShaderLib;
}
