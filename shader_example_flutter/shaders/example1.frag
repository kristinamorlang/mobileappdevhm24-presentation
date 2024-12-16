#version 300 es  
precision highp float;

uniform float u_time;       
uniform vec2 u_resolution;  

out vec4 fragColor;         

void main() {
  vec3 color = vec3(gl_FragCoord.x, gl_FragCoord.y, abs(sin(u_time)));
  fragColor = vec4(color, 1.0);             
}

