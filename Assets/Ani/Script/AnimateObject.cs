using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateObject : MonoBehaviour
{
    public float duration = 5.0f;  // Duration of the movement

    private bool isAnimating = false;

    protected List<GameObject> underObjects = new List<GameObject>();

    void Awake()
    {
        foreach (Transform child in transform)
        {
            underObjects.Add(child.gameObject);
        }
    }

    public IEnumerator Animate()
    {
        isAnimating = true;
        float elapsedTime = 0;
        BeginAnimation();

        while (elapsedTime < duration)
        {
            elapsedTime += Time.deltaTime;
            EachDeltaAnimation();
            yield return null;
        }

        EndAnimation();
        isAnimating = false;
    }

    public virtual void EachDeltaAnimation()
    {

    }

    public virtual void BeginAnimation()
    {

    }

    public virtual void EndAnimation()
    {

    }

}
