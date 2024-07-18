using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshInterpolator : MonoBehaviour
{
    public MeshFilter meshFilterA;
    public MeshFilter meshFilterB;
    public float interpolationDuration = 2f;

    private Mesh meshA;
    private Mesh meshB;
    private Mesh interpolatedMesh;
    private Vector3[] verticesA;
    private Vector3[] verticesB;
    private Vector3[] interpolatedVertices;
    private float elapsedTime = 0f;
    private bool isInterpolating = false;
    private int[] triangles;

    void Start()
    {
        meshA = meshFilterA.mesh;
        meshB = meshFilterB.mesh;

        // Generate vertex mapping
        verticesA = meshA.vertices;
        verticesB = meshB.vertices;
        interpolatedVertices = new Vector3[verticesA.Length];
        interpolatedMesh = new Mesh();
        meshFilterA.mesh = interpolatedMesh;
        triangles = meshA.triangles;

        StartInterpolation();
    }

    void StartInterpolation()
    {
        elapsedTime = 0f;
        isInterpolating = true;
    }

    void Update()
    {
        if (isInterpolating)
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / interpolationDuration;

            for (int i = 0; i < interpolatedVertices.Length; i++)
            {
                Vector3 nearestVertexB = FindNearestVertex(verticesA[i], verticesB);
                interpolatedVertices[i] = Vector3.Lerp(verticesA[i], nearestVertexB, t);
            }

            interpolatedMesh.vertices = interpolatedVertices;
            interpolatedMesh.triangles = triangles;
            interpolatedMesh.RecalculateNormals();

            if (t >= 1f)
            {
                isInterpolating = false;
            }
        }
    }

    Vector3 FindNearestVertex(Vector3 vertex, Vector3[] vertices)
    {
        Vector3 nearestVertex = vertices[0];
        float minDistance = Vector3.Distance(vertex, nearestVertex);

        foreach (var v in vertices)
        {
            float distance = Vector3.Distance(vertex, v);
            if (distance < minDistance)
            {
                minDistance = distance;
                nearestVertex = v;
            }
        }

        return nearestVertex;
    }
}
