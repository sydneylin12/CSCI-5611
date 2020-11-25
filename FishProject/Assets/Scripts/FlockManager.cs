using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockManager : MonoBehaviour
{

    // Prefab for default fish
    public GameObject fishPrefab;

    // Number of fish
    public int n;

    // Array of fish objects
    public GameObject[] fish;

    // Speed limit
    public Vector3 swimLimits = new Vector3(10, 10, 10);

    public Vector3 goal = Vector3.zero;

    [Header("Fish Settings")]
    [Range(0.0f, 5.0f)]
    public float minSpeed;
    [Range(0.0f, 5.0f)]
    public float maxSpeed;

    [Header("Flocking Settings")]
    [Range(1.0f, 10.0f)]
    public float radius;
    [Range(0.0f, 5.0f)]
    public float rotSpeed;



    // Start is called before the first frame update
    void Start()
    {
        // Instantiate the array
        fish = new GameObject[n];
        for(int i = 0; i < n; i++)
        {
            // Generate random position for a fish
            float x = Random.Range(-swimLimits.x, swimLimits.x);
            float y = Random.Range(0, swimLimits.y);
            float z = Random.Range(-swimLimits.z, swimLimits.z);
            Vector3 randomPos = this.transform.position + new Vector3(x, y, z);

            // Construct ramdomly placed fish
            fish[i] = (GameObject) Instantiate(fishPrefab, randomPos, Quaternion.identity);
            fish[i].GetComponent<Flock>().manager = this;
        }

        activateFog();
    }

    // Update is called once per frame
    void Update()
    {
        if(Random.Range(0, 10000) < 50)
        {
            // Generate random position for a fish
            float x = Random.Range(-swimLimits.x, swimLimits.x);
            float y = Random.Range(0, swimLimits.y);
            float z = Random.Range(-swimLimits.z, swimLimits.z);
            goal = this.transform.position + new Vector3(x, y, z);
        }   
    }

    void activateFog()
    {
        RenderSettings.fogColor = Camera.main.backgroundColor;
        RenderSettings.fogDensity = 0.05f;
        RenderSettings.fog = true;
    }

    public float getRandomSpeed()
    {
        return Random.Range(minSpeed, maxSpeed);
    }
}
