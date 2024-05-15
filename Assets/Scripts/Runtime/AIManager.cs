using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AIManager : MonoBehaviour
{
    private List<BaseAI> allAIs;

    void Start()
    {
        allAIs = new List<BaseAI>(FindObjectsOfType<BaseAI>());
    }

    // Update all AI decisions if needed or manage global events
    void Update()
    {
        // Example: Trigger a global event that affects all AIs
    }
}
