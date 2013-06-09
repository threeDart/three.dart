part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author greggman / http://games.greggman.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class OrthographicCamera extends Camera {

	double left,
		right,
		top,
		bottom;

	OrthographicCamera( this.left, this.right, this.top, this.bottom,
						[near = 0.1, far = 2000.0] ) : super(near, far) {
		updateProjectionMatrix();
	}

	updateProjectionMatrix() {
		setOrthographicMatrix( projectionMatrix, left, right, bottom, top, near, far);
	}
}