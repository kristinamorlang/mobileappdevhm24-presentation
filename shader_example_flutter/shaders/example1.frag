#version 300 es  
precision highp float;

uniform float u_time;       
uniform vec2 u_resolution;  

out vec4 fragColor;         

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution;  
  vec3 color = vec3(st.x, st.y, abs(sin(u_time)));
  fragColor = vec4(color, 1.0);             
}

