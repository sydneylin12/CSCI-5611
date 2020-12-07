using UnityEngine;

public class FoodScript : MonoBehaviour
{
    /// <summary>
    /// The manager.
    /// </summary>
    public FlockManager manager;

    /// <summary>
    /// Called on creation of food prefab.
    /// </summary>
    void Start()
    {
        // Start tracking food as soon as its spawned
        manager = GameObject.Find("FishManager").GetComponent<FlockManager>();
        manager.foodQueue.Enqueue(gameObject);
    }

    /// <summary>
    /// Called when the food collides with a trigger
    /// </summary>
    /// <param name="other">The other collider</param>
    void OnTriggerEnter(Collider other)
    {
        // Food should disappear once something makes contact - also prevent empty queue exceptions
        if(manager.foodQueue.Count > 0) manager.foodQueue.Dequeue();
        Destroy(this.gameObject);
    }
}
