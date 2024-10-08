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
    
    params.surface().set_metallic(0);
    params.surface().set_specular(0);
    params.surface().set_ambient_occlusion(0);
    params.surface().set_base_color(half3(1.0, 0.482, 0.0));
}

[[visible]]
void OutlineGeometryShader(realitykit::geometry_parameters params) {

    float outlineWidth = 0.5;
    
    float3 normal = params.geometry().normal();
    
    params.geometry().set_model_position_offset(normal * outlineWidth);
    
}



