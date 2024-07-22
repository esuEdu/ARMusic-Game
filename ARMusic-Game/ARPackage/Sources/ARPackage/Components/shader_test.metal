//
//  shader_test.metal
//  ARMusic-Game (IpadOS)
//
//  Created by Victor Soares on 22/07/24.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

[[visible]]
void mySurfaceShader(realitykit::surface_parameters params)
{
    // Retrieve the base color tint from the entity's material.
    
    params.surface().set_base_color(half3(1.0, 0.0, 0.0));
}

[[visible]]
void simpleGeometryModifier(realitykit::geometry_parameters params)
{
    float3 zOffset = float3(0.0, 0.0, sin(params.uniforms().time() * 10) * 0.5);
    params.geometry().set_world_position_offset(zOffset);
}


