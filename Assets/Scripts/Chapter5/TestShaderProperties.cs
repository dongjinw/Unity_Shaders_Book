using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestShaderProperties : MonoBehaviour
{
    private static readonly int s_color = Shader.PropertyToID("_Color");

    // Start is called before the first frame update
    private void Start() {
        var material = GetComponent<MeshRenderer>()?.material;
        if (material != null) material.SetColor(s_color, new Color(1.0f, 0f, 0f, 0.1f));
        // Shader.SetGlobalColor("_Color", new Color(1.0f, 1.0f, 1.0f, 1.0f));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
