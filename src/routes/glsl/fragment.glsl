
precision highp float;

in vec2 vUv;
out vec4 outColor;

uniform vec2 uResolution;
uniform float uTime;

//lines
uniform float uTotal;
uniform float uThickness;
uniform float uThicknessActive;

//letters
uniform float uWarpHeight;

//colors
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColorActive;

uniform float uScale;
uniform float uSpeed;
uniform float uRotation;
uniform float uTextureIndex;
uniform vec2 uTranslate;

uniform bool uDebug;
uniform bool uSwapTextures;

uniform sampler2D uTextureL;
uniform sampler2D uTextureI;
uniform sampler2D uTextureN;
uniform sampler2D uTextureE;

// Definitions
#define PI 3.1415926538

// Map a vec2 to the screen aspect ratio
vec2 uvAspectRatio(vec2 uv, vec2 st) {
  float center = .5;
  float aspect = st.x / st.y;

  uv.x -= center;
  uv.x *= aspect;
  uv.x += center;

  return uv;
}

// 2D Rotation
mat2 rotate2d(in float angle){
  return mat2( cos(angle), sin(angle), -sin(angle), cos(angle));
}

// Degree to Radians
float degToRad(in float angle) {
  return angle * (PI / 180.);
}


void main() {
  vec3 final = vec3(0.);

  vec2 uv = uvAspectRatio(vUv, uResolution);
  vec2 texUV = uv;

  //-----------------------
  texUV -= vec2(.5);
  
  // rotation around the center
  texUV *= rotate2d(degToRad(sin(uTime) * uRotation));
  
  // scale
  texUV /= uScale;
  
  texUV += vec2(.5);
  
  // move
  vec2 translate = vec2(cos(uTime * uSpeed) * uTranslate.x, sin(uTime * uSpeed) * uTranslate.y);
  texUV += (translate * 0.5);
 
  //-----------------------
  //-- get texture
  vec4 tex = vec4(0.);
  
  if(uSwapTextures == true) {
    float texIndex = mod(floor(uTime * 0.5), 4.);
    if(texIndex == 0.) tex = texture(uTextureL, texUV);
    if(texIndex == 1.) tex = texture(uTextureI, texUV);
    if(texIndex == 2.) tex = texture(uTextureN, texUV);
    if(texIndex == 3.) tex = texture(uTextureE, texUV);
  }
  else{
    tex = texture(uTextureL, texUV);
  }
  
  float c = tex.r;

  float heights = sin(uv.y * uWarpHeight) * c + uThickness;
  uv.y -= heights;

  //-- scale uv
  uv = fract(uv * uTotal);
  
  //-- line and thickness
  vec2 line = floor(uv + uThickness + (c * uThicknessActive));
  
  //-- direction
  float pos = line.y;

  // colorize the lines
  final = mix(uColor1, mix(uColor2, uColorActive, c), pos);
  if(uDebug == true) final = vec3(c);
  outColor = vec4(final, 1.);
}
