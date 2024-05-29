using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaticleFolder : AnimateObject
{
    private List<Transform> reflection_cubes = new();
    private Vector3 real_scale = new(1.0f,1.0f,0.5f);
    public float ease_time = 3.0f;

    public override void BeginAnimation()
    {
        base.BeginAnimation();
        foreach(GameObject obj in underObjects)
        {
            Transform cube = obj.transform.Find("Cube");
            reflection_cubes.Add(cube);
        }
    }
    public override void EachDeltaAnimation(float elapsedTime)
    {
        base.EachDeltaAnimation(elapsedTime);
        float scale_bigger = (duration - elapsedTime) < ease_time ? 1.0f - (duration - elapsedTime) / ease_time : 0.01f;
        scale_bigger *= scale_bigger;
        if (scale_bigger > 0.010001)
        {
            foreach (Transform cube in reflection_cubes)
            {
                cube.localScale = real_scale * scale_bigger;
            }
        }
    }
    public override void EndAnimation()
    {
        base.EndAnimation();
    }
}
