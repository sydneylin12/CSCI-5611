using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class CausticsHelper : MonoBehaviour
{
    private Projector proj;
    public VideoPlayer vid;

    void Start()
    {
        proj = this.gameObject.GetComponent<Projector>();
        proj.material.SetTexture("_MainTex", vid.texture);
        vid.isLooping = true;
        vid.Play();
    }
}
