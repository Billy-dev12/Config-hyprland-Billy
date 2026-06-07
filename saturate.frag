#version 300 es
precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);
    float saturation = 1.00; // Naikin ini kalo mau lebih tajam
    
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayVec = vec3(gray);
    
    fragColor = vec4(mix(grayVec, color.rgb, saturation), color.a);
}
