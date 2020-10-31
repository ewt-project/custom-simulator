//--------------------------------------------------------------------------------------
// File: FluidRender.hlsl
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Particle Rendering
//--------------------------------------------------------------------------------------

struct ParticleData {
    float2 position;
	float2 velocity;
	float2 index;
	float2 padding;
};

struct ParticleDensity {
    float density;
};

StructuredBuffer<ParticleData> ParticlesRO : register( t0 );
StructuredBuffer<ParticleDensity> ParticleDensityRO : register( t1 );

cbuffer cbRenderConstants : register( b0 )
{
    matrix g_mViewProjection;
    float g_fParticleSize;
};

struct VSParticleOut
{
    float2 position : POSITION;
    float4 color : COLOR;
};

struct GSParticleOut
{
    float4 position : SV_Position;
    float4 color : COLOR;
    float2 texcoord : TEXCOORD;
};


//--------------------------------------------------------------------------------------
// Visualization Helper
//--------------------------------------------------------------------------------------

static const float4 Rainbow[2] = {
    float4(1.00, 0.60, 0.00, 0.775),
    float4(1.00, 0.00, 0.00, 0.955),
};

float4 VisualizeNumber(float n)
{
    return lerp( Rainbow[0], Rainbow[1], n );
}

float4 VisualizeNumber(float n, float lower, float upper)
{
    return VisualizeNumber( saturate( (n - lower) / (upper - lower) ) );
}


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------

VSParticleOut ParticleVS(uint ID : SV_VertexID)
{
    VSParticleOut Out = (VSParticleOut)0;
	Out.position = ParticlesRO[ID].position;	//DEBUG//
    Out.color = VisualizeNumber(ParticleDensityRO[ID].density, 00.0f, 650.0f);
    return Out;
}


//--------------------------------------------------------------------------------------
// Particle Geometry Shader
//--------------------------------------------------------------------------------------

static const float2 g_positions[4] = { float2(-1, 1), float2(1, 1), float2(-1, -1), float2(1, -1) };
static const float2 g_texcoords[4] = { float2(0, 1), float2(1, 1), float2(0, 0), float2(1, 0) };

[maxvertexcount(4)]
void ParticleGS(point VSParticleOut In[1], inout TriangleStream<GSParticleOut> SpriteStream)
{
    [unroll]
    for (int i = 0; i < 4; i++)
    {
        GSParticleOut Out = (GSParticleOut)0;
        float4 position = float4(In[0].position, 0, 1) + g_fParticleSize * float4(g_positions[i], 0, 0);
        Out.position = mul(position, g_mViewProjection);
        Out.color = In[0].color;
        Out.texcoord = g_texcoords[i];
        SpriteStream.Append(Out);
    }
    SpriteStream.RestartStrip();
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------

float4 ParticlePS(GSParticleOut In) : SV_Target
{
    return In.color;
}
