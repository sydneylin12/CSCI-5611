using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockManager : MonoBehaviour
{

    [Header("Prefabs")]
    public GameObject fishPrefab;
    public GameObject fish2Prefab;
    public GameObject goldfishPrefab;
    public GameObject foodPrefab;
    private GameObject[] fishPrefabs;

    // Number of fish
    public int n;

    // Array of fish objects
    public GameObject[] fish;

    // Limit on size of tank
    public Vector3 swimLimits = new Vector3(34.0f, 26.0f, 16.0f);

    // Holds food gameobjects in the queue
    public Queue<GameObject> foodQueue;

    [Header("Fish Settings")]
    [Range(0.0f, 3.0f)]
    public float minSpeed;
    [Range(3.0f, 5.0f)]
    public float maxSpeed;

    [Header("Flocking Settings")]
    [Range(1.0f, 10.0f)]
    public float neighborhood_radius;
    [Range(1.0f, 10.0f)]
    public float avoidment_radius;
    [Range(0.0f, 50.0f)]
    public float rotSpeed;

    /// <summary>
    /// Called when the game starts (before update).
    /// </summary>
    void Start()
    {
        // ARBITRARY
        swimLimits.x = 36.0f; // half of aqarium length
        swimLimits.z = 18.0f; // half of aqarium width
        swimLimits.y = 28.0f; // aqarium height

        // Instantiate the array by HARD CODE!
        fish = new GameObject[n];
        fishPrefabs = new GameObject[3];
        fishPrefabs[0] = fishPrefab;
        fishPrefabs[1] = fish2Prefab;
        fishPrefabs[2] = goldfishPrefab;

        // Queue of food items
        foodQueue = new Queue<GameObject>();

        // Initialize random fish
        for (int i = 0; i < n; i++)
        {
            // Generate random position and goal for a fish
            Vector3 randomPos = getNewGoal() + this.transform.position;

            // Generate random fish and set components
            fish[i] = (GameObject)Instantiate(fishPrefabs[Random.Range(0, 3)], randomPos, Quaternion.identity);
            fish[i].GetComponent<Flock>().manager = this;
            fish[i].GetComponent<Flock>().goal = getNewGoal();
            fish[i].name = "FISH " + i;
        }
        activateFog();
    }

    /// <summary>
    /// Called once per frame.
    /// </summary>
    void Update()
    {
        // Spawn food randomly on mouse click
        // Also prevent too much food from being spawned
        if (Input.GetMouseButtonDown(0) && foodQueue.Count < 5)
        {
            // Spawn a food here
            int randX = Random.Range(-35, 35);
            int randZ = Random.Range(0, 10);
            Instantiate(foodPrefab, new Vector3(randX, 27, randZ), Quaternion.identity);
        }

        // Update goal position every once in awhile
        for (int i = 0; i < n; i++)
        {
            if (Random.Range(0, 100) < 5)
            {
                // Generate random position for a fish
                fish[i].GetComponent<Flock>().goal = getNewGoal();
            }
        }
    }

    /// <summary>
    /// Turn on fog effects.
    /// </summary>
    void activateFog()
    {
        RenderSettings.fogColor = Camera.main.backgroundColor;
        RenderSettings.fogDensity = 0.015f;
        RenderSettings.fog = true;
    }

    /// <summary>
    /// Returns a new position in the tank as a Vector3.
    /// </summary>
    /// <returns>A new goal Vector3.</returns>
    public Vector3 getNewGoal()
    {
        // generates a new goal position for the fish
        float x = Random.Range(-swimLimits.x, swimLimits.x);
        float y = Random.Range(2.5f, swimLimits.y);
        float z = Random.Range(-swimLimits.z, swimLimits.z);
        Vector3 newPos = new Vector3(x, y, z);
        float tolerance = 3;
        
        while (Physics.CheckSphere(newPos, tolerance)) // make sure new goal does not collide with any object
        {
            x = Random.Range(-swimLimits.x, swimLimits.x);
            y = Random.Range(2.5f, swimLimits.y);
            z = Random.Range(-swimLimits.z, swimLimits.z);
            newPos = new Vector3(x, y, z);
        }
        return newPos;
    }

    /// <summary>
    /// Returns a random speed in the range (min, max).
    /// </summary>
    /// <returns></returns>
    public float getRandomSpeed()
    {
        return Random.Range(minSpeed, maxSpeed);
    }
}
