using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Updater : MonoBehaviour
{
    [SerializeField] CustomRenderTexture _texture;
    [SerializeField, Range(1, 16)] int _stepsPerFrame = 4;
    // Start is called before the first frame update
    void Start()
    {
        _texture.Initialize();
    }

    // Update is called once per frame
    void Update()
    {
        _texture.Update(_stepsPerFrame);
    }
}
