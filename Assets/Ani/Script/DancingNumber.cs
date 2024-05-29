using System.Collections;
using UnityEngine;
using TMPro;

public class DancingNumber : MonoBehaviour
{
    public TextMeshPro numberText;
    public float updateInterval = 0.5f; // ���ֱ䶯��ʱ����

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
        // ʵ����������䶯���߼������Ը�����Ҫ���е���
        int change = Random.Range(100000, 6999999);
        return change; 
    }

    string FormatNumber(int number)
    {
        return number.ToString("N0"); // ��ʽ��Ϊ��ǧ��λ���ַ���
    }

    public void StartUpdateNumber()
    {
        StartCoroutine(UpdateNumber());
    }
}

