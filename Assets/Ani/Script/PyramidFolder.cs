using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PyramidFolder : AnimateObject
{
    public float scale_time = 1.0f;
    public float min_size = 0.8f;
    public Transform pivot;
    private Vector3 initialLocalScale = new();
    private Vector3 initialLocalPosition = new();
    private Quaternion initialLocalRotation = new();
    public override void BeginAnimation()
    {
        base.BeginAnimation();
        initialLocalScale = transform.localScale;
        initialLocalPosition = transform.localPosition;
        initialLocalRotation = transform.localRotation;
    }
    public override void EachDeltaAnimation(float elapsedTime)
    {
        base.EachDeltaAnimation(elapsedTime);
        float scale_small = elapsedTime < scale_time? elapsedTime / scale_time: 1.0f;
        float scale_big = (duration - elapsedTime) < scale_time ? 1.0f - (duration - elapsedTime) / scale_time : 1.0f;
        if (scale_small < 1.0f)
        {
            float new_size = min_size * scale_small + (1.0f - scale_small);
            transform.localScale = initialLocalScale * new_size;
        }
        if (scale_big < 1.0f)
        {
            float new_size = scale_big + min_size * (1.0f - scale_big);
            transform.localScale = initialLocalScale * new_size;
        }
        float angle = 360.0f * Time.deltaTime / duration;
        transform.RotateAround(pivot.position, transform.up,angle);
    }

    public override void EndAnimation()
    {
        base.EndAnimation();
        transform.localPosition = initialLocalPosition;
        transform.localRotation = initialLocalRotation;
        transform.localScale = initialLocalScale;
    }
}
