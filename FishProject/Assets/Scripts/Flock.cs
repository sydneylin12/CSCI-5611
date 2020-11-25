using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Flock : MonoBehaviour
{
    // The manager for the boids
    public FlockManager manager;

    // Individual boid speed
    float speed;

    // Start is called before the first frame update
    void Start()
    {
        speed = Random.Range(manager.minSpeed, manager.maxSpeed);
    }

    // Update is called once per frame
    void Update()
    {
        // Clamp to max speed to avoid bugs lol
        if (speed > 2.0) speed = 2.0f;

        // Translate on the z-axis
        transform.Translate(0, 0, Time.deltaTime * speed);
        ApplyForces();
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

        foreach (GameObject go in fish)
        {
            dist = Vector3.Distance(go.transform.position, this.transform.position);

            // Cannot call on itself
            if (go != this.gameObject && dist <= manager.radius) // Close enough to flock
            {
                // Cohesion
                center += go.transform.position;
                size++;

                // Separation
                if(dist < 1.0f) // Cant be too close together
                {
                    avoid = avoid + (this.transform.position - go.transform.position);
                }

                Flock other = go.GetComponent<Flock>();
                avgSpeed += other.speed;
            }
        }

        if(size > 0) // We have a legit flock
        {
            // Average the stuff out
            center = center / size;
            speed = avgSpeed / size;

            // Alignment
            Vector3 dir = (center + avoid) - transform.position;
            if(dir != Vector3.zero)
            {
                transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), manager.rotSpeed * Time.deltaTime);
            }
        }
    }
}
