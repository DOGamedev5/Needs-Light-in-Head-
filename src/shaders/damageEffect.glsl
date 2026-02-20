uniform vec2 scale;
uniform float bright;

vec4 effect(vec4 Color, Image texture, vec2 text_coords, vec2 screen_coords) {
  vec4 pixelColor = Texel(texture, text_coords) * Color;
  vec4 pixelOver = Texel(texture, text_coords) * Color;

  return pixelColor + pixelOver*bright;  
}