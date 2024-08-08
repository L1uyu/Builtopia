using System.Collections.Generic;
using UnityEngine;

public class ComputeShaderExample : MonoBehaviour
{
    public ComputeShader computeShader;
    private RenderTexture inputCubemap; // The reflection probe's real-time texture
    [HideInInspector]public RenderTexture irradianceMap;
    public GameObject nan;
    private List<Material> materials = new();
    public Renderer meshRenderer;
    private Material material;
    public int size = 32;
    private int threadGroupsX;
    private int threadGroupsY;
    private int threadGroupsZ;
    private CubemapCapture probe;//ReflectionProbe probe;

    void Start()
    {
        // Get the reflection probe's real-time texture
        probe = GetComponent<CubemapCapture>();//<ReflectionProbe>();
        
        material = meshRenderer.material;
        // Create the RenderTexture for the irradiance map
        irradianceMap = new RenderTexture(size * 3, size * 2, 0, RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
        //irradianceMap.dimension = UnityEngine.Rendering.TextureDimension.Tex2D;
        irradianceMap.filterMode = FilterMode.Point;
        irradianceMap.enableRandomWrite = true;
        irradianceMap.Create();

        Renderer[] Renderers = nan.GetComponentsInChildren<Renderer>();
        foreach (Renderer skinned in Renderers)
        {
            Material temp = skinned.material;
            temp.SetTexture("_Irradiancemap", irradianceMap);
        }

        // Set the variables in the compute shader

        computeShader.SetTexture(0, "_irradiancemap", irradianceMap);
        computeShader.SetInt("size", size);

        // Calculate the number of thread groups needed
        threadGroupsX = Mathf.CeilToInt(size / 8.0f);
        threadGroupsY = Mathf.CeilToInt(size / 8.0f);
        threadGroupsZ = 6; // Since we are processing 6 faces of the cubemap
        
    }

    void Update()
    {
        inputCubemap = probe.activeCubemap;//probe.realtimeTexture;

        if (probe == null || probe.activeCubemap == null)//realtimeTexture == null)
        {
            return;
        }
        computeShader.SetTexture(0, "_inputCubemap", inputCubemap);
        computeShader.Dispatch(0, threadGroupsX, threadGroupsY, threadGroupsZ);
        //material.SetTexture("_Irradiancemap", irradianceMap);
    }

    void OnGUI()
    {
        if (irradianceMap != null)
        {
            GUI.DrawTexture(new Rect(10, 10, size * 15, size * 10), irradianceMap, ScaleMode.ScaleToFit, false);
        }
    }
}
