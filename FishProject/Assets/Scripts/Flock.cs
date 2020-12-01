using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Flock : MonoBehaviour
{
    // The manager for the boids
    public FlockManager manager;

    // Individual boid speed
    public float speed = 0.0f;
    public bool turning = false; // TODO

    // Turn mechanics
    public Vector3 newGoalPos;

    // goal position of fish
    public Vector3 goal;

    // current number of collisions
    int numCol = 0;

    // Start is called before the first frame update
    void Start()
    {
        speed = manager.getRandomSpeed();
    }

    // Update is called once per frame
    void Update()
    {
        // Clamp to max speed to avoid bugs lol
        if (speed > 2.0) speed = manager.maxSpeed;

        if (turning)
        {
            Vector3 dir = newGoalPos - transform.position;
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), manager.rotSpeed * Time.deltaTime);
            this.speed = manager.getRandomSpeed();
        }
        else
        {
            // Do not apply forces every time
            //if (Random.Range(0, 10) < 1) 
            ApplyForces();
        }

        // Translate on the z-axis (swim forward) NO MATTER WHAT
        transform.Translate(0, 0, Time.deltaTime * speed);
    }

    // Collide with walls
    void OnTriggerEnter(Collider other)
    {
        numCol++;
        //Debug.Log("Entered object");
        if (!turning)
        {
            float x = Random.Range(-manager.swimLimits.x, manager.swimLimits.x);
            float y = Random.Range(2.5f, manager.swimLimits.y);
            float z = Random.Range(-manager.swimLimits.z, manager.swimLimits.z);
            newGoalPos = new Vector3(x, y, z);
            goal = newGoalPos;
            //newGoalPos = this.transform.position - other.gameObject.transform.position;
            //goal = newGoalPos;
        }
        turning = true;
        
    }

    // Disable turning when collision is done
    void OnTriggerExit(Collider other)
    {
        //Debug.Log("left object");
        numCol--;
        if (numCol == 0)
        {
            //Debug.Log("left all objects");
            turning = false;
        }
    }

    /// <summary>
    /// Applies 3 boid forces: coheshion, separation, alignment
    /// </summary>
    void ApplyForces()
    {
        GameObject[] fish = manager.fish;
        Vector3 center = Vector3.zero;
        Vector3 avoid = Vector3.zero;
        float avgSpeed = 0.01f;
        float dist;
        int size = 0;

        // Area where fish should flock to
        Vector3 goalPos = goal;

        foreach (GameObject go in fish)
        {
            dist = Vector3.Distance(go.transform.position, this.transform.position);

            // Cannot call on itself
            if (go != this.gameObject && dist <= manager.neighborhood_radius) // Close enough to flock
            {
                // Cohesion
                center += go.transform.position;
                size++;

                Flock other = go.GetComponent<Flock>();
                avgSpeed += other.speed;
            }
            if (go != this.gameObject && dist <= manager.neighborhood_radius) // Close enough to flock to start avoiding
            {
                // Separation
                if (dist < 1.0f) // Cant be too close together
                {
                    avoid = avoid + (this.transform.position - go.transform.position);
                }
            }
        }

        if (size > 0) // We have a legit flock (avoid div. by zero)
        {
            // Average the stuff out
            center = center / size + (goalPos - this.transform.position); // Account for manager goal position
            speed = avgSpeed / size;

            // Alignment
            Vector3 dir = (center + avoid) - transform.position;
            if (dir != Vector3.zero)
            {
                transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), manager.rotSpeed * Time.deltaTime);
            }
        }
    }
}
