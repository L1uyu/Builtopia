using UnityEngine;
using UnityEngine.Rendering;

public class CubemapCapture : MonoBehaviour
{
    public int resolution = 256;
    public LayerMask cullingMask = -1;
    public Camera.MonoOrStereoscopicEye monoOrStereoscopicEye = Camera.MonoOrStereoscopicEye.Mono;
    public int gapFrames = 0; // Number of frames to wait between face captures
    public float captureInterval = 1f; // Time in seconds between full cubemap captures
    public bool captureOnStart = true;

    [HideInInspector]
    public RenderTexture activeCubemap; // The currently active (complete) cubemap

    private Camera captureCamera;
    private RenderTexture[] cubemapBuffers = new RenderTexture[2];
    private int currentBufferIndex = 0;
    private int currentFace = 0;
    private int frameCounter = 0;
    private bool isCapturing = false;
    private float lastCaptureTime;


    void Start()
    {
        SetupCamera();
        SetupCubemaps();
        if (captureOnStart)
        {
            StartCapture();
        }
    }

    void SetupCamera()
    {
        GameObject cameraObject = new GameObject("CubemapCamera");
        cameraObject.transform.SetParent(transform);
        captureCamera = cameraObject.AddComponent<Camera>();
        captureCamera.enabled = false;
        captureCamera.cullingMask = cullingMask;
        captureCamera.nearClipPlane = 0.01f;
        captureCamera.farClipPlane = 1000f;
    }

    void SetupCubemaps()
    {
        for (int i = 0; i < 2; i++)
        {
            cubemapBuffers[i] = new RenderTexture(resolution, resolution, 24);
            cubemapBuffers[i].dimension = TextureDimension.Cube;
        }
        activeCubemap = cubemapBuffers[0];
    }

    void Update()
    {
        if (isCapturing)
        {
            ContinueCapture();
        }
        else if (Time.time - lastCaptureTime >= captureInterval)
        {
            StartCapture();
        }
    }

    public void StartCapture()
    {
        isCapturing = true;
        currentFace = 0;
        frameCounter = 0;
        currentBufferIndex = 1 - currentBufferIndex; // Swap buffer
        CaptureNextFace();
    }

    void ContinueCapture()
    {
        if (frameCounter < gapFrames)
        {
            frameCounter++;
        }
        else
        {
            CaptureNextFace();
        }
    }

    void CaptureNextFace()
    {
        if (currentFace < 6)
        {
            CaptureFace((CubemapFace)currentFace);
            currentFace++;
            frameCounter = 0;
        }
        else
        {
            CompleteCaptureProcess();
        }
    }

    void CaptureFace(CubemapFace face)
    {
        captureCamera.transform.position = transform.position;
        captureCamera.transform.rotation = GetRotationForFace(face);
        captureCamera.RenderToCubemap(cubemapBuffers[currentBufferIndex], (int)face, monoOrStereoscopicEye);
    }

    void CompleteCaptureProcess()
    {
        isCapturing = false;
        lastCaptureTime = Time.time;
        activeCubemap = cubemapBuffers[currentBufferIndex];
        Debug.Log("Cubemap capture complete. Active cubemap updated.");
    }

    Quaternion GetRotationForFace(CubemapFace face)
    {
        switch (face)
        {
            case CubemapFace.PositiveX: return Quaternion.LookRotation(Vector3.right, Vector3.up);
            case CubemapFace.NegativeX: return Quaternion.LookRotation(Vector3.left, Vector3.up);
            case CubemapFace.PositiveY: return Quaternion.LookRotation(Vector3.up, Vector3.forward);
            case CubemapFace.NegativeY: return Quaternion.LookRotation(Vector3.down, Vector3.back);
            case CubemapFace.PositiveZ: return Quaternion.LookRotation(Vector3.forward, Vector3.up);
            case CubemapFace.NegativeZ: return Quaternion.LookRotation(Vector3.back, Vector3.up);
            default: return Quaternion.identity;
        }
    }


    void OnDestroy()
    {
        foreach (var rt in cubemapBuffers)
        {
            if (rt != null)
            {
                rt.Release();
            }
        }
    }
}