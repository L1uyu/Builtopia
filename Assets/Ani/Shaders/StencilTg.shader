Shader "Custom URP/Stencil 1 gold"
{
    Properties
    {
        [NonModifiableTextureData][Normal][NoScaleOffset]_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D("Texture2D", 2D) = "bump" {}
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D("Texture2D", 2D) = "white" {}
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        Stencil
        {
              Ref 1
              Comp Equal
        }
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _RECEIVE_SHADOWS_OFF 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4);
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_R_4_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_G_5_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_B_6_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_A_7_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.a;
            float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D).GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_R_4_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.r;
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_G_5_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.g;
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_B_6_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.b;
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_A_7_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.a;
            surface.BaseColor = IsGammaSpace() ? float3(1, 0.8431373, 0) : SRGBToLinear(float3(1, 0.8431373, 0));
            surface.NormalTS = (_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 1;
            surface.Smoothness = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_G_5_Float;
            surface.Occlusion = 1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _RECEIVE_SHADOWS_OFF 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4);
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_R_4_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_G_5_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_B_6_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_A_7_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.a;
            float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D).GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_R_4_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.r;
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_G_5_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.g;
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_B_6_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.b;
            float _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_A_7_Float = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_RGBA_0_Vector4.a;
            surface.BaseColor = IsGammaSpace() ? float3(1, 0.8431373, 0) : SRGBToLinear(float3(1, 0.8431373, 0));
            surface.NormalTS = (_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 1;
            surface.Smoothness = _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_G_5_Float;
            surface.Occlusion = 1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D).GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4);
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_R_4_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_G_5_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_B_6_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_A_7_Float = _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.a;
            surface.NormalTS = (_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_RGBA_0_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.BaseColor = IsGammaSpace() ? float3(1, 0.8431373, 0) : SRGBToLinear(float3(1, 0.8431373, 0));
            surface.Emission = float3(0, 0, 0);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D_TexelSize;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_1b0884f63740470ca5f6b81480c6f8d4_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_54ddb827a022448eba28fd4e7c0dce90_Texture_1_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_MatrixConstruction_Row_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
        {
            Out4x4 = float4x4(M0.x, M0.y, M0.z, M0.w, M1.x, M1.y, M1.z, M1.w, M2.x, M2.y, M2.z, M2.w, M3.x, M3.y, M3.z, M3.w);
            Out3x3 = float3x3(M0.x, M0.y, M0.z, M1.x, M1.y, M1.z, M2.x, M2.y, M2.z);
            Out2x2 = float2x2(M0.x, M0.y, M1.x, M1.y);
        }
        
        void Unity_Multiply_float3_float3x3(float3 A, float3x3 B, out float3 Out)
        {
            Out = mul(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3;
            Unity_Subtract_float3(_WorldSpaceCameraPos, SHADERGRAPH_OBJECT_POSITION, _Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3);
            float3 _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3;
            Unity_Normalize_float3(_Subtract_f2f7836d36c4421fbcea169cb7c4e85b_Out_2_Vector3, _Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3);
            float3 _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3;
            _Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3 = TransformWorldToObjectDir(_Normalize_14b39beabcea4141ab21c13605ef5c5f_Out_1_Vector3.xyz, true);
            float3 _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3;
            Unity_Normalize_float3(_Transform_89eb334afece47a1a90747b8bf95fa6e_Out_1_Vector3, _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3);
            float3 _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3;
            Unity_CrossProduct_float(float3 (0, 1, 0), _Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3);
            float3 _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3);
            float3 _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3;
            Unity_CrossProduct_float(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, _CrossProduct_c9a6332fcc2d449781e0cb55897d488c_Out_2_Vector3, _CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3);
            float3 _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3;
            Unity_Normalize_float3(_CrossProduct_8799aa10454d41788c601715433bf68e_Out_2_Vector3, _Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3);
            float4x4 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4;
            float3x3 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3;
            float2x2 _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2;
            Unity_MatrixConstruction_Row_float((float4(_Normalize_e0f705ae21714fba9796d54cc570145f_Out_1_Vector3, 1.0)), (float4(_Normalize_02597230b6924e9e821fc0a4e22fdb2a_Out_1_Vector3, 1.0)), (float4(_Normalize_cfe26f4ed0dd4e0e878b6dae4c7b5e29_Out_1_Vector3, 1.0)), float4 (0, 0, 0, 1), _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var4x4_4_Matrix4, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var2x2_6_Matrix2);
            float3 _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpacePosition, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3);
            float3 _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceNormal, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3);
            float3 _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            Unity_Multiply_float3_float3x3(IN.ObjectSpaceTangent, _MatrixConstruction_654d055117be4d50ad0c4ca11307914a_var3x3_5_Matrix3, _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3);
            description.Position = _Multiply_d0a750bb2d874a1aa9c5819a0885f00c_Out_2_Vector3;
            description.Normal = _Multiply_cbd95d89ecfe4146ac0674c70354d6bc_Out_2_Vector3;
            description.Tangent = _Multiply_a2d3d74cf8ff46a9aa39e677a545a1f5_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.BaseColor = IsGammaSpace() ? float3(1, 0.8431373, 0) : SRGBToLinear(float3(1, 0.8431373, 0));
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}