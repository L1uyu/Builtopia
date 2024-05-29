using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIFolder : AnimateObject
{
    public Transform target; // The target to look at
    public float rotationSpeed = 5f; // Speed of the rotation
    private DancingNumber dancingNumber;

    private void Start()
    {
        target = Camera.main.transform;
    }

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
    void Update()
    {
        if (target != null)
        {
            // Update pivot position if needed
            // Example: pivotPosition = some value or calculation;

            // Calculate the direction to the target
            Vector3 direction = (transform.position - target.position).normalized;

            // Calculate the desired rotation
            Quaternion lookRotation = Quaternion.LookRotation(direction);

            // Smoothly rotate towards the target
            transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, Time.deltaTime * rotationSpeed);
        }
    }
}
