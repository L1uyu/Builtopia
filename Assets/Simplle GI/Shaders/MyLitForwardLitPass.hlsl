#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Textures
TEXTURE2D(_ColorMap); SAMPLER(sampler_ColorMap); // RGB = albedo, A = alpha
TEXTURE2D(_Irradiancemap); SAMPLER(sampler_Irradiancemap);
float4 _Irradiancemap_ST;
float4 _ColorMap_ST; // This is automatically set by Unity. Used in TRANSFORM_TEX to apply UV tiling
float4 _ColorTint;
float _Smoothness;

// This attributes struct receives data about the mesh we're currently rendering
// Data is automatically placed in fields according to their semantic
struct Attributes {
	float3 positionOS : POSITION; // Position in object space
	float3 normalOS : NORMAL; // Normal in object space
	float2 uv : TEXCOORD0; // Material texture UVs
};

// This struct is output by the vertex function and input to the fragment function.
// Note that fields will be transformed by the intermediary rasterization stage
struct Interpolators {
	// This value should contain the position in clip space (which is similar to a position on screen)
	// when output from the vertex function. It will be transformed into pixel position of the current
	// fragment on the screen when read from the fragment function
	float4 positionCS : SV_POSITION;

	// The following variables will retain their values from the vertex stage, except the
	// rasterizer will interpolate them between vertices
	float2 uv : TEXCOORD0; // Material texture UVs
	float3 positionWS : TEXCOORD1; // Position in world space
	float3 normalWS : TEXCOORD2; // Normal in world space
};

float4 SampleCSEnvironmentIrradiance(half3 viewDirectionWS, half3 normalWS)
{
    half3 reflectVector = normalWS; //reflect(-viewDirectionWS, normalWS);
	float2 cUV;
	int texIndex;
	float3 reflectVectorABS = abs(reflectVector.xyz);
	if (reflectVectorABS.x >= reflectVectorABS.y && reflectVectorABS.x > reflectVectorABS.z)
	{
		if (reflectVector.x > 0)
		{
			texIndex = 0;
			cUV = float2(-reflectVector.z / reflectVectorABS.x * 0.5 + 0.5, reflectVector.y / reflectVectorABS.x * 0.5 + 0.5);
		}
		else
		{
			texIndex = 1;
			cUV = float2(reflectVector.z / reflectVectorABS.x * 0.5 + 0.5, reflectVector.y / reflectVectorABS.x * 0.5 + 0.5);
		}
	}
	else if (reflectVectorABS.y > reflectVectorABS.x && reflectVectorABS.y > reflectVectorABS.z)
	{
		if (reflectVector.y > 0)
		{
			texIndex = 2;
			cUV = float2(reflectVector.x / reflectVectorABS.y * 0.5 + 0.5, -reflectVector.z / reflectVectorABS.y * 0.5 + 0.5);
		}
		else
		{
			texIndex = 3;
			cUV = float2(reflectVector.x / reflectVectorABS.y * 0.5 + 0.5, reflectVector.z / reflectVectorABS.y * 0.5 + 0.5);
		}
	}
	else
	{
		if (reflectVector.z > 0)
		{
			texIndex = 4;
			cUV = float2(reflectVector.x / reflectVectorABS.z * 0.5 + 0.5, reflectVector.y / reflectVectorABS.z * 0.5 + 0.5);
		}
		else
		{
			texIndex = 5;
			cUV = float2(-reflectVector.x / reflectVectorABS.z * 0.5 + 0.5, reflectVector.y / reflectVectorABS.z * 0.5 + 0.5);
		}
	}

	float2 offset = 0;
	float2 size = float2(1.0f / 3.0f, 0.5f);
	if (texIndex == 0)offset = float2(2, 1) * size;
	if (texIndex == 1)offset = float2(0, 1) * size;
	if (texIndex == 2)offset = float2(0, 0) * size;
	if (texIndex == 3)offset = float2(1, 0) * size;
	if (texIndex == 4)offset = float2(1, 1) * size;
	if (texIndex == 5)offset = float2(2, 0) * size;

	float2 finalUV = cUV * size + offset;
	return SAMPLE_TEXTURE2D(_Irradiancemap, sampler_Irradiancemap, finalUV);
}

// The vertex function. This runs for each vertex on the mesh.
// It must output the position on the screen each vertex should appear at,
// as well as any data the fragment function will need
Interpolators Vertex(Attributes input) {
	Interpolators output;

	// These helper functions, found in URP/ShaderLib/ShaderVariablesFunctions.hlsl
	// transform object space values into world and clip space
	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);
	VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

	// Pass position and orientation data to the fragment function
	output.positionCS = posnInputs.positionCS;
	output.uv = TRANSFORM_TEX(input.uv, _ColorMap);
	output.normalWS = normInputs.normalWS;
	output.positionWS = posnInputs.positionWS;

	return output;
}

// The fragment function. This runs once per fragment, which you can think of as a pixel on the screen
// It must output the final color of this pixel
float4 Fragment(Interpolators input) : SV_TARGET{
	float2 uv = input.uv;
	// Sample the color map
	float4 colorSample = SAMPLE_TEXTURE2D(_ColorMap, sampler_ColorMap, uv);

	// For lighting, create the InputData struct, which contains position and orientation data
	InputData lightingInput = (InputData)0; // Found in URP/ShaderLib/Input.hlsl
	lightingInput.positionWS = input.positionWS;
	lightingInput.normalWS = normalize(input.normalWS);
    lightingInput.viewDirectionWS = GetWorldSpaceNormalizeViewDir(input.positionWS); // In ShaderVariablesFunctions.hlsl
    lightingInput.shadowCoord = TransformWorldToShadowCoord(input.positionWS); // In Shadows.hlsl
	
	// Calculate the surface data struct, which contains data from the material textures
	SurfaceData surfaceInput = (SurfaceData)0;
    surfaceInput.albedo = colorSample.rgb * _ColorTint.rgb;
	surfaceInput.alpha = colorSample.a * _ColorTint.a;
    surfaceInput.specular = float3(0.0, 0.0, 0.0);
    surfaceInput.occlusion = 1.0;
    surfaceInput.metallic = 0.0;
	surfaceInput.smoothness = _Smoothness;

	float4 gi = SampleCSEnvironmentIrradiance(GetWorldSpaceNormalizeViewDir(input.positionWS), normalize(input.normalWS)) * float4(colorSample.rgb * _ColorTint.rgb,0);

#if UNITY_VERSION >= 202120
	return UniversalFragmentBlinnPhong(lightingInput, surfaceInput) + gi;
#else
    return UniversalFragmentBlinnPhong(lightingInput, surfaceInput.albedo, float4(surfaceInput.specular, 1), surfaceInput.smoothness, surfaceInput.emission, surfaceInput.alpha) + gi;
#endif
}


