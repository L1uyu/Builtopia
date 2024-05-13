using UnityEngine;
using UnityEditor;
using System.IO;

public class CreateShaderFromTemplate
{
    [MenuItem("Assets/Create/Shader/URP Unlit Shader", false, 81)]
    public static void CreateCustomShader()
    {
        string path = AssetDatabase.GetAssetPath(Selection.activeObject);
        if (string.IsNullOrEmpty(path))
        {
            path = "Assets";
        }
        else if (Path.GetExtension(path) != "")
        {
            path = path.Replace(Path.GetFileName(AssetDatabase.GetAssetPath(Selection.activeObject)), "");
        }

        string shaderName = "NewTemplateUnlitShader";
        shaderName = EditorUtility.SaveFilePanelInProject("Save New Shader", "NewTemplateUnlitShader", "shader", "Please enter a file name for the new shader", path);
        if (string.IsNullOrEmpty(shaderName))
            return; // User cancelled the operation
        //string fullPath = AssetDatabase.GenerateUniqueAssetPath(path + "/" + shaderName + ".shader");
        
        CreateShader(shaderName);
        AssetDatabase.Refresh();
        Object obj = AssetDatabase.LoadAssetAtPath<Object>(shaderName);
        //ProjectWindowUtil.ShowCreatedAsset(obj);
        Selection.activeObject = obj;


    }

    private static void CreateShader(string fullPath)
    {
        string templatePath = "Assets/Shaders/URPUnlitShader.shader"; // Adjust the path as necessary
        string fileContent = File.ReadAllText(templatePath);

        // Replace shader name in the file content
        string shaderName = Path.GetFileNameWithoutExtension(fullPath);
        fileContent = fileContent.Replace("Hidden/URPUnlitShader", $"Custom URP/{shaderName}");

        File.WriteAllText(fullPath, fileContent);
        AssetDatabase.ImportAsset(fullPath);
    }
}
