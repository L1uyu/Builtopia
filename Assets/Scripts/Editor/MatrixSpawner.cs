using UnityEngine;
using UnityEditor;

public class MatrixSpawner : EditorWindow
{
    public GameObject prefab;
    public int rows = 1;
    public int columns = 1;
    public Vector3 origin = new Vector3(0, 0, 0);
    public float horizontalGap = 0.0f;
    public float verticalGap = 0.0f;

    [MenuItem("Tools/Spawn Matrix")]
    private static void OpenWindow()
    {
        MatrixSpawner window = (MatrixSpawner)GetWindow(typeof(MatrixSpawner), true, "Matrix Spawner");
        window.Show();
    }

    void OnGUI()
    {
        GUILayout.Label("Spawn Matrix Configuration", EditorStyles.boldLabel);
        prefab = (GameObject)EditorGUILayout.ObjectField("Prefab", prefab, typeof(GameObject), false);
        rows = EditorGUILayout.IntField("Rows", rows);
        columns = EditorGUILayout.IntField("Columns", columns);
        origin = EditorGUILayout.Vector3Field("Origin", origin);
        horizontalGap = EditorGUILayout.FloatField("Horizontal Gap", horizontalGap);
        verticalGap = EditorGUILayout.FloatField("Vertical Gap", verticalGap);

        if (GUILayout.Button("Spawn"))
        {
            if (prefab == null)
            {
                EditorUtility.DisplayDialog("Error", "Please assign a prefab.", "OK");
                return;
            }

            BoxCollider collider = prefab.GetComponent<BoxCollider>();
            Vector3 size = collider ? collider.size : Vector3.zero;

            Undo.SetCurrentGroupName("Matrix Spawner");
            int group = Undo.GetCurrentGroup();

            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < columns; j++)
                {
                    Vector3 position = origin + new Vector3(j * (horizontalGap + size.x), 0, i * (verticalGap + size.z));
                    GameObject go = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
                    go.transform.position = position;
                    Undo.RegisterCreatedObjectUndo(go, "Create object");
                }
            }

            Undo.CollapseUndoOperations(group);

        }
    }
}
