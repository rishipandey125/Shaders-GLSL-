vec3 background(vec3 curr) {
	float sky = max(0.0, dot(curr, vec3(0.0, 1.0, 0.0)));//sky gradient
	vec3 sky_color = vec3(0.5,0.8,1.0);//sky color
	return sky*sky_color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 color = vec3(.6);
    vec2 cord = fragCoord/iResolution.xy;
    vec3 center = vec3(0.5,0.5,5.0);
    float radius = 0.3;
    float aspect_ratio = iResolution.x/iResolution.y;
    cord.x *= aspect_ratio;
    center.x *= aspect_ratio;
    if (length(cord-vec2(center.x,center.y)) <= radius) {
      color = vec3(0.8,0.3,1);
      vec3 camera = vec3(0.5,0.5,0);
      vec3 point_light = vec3(10.0*sin(iTime*0.5),5.0,-1);
      float z = center.z - sqrt(pow(radius,2.0)-pow(cord.y-center.y,2.0));
      vec3 curr = vec3(cord,z);
      vec3 normal = normalize(curr-center);
      vec3 light = normalize(point_light-curr);
      vec3 view = normalize(camera-curr);
      vec3 h = normalize(light+view);
      vec3 ambient = .1*color;
      vec3 diffuse = vec3(max(dot(normal,light),0.0));
      vec3 specular = vec3(max(0.2*pow(dot(normal,h),200.0),0.0));
      color *= ambient+diffuse+specular;
    } else {
      color = background(vec3(cord,0));
    }
    fragColor = vec4(color,1.0);
}
