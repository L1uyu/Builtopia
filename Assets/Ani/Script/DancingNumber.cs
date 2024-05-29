using System.Collections;
using UnityEngine;
using TMPro;

public class DancingNumber : MonoBehaviour
{
    public TextMeshPro numberText;
    public float updateInterval = 0.5f; // 数字变动的时间间隔

    private int currentNumber = 0;
    

    void Start()
    {
        if (numberText == null)
        {
            Debug.LogError("TextMeshProUGUI component not found!");
        }
        StartUpdateNumber();
    }

    IEnumerator UpdateNumber()
    {
        while (true)
        {
            currentNumber = GetRandomNumber(currentNumber);
            numberText.text = FormatNumber(currentNumber);
            yield return new WaitForSeconds(updateInterval);
        }
    }

    int GetRandomNumber(int current)
    {
        // 实现数字随机变动的逻辑，可以根据需要进行调整
        int change = Random.Range(100000, 6999999);
        return change; 
    }

    string FormatNumber(int number)
    {
        return number.ToString("N0"); // 格式化为带千分位的字符串
    }

    public void StartUpdateNumber()
    {
        StartCoroutine(UpdateNumber());
    }
}

