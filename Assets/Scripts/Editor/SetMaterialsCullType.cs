using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class SetMaterialsCullType : EditorWindow
{
    private Dictionary<int, int> materialCullTypeMap = new Dictionary<int, int>();

    [MenuItem("Tools/Lucien Tools/Set Materials Cull Type")]
    public static void ShowWindow()
    {
        GetWindow<SetMaterialsCullType>("Set Double-Sided Materials");
    }

    private void OnGUI()
    {
        if (GUILayout.Button("Store Current Cull Types"))
        {
            StoreCurrentCullTypes();
        }
        if (GUILayout.Button("Set All MeshRenderers to Double-Sided"))
        {
            SetMaterialsDoubleSided();
        }

        if (GUILayout.Button("Set All Cull Types to Front"))
        {
            SetAllCullTypesToFront();
        }

        if (GUILayout.Button("Reset Cull Types"))
        {
            ResetCullTypes();
        }

        
    }

    private void SetMaterialsDoubleSided()
    {
        MeshRenderer[] meshRenderers = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer renderer in meshRenderers)
        {
            Material[] materials = renderer.sharedMaterials;

            foreach (Material material in materials)
            {
                material.SetInt("_Cull", (int)UnityEngine.Rendering.CullMode.Off);
            }
        }

        Debug.Log("All MeshRenderers materials set to double-sided.");
    }

    private void StoreCurrentCullTypes()
    {
        materialCullTypeMap.Clear();

        MeshRenderer[] meshRenderers = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer renderer in meshRenderers)
        {
            Material[] materials = renderer.sharedMaterials;

            foreach (Material material in materials)
            {
                int materialID = material.GetInstanceID();
                int cullType = material.GetInt("_Cull");

                if (!materialCullTypeMap.ContainsKey(materialID))
                {
                    materialCullTypeMap.Add(materialID, cullType);
                }
            }
        }

        Debug.Log("Stored current cull types.");
    }

    private void ResetCullTypes()
    {
        MeshRenderer[] meshRenderers = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer renderer in meshRenderers)
        {
            Material[] materials = renderer.sharedMaterials;

            foreach (Material material in materials)
            {
                int materialID = material.GetInstanceID();

                if (materialCullTypeMap.ContainsKey(materialID))
                {
                    material.SetInt("_Cull", materialCullTypeMap[materialID]);
                }
            }
        }

        Debug.Log("Reset all cull types to stored values.");
    }

    private void SetAllCullTypesToFront()
    {
        MeshRenderer[] meshRenderers = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer renderer in meshRenderers)
        {
            Material[] materials = renderer.sharedMaterials;

            foreach (Material material in materials)
            {
                material.SetInt("_Cull", (int)UnityEngine.Rendering.CullMode.Back);
            }
        }

        Debug.Log("All MeshRenderers materials set to render front faces.");
    }
}
