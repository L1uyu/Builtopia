using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIFolder : AnimateObject
{
    
    private DancingNumber dancingNumber;


    public override void BeginAnimation()
    {
        base.BeginAnimation();
        dancingNumber = GetComponent<DancingNumber>();
        if (!dancingNumber)
        {
            Debug.LogError("No DancingNumber component in " + transform.name);
        }
        else
        {
            dancingNumber.StartUpdateNumber();
        }
    }

}
