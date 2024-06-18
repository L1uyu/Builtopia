using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IconUIFolder : AnimateObject
{
    public float ease_time = 1.0f;
    private Vector3 local_scale;
    public override void BeginAnimation()
    {
        base.BeginAnimation();
        local_scale = transform.localScale;
    }
    public override void EachDeltaAnimation(float elapsedTime)
    {
        base.EachDeltaAnimation(elapsedTime);
        float ease_in = elapsedTime < ease_time ? elapsedTime / ease_time : 1.0f;
        float ease_out = duration - elapsedTime < ease_time ? (duration - elapsedTime) / ease_time : 1.0f;
        transform.localScale = ease_in * ease_out * local_scale;


    }

    public override void EndAnimation()
    {
        base.EndAnimation();
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
