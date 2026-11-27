attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform vec4 angleVec4;

// 绕X轴旋转矩阵
mat4 rotateX(float angle) {
	float c = cos(radians(angle));
	float s = sin(radians(angle));
	return mat4(
		1.0, 0.0, 0.0, 0.0,
		0.0,   c,   s, 0.0,
		0.0,  -s,   c, 0.0,
		0.0, 0.0, 0.0, 1.0
	);
}

// 绕Y轴旋转矩阵
mat4 rotateY(float angle) {
	float c = cos(radians(angle));
	float s = sin(radians(angle));
	return mat4(
		c, 0.0,  -s, 0.0,
		0.0, 1.0, 0.0, 0.0,
		s, 0.0,   c, 0.0,
		0.0, 0.0, 0.0, 1.0
	);
}

// 绕Z轴旋转矩阵
mat4 rotateZ(float angle) {
	float c = cos(radians(angle));
	float s = sin(radians(angle));
	return mat4(
		c,   s, 0.0, 0.0,
		-s,   c, 0.0, 0.0,
		0.0, 0.0, 1.0, 0.0,
		0.0, 0.0, 0.0, 1.0
	);
}


void main()
{

	vec3 u_rotationAngles = vec3(angleVec4.x, angleVec4.y, angleVec4.z);
	vec4 centeredPos = a_position - vec4(0.5, 0.5, 0.0, 0.0);

	// 创建组合旋转矩阵
	mat4 rotationMatrix = rotateX(u_rotationAngles.x) * rotateY(u_rotationAngles.y) * rotateZ(u_rotationAngles.z);

	vec4 rotatedPos = rotationMatrix * centeredPos;
	vec4 finalPos = rotatedPos + vec4(0.5, 0.5, 0.0, 0.0);

	gl_Position = CC_MVPMatrix * finalPos;
	v_texCoord = a_texCoord;
	v_fragmentColor = a_color;
	
}