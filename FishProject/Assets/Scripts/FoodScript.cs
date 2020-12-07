using UnityEngine;

public class FoodScript : MonoBehaviour
{
    /// <summary>
    /// The manager.
    /// </summary>
    private FlockManager manager;
    private AudioSource audioSource;
    private MeshRenderer ren;
    private CapsuleCollider collider;
    public AudioClip plop;
    public AudioClip chomp;

    /// <summary>
    /// Called on creation of food prefab.
    /// </summary>
    void Start()
    {
        // Start tracking food as soon as its spawned
        manager = GameObject.Find("FishManager").GetComponent<FlockManager>();
        audioSource = gameObject.GetComponentInChildren<AudioSource>();
        ren = gameObject.GetComponent<MeshRenderer>();
        collider = gameObject.GetComponent<CapsuleCollider>();
        manager.foodQueue.Enqueue(gameObject);
        manager.foodList.Add(gameObject);
        audioSource.clip = plop;
        audioSource.Play();
    }

    /// <summary>
    /// Called when the food collides with a trigger
    /// </summary>
    /// <param name="other">The other collider</param>
    void OnTriggerEnter(Collider other)
    {
        Debug.Log("Food collided with: " + other.name);
        if(other.name.Contains("FISH"))
        {
            audioSource.clip = chomp;
            audioSource.Play();
        }

        // Food should disappear once something makes contact - also prevent empty queue exceptions
        if (manager.foodList.Count > 0)
        {
            manager.foodList.Remove(this.gameObject);
        }

        // Disable these before destroying to prevent double collisions
        ren.enabled = false;
        collider.enabled = false;
        Invoke("DeleteThis", 0.5f);
    }

    /// <summary>
    /// Must be invoked a little after to play sound correctly.
    /// </summary>
    void DeleteThis()
    {
        Destroy(gameObject);
    }
}
