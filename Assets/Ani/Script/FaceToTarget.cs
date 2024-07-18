using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FaceToTarget : MonoBehaviour
{
    public Transform target; // The target to look at
    public float rotationSpeed = 5f; // Speed of the rotation
    // Start is called before the first frame update
    void Start()
    {
        if (!target)
        {
            target = Camera.main.transform;
        }
        
    }

    // Update is called once per frame
    void Update()
    {
        if (target != null)
        {
            // Calculate the direction to the target
            Vector3 direction = ( transform.position - target.position).normalized;

            // Calculate the desired rotation (only around y-axis)
            direction.y = 0; // Set y component to 0 to ignore vertical differences
            Quaternion lookRotation = Quaternion.LookRotation(direction);

            // Get the current rotation in Euler angles
            Vector3 currentEulerAngles = transform.rotation.eulerAngles;
            Vector3 targetEulerAngles = lookRotation.eulerAngles;

            // Maintain the current x and z rotation, only changing the y rotation
            Vector3 smoothedEulerAngles = new Vector3(currentEulerAngles.x, Mathf.LerpAngle(currentEulerAngles.y, targetEulerAngles.y, Time.deltaTime * rotationSpeed), currentEulerAngles.z);

            // Apply the new rotation
            transform.rotation = Quaternion.Euler(smoothedEulerAngles);
        }

    }
}
