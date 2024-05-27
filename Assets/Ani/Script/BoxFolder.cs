using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoxFolder : AnimateObject
{
    public float material_spark = 12.0f;
    public override void BeginAnimation()
    {
        base.BeginAnimation();
        foreach (GameObject obj in underObjects)
        {
            Material material = obj.GetComponent<LineRenderer>().material;
            material.SetFloat("_FlowSpeed", material_spark);
        }
        
    }
    public override void EndAnimation()
    {
        base.EndAnimation();
        foreach (GameObject obj in underObjects)
        {
            Material material = obj.GetComponent<LineRenderer>().material;
            material.SetFloat("_FlowSpeed", 0.0f);
        }
    }
}
