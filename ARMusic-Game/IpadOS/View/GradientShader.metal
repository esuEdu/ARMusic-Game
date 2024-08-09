//
//  GradientShader.metal
//  ARMusic-Game (IpadOS)
//
//  Created by Victor Soares on 08/08/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

half4 soft_light(half4 base, half4 blend) {
    half4 limit = step(0.5, blend);
    return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

float hue2rgb(float p, float q, float t) {
    if(t < 0.0) t += 1.0;
    if(t > 1.0) t -= 1.0;
    if(t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if(t < 1.0/2.0) return q;
    if(t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

float3 hueToColor(float hue) {
    float saturation = 1.0; // Assuming full saturation
    float lightness = 0.5;  // Assuming mid lightness
    
    float q = lightness < 0.5 ? lightness * (1.0 + saturation) : lightness + saturation - lightness * saturation;
    float p = 2.0 * lightness - q;
    
    float r = hue2rgb(p, q, hue + 1.0/3.0);
    float g = hue2rgb(p, q, hue);
    float b = hue2rgb(p, q, hue - 1.0/3.0);
    
    return float3(r, g, b);
}

[[stitchable]]
half4 boise(float2 position, half4 currentColor, float4 bounds, float time) {
    
    float2 uv = (position.xy / bounds.zw);
    uv.y = 1.0 - uv.y;
    
    float a = abs(sin(time * 0.1));
    
    half3 gradient1 = half3(hueToColor(a));
    half3 gradient2 = half3(hueToColor(a + 0.2));
    half3 gradientColor = mix(gradient1, gradient2, uv.x);
    
    half4 blended = soft_light(half4(gradientColor, 1.0), currentColor);
    
    
    return blended;
    
}





