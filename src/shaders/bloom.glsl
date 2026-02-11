uniform float gamma;
uniform float bloomSize;
uniform float exposition;
uniform float intensity;

float getAverage(vec4 color) {
    float avg = color.r *0.299 + color.g * 0.587 + color.b * 0.114;
    //vec4 result = vec4(avg, avg, avg, color.a);
    return avg;
}

vec4 getBright(sampler2D text, vec2 UV) {
    float avg = getAverage(Texel(text, UV));
    float glowStep = step(0.6, avg);
    return Texel(text, UV)*glowStep;
}

vec4 bloom(sampler2D tex, vec2 texture_coords){

    vec2 blurSize = vec2(1.0/800.0, 1.0/500.0) * bloomSize;

    //this function was adapted from here: https://www.shadertoy.com/view/lsXGWn

    vec4 sum = vec4(0);

    sum += getBright(tex, vec2(texture_coords.x - 4.0*blurSize.x, texture_coords.y)) * 0.05;
    sum += getBright(tex, vec2(texture_coords.x - 3.0*blurSize.x, texture_coords.y)) * 0.09;
    sum += getBright(tex, vec2(texture_coords.x - 2.0*blurSize.x, texture_coords.y)) * 0.12;
    sum += getBright(tex, vec2(texture_coords.x - blurSize.x, texture_coords.y)) * 0.15;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y)) * 0.16;
    sum += getBright(tex, vec2(texture_coords.x + blurSize.x, texture_coords.y)) * 0.15;
    sum += getBright(tex, vec2(texture_coords.x + 2.0*blurSize.x, texture_coords.y)) * 0.12;
    sum += getBright(tex, vec2(texture_coords.x + 3.0*blurSize.x, texture_coords.y)) * 0.09;
    sum += getBright(tex, vec2(texture_coords.x + 4.0*blurSize.x, texture_coords.y)) * 0.05;

    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y - 4.0*blurSize.y)) * 0.05;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y - 3.0*blurSize.y)) * 0.09;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y - 2.0*blurSize.y)) * 0.12;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y - blurSize.y)) * 0.15;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y)) * 0.16;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y + blurSize.y)) * 0.15;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y + 2.0*blurSize.y)) * 0.12;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y + 3.0*blurSize.y)) * 0.09;
    sum += getBright(tex, vec2(texture_coords.x, texture_coords.y + 4.0*blurSize.y)) * 0.05;

    return sum * intensity;

}

vec4 effect(vec4 color, sampler2D text, vec2 UV, vec2 screen_UV) {
    vec4 pixel = Texel(text, UV)*color;
    vec4 glow = bloom(text, UV)*color;
    pixel += glow;

    vec3 result = vec3(1.0) - exp(-pixel.rgb * exposition); 
    //float s = step(1.0 - textureCords.y, complete);
    result = pow(result, vec3(1.0 / gamma));
    return vec4(result, 1.0);
    //return bloom(text, UV) * color;
}