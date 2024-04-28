using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class BaseAI : MonoBehaviour
{
    protected float decisionInterval = 5.0f;
    protected float lastDecisionTime = 0;

    // Common properties that all AI types might need
    public float fatigue;
    public float safety;
    public float hungry;
    public List<BaseItem> items;

    // Update is called once per frame
    protected virtual void Update()
    {
        if (Time.time - lastDecisionTime > decisionInterval)
        {
            DecideNextAction();
            lastDecisionTime = Time.time;
        }
    }

    protected abstract void DecideNextAction();

    protected virtual void Rest()
    {
        Debug.Log("Resting");
        fatigue = 0;
    }

    protected virtual void SeekSafety()
    {
        Debug.Log("Seeking safety");
        safety = 100;
    }

    protected virtual void Eat()
    {
        Debug.Log("Eating");
        hungry = 0;
    }
}
