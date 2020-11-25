using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockManager : MonoBehaviour
{

    public GameObject fishPrefab;
    public int n;
    public GameObject[] fish;
    public Vector3 swimLimits = new Vector3(5, 5, 5);

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
        fish = new GameObject[n];
        for(int i = 0; i < n; i++)
        {
            Debug.Log("Generating fish: " + i);
            float x = Random.Range(-swimLimits.x, swimLimits.x);
            float y = Random.Range(0, swimLimits.y);
            float z = Random.Range(-swimLimits.z, swimLimits.z);
            Vector3 randomPos = this.transform.position + new Vector3(x, y, z);

            // Construct ramdomly placed fish
            fish[i] = (GameObject) Instantiate(fishPrefab, randomPos, Quaternion.identity);
            fish[i].GetComponent<Flock>().manager = this;
        }   
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
