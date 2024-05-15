using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;

public class BoxLineRendererEditor : EditorWindow
{
    private GameObject[] selectedGameObjects = new GameObject[0];

    [MenuItem("Tools/Box Line Renderer Tool")]
    public static void ShowWindow()
    {
        GetWindow<BoxLineRendererEditor>("Box Line Renderer Tool");
    }

    void OnGUI()
    {
        GUILayout.Label("Drag and Drop GameObjects Here:", EditorStyles.boldLabel);

        // Create a drop area for GameObjects
        Rect dropArea = GUILayoutUtility.GetRect(0.0f, 50.0f, GUILayout.ExpandWidth(true));
        GUI.Box(dropArea, "Drop GameObjects Here");

        HandleDragAndDrop(dropArea);

        if (selectedGameObjects.Length > 0)
        {
            GUILayout.Label("Selected GameObjects:");
            foreach (GameObject obj in selectedGameObjects)
            {
                GUILayout.Label(obj.name);
            }
        }

        if (GUILayout.Button("Update"))
        {
            foreach (GameObject obj in selectedGameObjects)
            {
                if (obj != null)
                {
                    LineRenderer lineRenderer = obj.GetComponent<LineRenderer>();
                    if (lineRenderer != null)
                    {
                        UpdateLineRenderer(lineRenderer, obj.transform.position, obj.transform.localScale);
                    }
                    else
                    {
                        EditorUtility.DisplayDialog("Error", "No Line Renderer found on the object " + obj.name, "OK");
                    }
                }
            }
        }
    }

    private void HandleDragAndDrop(Rect dropArea)
    {
        Event evt = Event.current;
        switch (evt.type)
        {
            case EventType.DragUpdated:
            case EventType.DragPerform:
                if (!dropArea.Contains(evt.mousePosition))
                    return;

                DragAndDrop.visualMode = DragAndDropVisualMode.Copy;

                if (evt.type == EventType.DragPerform)
                {
                    DragAndDrop.AcceptDrag();

                    List<GameObject> draggedObjects = new List<GameObject>();
                    foreach (GameObject dragged_object in DragAndDrop.objectReferences)
                    {
                        if (dragged_object is GameObject)
                        {
                            draggedObjects.Add((GameObject)dragged_object);
                        }
                    }

                    selectedGameObjects = draggedObjects.ToArray();
                }
                break;
        }
    }

    private void UpdateLineRenderer(LineRenderer lineRenderer, Vector3 origin, Vector3 scale)
    {
        Vector3 halfScale = scale * 0.5f;
        Vector3[] boxPoints = new Vector3[]
        {
            origin + new Vector3(-halfScale.x, -halfScale.y, -halfScale.z),
            origin + new Vector3(halfScale.x, -halfScale.y, -halfScale.z),
            origin + new Vector3(halfScale.x, halfScale.y, -halfScale.z),
            origin + new Vector3(-halfScale.x, halfScale.y, -halfScale.z),
            origin + new Vector3(-halfScale.x, -halfScale.y, -halfScale.z),
            origin + new Vector3(-halfScale.x, -halfScale.y, halfScale.z),
            origin + new Vector3(halfScale.x, -halfScale.y, halfScale.z),
            origin + new Vector3(halfScale.x, -halfScale.y, -halfScale.z),
            origin + new Vector3(halfScale.x, -halfScale.y, halfScale.z),
            origin + new Vector3(halfScale.x, halfScale.y, halfScale.z),
            origin + new Vector3(halfScale.x, halfScale.y, -halfScale.z),
            origin + new Vector3(halfScale.x, halfScale.y, halfScale.z),
            origin + new Vector3(-halfScale.x, halfScale.y, halfScale.z),
            origin + new Vector3(-halfScale.x, halfScale.y, -halfScale.z),
            origin + new Vector3(-halfScale.x, halfScale.y, halfScale.z),
            origin + new Vector3(-halfScale.x, -halfScale.y, halfScale.z)
        };

        lineRenderer.positionCount = boxPoints.Length;
        lineRenderer.SetPositions(boxPoints);
        lineRenderer.loop = false;
    }
}

