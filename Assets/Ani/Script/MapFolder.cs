using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapFolder : AnimateObject
{
    public List<Transform> maps;
    public float ease_times;
    public float stay_times;
    public List<Vector3> local_scales;

    public override void BeginAnimation()
    {
        base.BeginAnimation();
        foreach(Transform obj in maps)
        {
            Vector3 scale = obj.localScale;
            local_scales.Add(scale);
            obj.localScale = new Vector3(0, 0,0);
            obj.gameObject.SetActive(true);
        }

    }
    public override void EachDeltaAnimation(float elapsedTime)
    {
        base.EachDeltaAnimation(elapsedTime);
        
    }

}
