using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace WDJ {

public enum MyEnum {
    E1 = 1,
    E3 = 3,
    
}

}
public class TestTilling : MonoBehaviour
{
    // Start is called before the first frame update

    private MeshRenderer _renderer;
    
    void Start() {
        _renderer = GetComponent<MeshRenderer>();
        if (_renderer != null)
            _renderer.material.SetTextureScale("_MainTex", new Vector2(0.5f, 1));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
