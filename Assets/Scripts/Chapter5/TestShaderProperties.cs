using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestShaderProperties : MonoBehaviour
{
    private static readonly int s_color = Shader.PropertyToID("_Color");
    private Vector3 _startPosition;
    private float _tickTime;

    // Start is called before the first frame update
    private void Start() {
        var material = GetComponent<MeshRenderer>()?.material;
        if (material is null) return;
        // if (material != null) material.SetColor(s_color, new Color(1.0f, 0f, 0f, 0.1f));
        // Shader.SetGlobalColor("_Color", new Color(1.0f, 1.0f, 1.0f, 1.0f));

        var passName = material.GetPassName(material.FindPass("myPass"));
        Debug.Log(passName);

        _startPosition = transform.position;
        _tickTime = 0;
    }

    // Update is called once per frame
    private void Update() {
        _tickTime += Time.deltaTime;
        if (_tickTime < 3) return;
        _tickTime = 0;
        transform.position = _startPosition + new Vector3(Random.Range(-3, 3), Random.Range(-3, 3), Random.Range(-3, 3));
    }
}
