using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AniManager : MonoBehaviour
{
    public List<AnimateObject> objectsToAnimate; // List of objects to animate
    public List<float> waitTimes; // List of wait times between animations

    void Start()
    {
        if (objectsToAnimate.Count != waitTimes.Count)
        {
            Debug.LogError("The number of objects and wait times should be equal.");
            return;
        }

        
    }

    private IEnumerator AnimateSequence()
    {
        for (int i = 0; i < objectsToAnimate.Count; i++)
        {
            objectsToAnimate[i].gameObject.SetActive(true); // Enable the object
            yield return StartCoroutine(objectsToAnimate[i].Animate()); // Animate the object

            if (i < waitTimes.Count)
            {
                yield return new WaitForSeconds(waitTimes[i]); // Wait for the specified time
            }
        }
    }

    public void StartAnimation()
    {
        StartCoroutine(AnimateSequence());
    }


}
