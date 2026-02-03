uniform sampler2D overText;
uniform sampler2D normalMap;
uniform sampler2D glowMap;
uniform vec4 overColor;
uniform vec2 overSize;
uniform float time;

vec2 normalEffect(vec2 UV) {
    vec3 normal = normalize((Texel(normalMap, (UV + vec2(time*0.1, time*0.05))*0.5).rgb * 2.0) - 1.0);
    vec3 tangentViewDirection = vec3(0.0, 0.0, -1.0);
    vec3 refractedDirection = refract(tangentViewDirection, normal, 0.1);

    return refractedDirection.xy;
}

float waveEffect(vec2 textureCords) {
    return (Texel(glowMap, textureCords*2.0 + vec2(time*0.01, time*0.01)).a*1.75);
}

vec4 shadowEffect(vec2 textureCords, vec4 Color, sampler2D text) {

    return Color - Color * Texel(text, textureCords).a*0.3;
}

vec4 effect(vec4 Color, sampler2D text, vec2 textureCords, vec2 screenCords) {
    //vec2 scale = vec2(love_ScreenSize.x / 128.0, love_ScreenSize.y / 128.0);
    vec2 UV = textureCords * 4;
    UV.y += cos(UV.x + time*0.5)*0.1;
    UV.x += cos(UV.y + time*0.05)*0.05;
    UV.y *= 1.4;
    vec2 NormalizedUV = UV + normalEffect(UV);
    Color = shadowEffect(NormalizedUV, Color, text);
    return mix(Color, overColor, Texel(text, NormalizedUV + vec2(4*1.2, 4)).a * waveEffect(textureCords));
    //return Color + Texel(text, UV).a*overColor* (0.1 + (cos(time*0.2 + textureCords.x)+1)/2*0.2);
}