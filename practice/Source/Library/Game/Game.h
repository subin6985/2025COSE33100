#pragma once

#include "Common.h"

HRESULT InitWindow(_In_ HINSTANCE hInstance, _In_ INT nCmdShow);

LRESULT CALLBACK WindowProc(
	_In_ HWND hWnd,
	_In_ UINT uMsg,
	_In_ WPARAM wParam,
	_In_ LPARAM lParam
);

HRESULT InitDevice();

struct SimpleVertex
{
	XMFLOAT3 Position;
	XMFLOAT2 TexCoord;
	XMFLOAT3 Normal;
};

struct CBChangeOnCameraMovement
{
	XMMATRIX View;
	XMFLOAT4 CameraPosition;
};

struct CBProjection
{
	XMMATRIX mProjection;
};

struct CBChangeEveryFrame
{
	XMMATRIX World;
	XMFLOAT4 OutputColor;
};

struct CBLights
{
	XMFLOAT4 LightPositions[2];
	XMFLOAT4 LightColors[2];
};

void CleanupDevice();

void Render();

HRESULT CompileShaderFromFile(
	_In_     PCWSTR      pszFileName,   // FileName
	_In_     PCSTR       pszEntryPoint,  // EntryPoint
	_In_     PCSTR       pszShaderModel,  // Shader target
	_Outptr_ ID3DBlob** ppBlobOut  // ID3DBlob out
);