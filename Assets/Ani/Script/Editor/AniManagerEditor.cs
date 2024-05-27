using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(AniManager))]
public class AniManagerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        // Draw the default inspector
        DrawDefaultInspector();

        // Get the target component
        AniManager AniManager = (AniManager)target;

        // Add a button to the inspector
        if (GUILayout.Button("Start Animation"))
        {
            AniManager.StartAnimation();
        }
    }
}
