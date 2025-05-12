cbuffer cbChangeOnCameraMovement : register(b0)
{
    matrix View;
    float4 CameraPosition;
};

cbuffer cbProjection : register(b1)
{
    matrix Projection;
};

cbuffer cbChangeEveryFrame : register(b2)
{
    matrix World;
    float4 OutColor;
};

cbuffer cbLights : register(b3)
{
    float4 LightPositions[2];
    float4 LightColors[2];
};

struct VS_INPUT
{
    float4 Position : POSITION;
    float2 TexCoord : TEXCOORD0;
    float3 Normal : NORMAL;
};

struct PS_INPUT
{
    float4 Position : SV_POSITION;
    float2 TexCoord : TEXCOORD0;
    float3 Normal : NORMAL;
    float3 WorldPosition : WORLDPOS;
};

PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;

    output.Position = mul(input.Position, World);
    output.Position = mul(output.Position, View);
    output.Position = mul(output.Position, Projection);

    output.Normal = normalize(mul(float4(input.Normal, 0.0f), World).xyz);
    output.WorldPosition = mul(input.Position, World);

    output.TexCoord = input.TexCoord;

    return output;
}

Texture2D txDiffuse : register(t0);
SamplerState samLinear : register(s0);

float4 PS(PS_INPUT input) : SV_Target
{
    float3 viewDirection = normalize(CameraPosition.xyz - input.WorldPosition);
    float4 color = txDiffuse.Sample(samLinear, input.TexCoord);
    float3 diffuse = 0;
    float3 ambient = 0;
    float3 specular = 0;

    for (uint i = 0; i < 2; i++)
    {
        float3 LightDirection = normalize(input.WorldPosition - LightPositions[i].xyz);
        diffuse += (dot(input.Normal, -LightDirection) * LightColors[i]).xyz;
        ambient += float3(0.1f, 0.1f, 0.1f);
        specular += (pow(dot(reflect(LightDirection, input.Normal), viewDirection), 4.0f) * LightColors[i]).rgb;
    }

    return float4(saturate((diffuse + specular + ambient) * color.rgb), color.a);
}

float4 PSSolid(PS_INPUT input) : SV_Target
{
    return OutColor;
}