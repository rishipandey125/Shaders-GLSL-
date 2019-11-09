vec3 background(vec3 cord) {
	vec3 light = vec3(2.1*sin(iTime),0.35,20.6*cos(iTime));
	float sun_radius = 0.1;
	if (length(vec2(cord.x,cord.y)-vec2(light.x,light.y)) <= sun_radius) {
		float sun = max(0.0, dot(cord,light));
		light = vec3(pow(sun,256.0));
	} else {
		light = vec3(0.0);
	}
	float ground = max(0.0,-dot(cord,vec3(0.0,1.0,0.0)));
	float sky = max(0.0,dot(cord,vec3(0.0,1.0,0.0)));
	vec3 sky_col = vec3(0.9)*sky;
	vec3 ground_col = (0.3+sin(2.0*iTime+cord.xyx+vec3(0.0,2.0,4.0)))*pow(ground,0.5);
	return light+ground_col+sky_col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
		vec3 color;
		float aspect_ratio = iResolution.x/iResolution.y;
    vec2 cord = (-1.0 + 2.0*fragCoord.xy / iResolution.xy) *
		vec2(aspect_ratio, 1.0);
    vec3 center = vec3(0.0,0.2,0.0);
    float radius = 0.5;
    center.x *= aspect_ratio;
    if (length(cord-vec2(center.x,center.y)) <= radius) {
      vec3 camera = vec3(0.0,0.0,-2.0);
			vec3 point_light = vec3(0.0,0.0,-10.0);
      float z = center.z - sqrt(pow(radius,2.0)-pow(cord.y-center.y,2.0));
      vec3 curr = vec3(cord,z);
      vec3 light = normalize(point_light-curr);
      vec3 normal = normalize(curr-center);
      vec3 view = normalize(camera-curr);
      vec3 steel = vec3(max(dot(normal,light),0.0))*vec3(1.0);
      vec3 ref = -reflect(view,normal);
      color = background(ref)*steel;
    } else {
      color = background(vec3(cord,center.z+1.0));
    }
    fragColor = vec4(color,1.0);
}
