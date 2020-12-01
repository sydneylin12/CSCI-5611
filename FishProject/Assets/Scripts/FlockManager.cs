using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockManager : MonoBehaviour
{

    // Prefab for default fish
    public GameObject fishPrefab;
    public GameObject goldfishPrefab;

    // Number of fish
    public int n;

    // Array of fish objects
    public GameObject[] fish;

    // ADD ARRAYS HERE FOR MORE FISH
    public GameObject[] goldfish;

    // Speed limit
    public Vector3 swimLimits = new Vector3(36.0f, 28.0f, 18.0f);

    //public Vector3 goal = Vector3.zero;

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

    // Start is called before the first frame update
    void Start()
    {

        // ARBITRARY
        swimLimits.x = 36.0f; // half of aqarium length
        swimLimits.z = 18.0f; // half of aqarium width
        swimLimits.y = 28.0f; // aqarium height

        // Instantiate the array
        fish = new GameObject[n];

        // Random amount of goldfish
        goldfish = new GameObject[n - Random.Range(0, n / 2)];

        for (int i = 0; i < n; i++)
        {
            // Generate random position and goal for a fish
            float x = Random.Range(-swimLimits.x, swimLimits.x);
            float y = Random.Range(2.5f, swimLimits.y/2.0f);
            float z = Random.Range(-swimLimits.z, swimLimits.z);
            Vector3 randomPos = new Vector3(x, y, z) + this.transform.position;

            x = Random.Range(-swimLimits.x, swimLimits.x);
            y = Random.Range(10, swimLimits.y);
            z = Random.Range(-swimLimits.z, swimLimits.z);


            // Construct ramdomly placed fish
            fish[i] = (GameObject)Instantiate(fishPrefab, randomPos, Quaternion.identity);
            fish[i].GetComponent<Flock>().manager = this;
            fish[i].GetComponent<Flock>().goal = new Vector3(x, y, z);
        }
        /*
        for(int i = 0; i < goldfish.Length; i++)
        {
            // Generate random position for a fish
            float x = Random.Range(-swimLimits.x, swimLimits.x);
            float y = Random.Range(0, swimLimits.y);
            float z = Random.Range(-swimLimits.z, swimLimits.z);
            Vector3 randomPos = this.transform.position + new Vector3(x, y, z);

            // Construct ramdomly placed fish
            goldfish[i] = (GameObject)Instantiate(goldfishPrefab, randomPos, Quaternion.identity);
            goldfish[i].GetComponent<Flock>().manager = this;
        } */
        activateFog();
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < n; i++)
        {
            // update goal position every once in awhile
            if (Random.Range(0, 10000) < 50)
            {
                // Generate random position for a fish
                float x = Random.Range(-swimLimits.x, swimLimits.x);
                float y = Random.Range(2.5f, swimLimits.y);
                float z = Random.Range(-swimLimits.z, swimLimits.z);
                fish[i].GetComponent<Flock>().goal = this.transform.position + new Vector3(x, y, z);
            }
        }
    }

    void activateFog()
    {
        RenderSettings.fogColor = Camera.main.backgroundColor;
        RenderSettings.fogDensity = 0.01f;
        RenderSettings.fog = true;
    }

    public float getRandomSpeed()
    {
        return Random.Range(minSpeed, maxSpeed);
    }
}
