using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FoodScript : MonoBehaviour
{
    public FlockManager manager;

    void Start()
    {
        // Start tracking food as soon as its spawned
        Debug.Log("Food spawned");
        manager = GameObject.Find("FishManager").GetComponent<FlockManager>();
        manager.foodQueue.Enqueue(gameObject);
    }

    void OnTriggerEnter(Collider other)
    {
        // Food should disappear once something makes contact
        Debug.Log("Food trigger enter");
        if(manager.foodQueue.Count > 0) manager.foodQueue.Dequeue();
        Destroy(this.gameObject);
    }
}
