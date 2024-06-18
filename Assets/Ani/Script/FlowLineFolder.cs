using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlowLineFolder : AnimateObject
{
    public float ease_time = 3.0f;
    public override void EachDeltaAnimation(float elapsedTime)
    {
        base.EachDeltaAnimation(elapsedTime);
        float ease_in = elapsedTime < ease_time ? GetEaseAlpha(elapsedTime / ease_time) : 1.0f;
        float ease_out = duration - elapsedTime < ease_time ? (duration - elapsedTime) / ease_time : 1.0f;
        foreach (GameObject obj in underObjects)
        {
            Material material = obj.GetComponent<LineRenderer>().material;
            material.SetFloat("_Alpha", ease_in * ease_out);
        }
    }

    public override void EndAnimation()
    {
        base.EndAnimation();
        foreach (GameObject obj in underObjects)
        {
            Material material = obj.GetComponent<LineRenderer>().material;
            material.SetFloat("_Alpha", 0.0f);
        }
    }

    private float GetEaseAlpha(float ease)
    {
        float ease_alpha = 1.0f;
        ease_alpha = Mathf.Pow(ease, 3.0f);
        return ease_alpha;
    }
}
