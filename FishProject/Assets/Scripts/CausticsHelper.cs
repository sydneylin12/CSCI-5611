using UnityEngine;
using UnityEngine.Video;

public class CausticsHelper : MonoBehaviour
{
    private Projector proj;
    public VideoPlayer vid;

    /// <summary>
    /// Attempt at doing a caustics effect.
    /// Did not get this working sadly.
    /// </summary>
    void Start()
    {
        proj = this.gameObject.GetComponent<Projector>();
        proj.material.SetTexture("_MainTex", vid.texture);
        vid.isLooping = true;
        vid.Play();
    }
}
