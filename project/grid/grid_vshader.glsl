#version 330

in vec2 position;

uniform mat4 model;
uniform mat4 view;
uniform mat4 MVP;
uniform sampler2D tex;
uniform float time;
uniform float SPEED; //param.h
uniform vec3 LIGHT_POS; //param.h
uniform bool noise_debug;

out float height;
out vec3 light_dir;
out vec4 vpoint_mv;
out vec2 uv;

void main() {

    uv = (position + vec2(1.0, 1.0)) * 0.5; //now uv goes from 0.0 to 1.0


    height = texture(tex, uv).x;

    uv = uv * 10 - time * SPEED; //this make the texture repeat 3 times per side of the grid
    //then there will be 9 textures quads in the grid
    //this line must be the same on noise_fshader
    vec3 pos_3d;

    if(!noise_debug) {
        pos_3d = vec3(position.x, position.y, height);
    } else {
        pos_3d = vec3(position.x, position.y, 0.0f);
    }

    gl_Position = MVP * vec4(pos_3d, 1.0);

    ///compute the light direction light_dir
    mat4 MV = view * model;
    vpoint_mv = MV * vec4(pos_3d, 1.0);
    vec4 light_mv = MV * vec4(LIGHT_POS, 1.0);

    light_dir = normalize(light_mv.xyz - vpoint_mv.xyz);
}
