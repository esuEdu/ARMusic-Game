//
//  OutlineShader.metal
//  ARMusic-Game (IpadOS)
//
//  Created by Victor Soares on 03/08/24.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

[[visible]]
void OutlineSurfaceShader(realitykit::surface_parameters params) {
    
    params.surface().set_base_color(half3(0.0, 0.0, 0.0));
}

[[visible]]
void OutlineGeometryShader(realitykit::geometry_parameters params) {

    float outlineWidth = 1.0;
    
    float3 normal = normalize(params.geometry().model_position());
    
    params.geometry().set_model_position_offset(normal * outlineWidth);
    
}



