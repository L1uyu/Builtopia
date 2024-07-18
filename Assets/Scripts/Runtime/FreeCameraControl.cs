using UnityEngine;

public class FreeCameraControl : MonoBehaviour
{
    public float moveSpeed = 10.0f;
    public float lookSpeed = 3.0f;
    public float sprintMultiplier = 2.0f;

    private float yaw = 0.0f;
    private float pitch = 0.0f;

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update()
    {
        // Mouse look
        if (Input.GetMouseButton(0) || Input.GetMouseButton(1))
        {
            yaw += lookSpeed * Input.GetAxis("Mouse X");
            pitch -= lookSpeed * Input.GetAxis("Mouse Y");
            pitch = Mathf.Clamp(pitch, -90f, 90f); // Clamp the pitch to prevent flipping

            transform.eulerAngles = new Vector3(pitch, yaw, 0.0f);
        }

        // Movement
        float speed = moveSpeed;
        if (Input.GetKey(KeyCode.LeftShift))
        {
            speed *= sprintMultiplier;
        }

        float moveForward = Input.GetAxis("Vertical") * speed * Time.deltaTime;
        float moveRight = Input.GetAxis("Horizontal") * speed * Time.deltaTime;
        float moveUp = 0;

        if (Input.GetKey(KeyCode.E))
        {
            moveUp = speed * Time.deltaTime;
        }
        else if (Input.GetKey(KeyCode.Q))
        {
            moveUp = -speed * Time.deltaTime;
        }

        transform.Translate(new Vector3(moveRight, moveUp, moveForward));
    }
}
