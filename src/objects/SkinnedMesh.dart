class SkinnedMesh extends Mesh {
	bool useVertexTexture;
	num boneTextureWidth, boneTextureHeight;
	List bones;
	
	SkinnedMesh( geometry, material, [this.useVertexTexture = true] ) : super(geometry, material);

	// TODO
}