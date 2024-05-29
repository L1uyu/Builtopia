using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoxFolder : AnimateObject
{
    public float material_spark = 12.0f;
    public float ease_time = 3.0f;
    private List<Material> materials = new();
    public override void BeginAnimation()
    {
        base.BeginAnimation();
        foreach (GameObject obj in underObjects)
        {
            Material material = obj.GetComponent<LineRenderer>().material;
            material.SetFloat("_FlowSpeed", material_spark);
            materials.Add(material);
        }
        
    }

    public override void EachDeltaAnimation(float elapsedTime)
    {
        base.EachDeltaAnimation(elapsedTime);
        float ease_in = elapsedTime < ease_time ? elapsedTime / ease_time : 1.0f;
        //float ease_out = 1.0f;//duration - elapsedTime < ease_time ? (duration - elapsedTime) / ease_time : 1.0f;
        foreach (Material material in materials)
        {
            material.SetFloat("_Alpha", ease_in);
        }
    }
    public override void EndAnimation()
    {
        base.EndAnimation();
        foreach (Material material in materials)
        {
            material.SetFloat("_FlowSpeed", 0.0f);
        }
    }
}
