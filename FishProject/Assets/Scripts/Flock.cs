using UnityEngine;

public class Flock : MonoBehaviour
{
    // The manager for the boids
    public FlockManager manager;

    // Individual boid speed
    public float speed = 0.0f;
    public bool turning = false; // TODO

    // Fish goal position in the tank
    public Vector3 newGoalPos;

    // Goal position of fish
    public Vector3 goal;

    // Number of collisions
    int numCol = 0;

    // Is the fish tracking food?
    bool tracking;

    /// <summary>
    /// Called before the first update.
    /// </summary>
    void Start()
    {
        speed = manager.getRandomSpeed();
        goal = manager.getNewGoal();
    }

    /// <summary>
    /// Called once pre frame.
    /// </summary>
    void Update()
    {
        // If there is no more food
        if (manager.foodQueue.Count == 0) tracking = false;
        else tracking = true;

        // Clamp to max speed to avoid bugs lol
        if (speed > manager.maxSpeed) speed = manager.maxSpeed;

        // ALWAYS check goal to prevent spinning
        /*
         * I think the problem was that the fish was circling around the goal position but couldn't reach it
         * So the answer was to check every time to see if the goal had been reached?
         * Also changed the checking radius to be more forgiving
         */
        checkGoal();

        // Tracking behavior takes priority over everything
        if (tracking)
        {
            TrackFood();
        }
        // The spinning bug is happening when turning = true
        else if (turning)
        {
            Vector3 dir = newGoalPos - transform.position;
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), manager.rotSpeed * Time.deltaTime);
        }
        else
        {
            // Do not apply forces every time - kind of fixes the spinning fish bug
            // Track 100% of the time
            if (Random.Range(0, 10) < 1)
            {
                ApplyForces();
            }
        }
        // Move fish after all conditions
        transform.Translate(0, 0, Time.deltaTime * speed);
    }

    /// <summary>
    /// Handle fish collisions with other colliders.
    /// </summary>
    /// <param name="other">Any other collider.</param>
    void OnTriggerEnter(Collider other)
    {
        Collider col = this.gameObject.GetComponent<Collider>();
        if (col == other) return;

        numCol++;
        if (!turning) // Prevent robotic turning
        {
            newGoalPos = manager.getNewGoal();
            goal = newGoalPos;
        }
        turning = true;
        
    }

    /// <summary>
    /// Disable turning when all collisions are gone.
    /// </summary>
    /// <param name="other">The other collider.</param>
    void OnTriggerExit(Collider other)
    {
        numCol--;
        if (numCol == 0)
        {
            turning = false;
        }
    }

    /// <summary>
    /// Check if the goal has been reached.
    /// </summary>
    void checkGoal()
    {
        // check if the fish is at the goal. If so, generate a new goal
        if (Vector3.Distance(goal, this.gameObject.transform.position) < 5)
        {
            goal = manager.getNewGoal();
        }
        if(Vector3.Distance(newGoalPos, this.gameObject.transform.position) < 5)
        {
            newGoalPos = manager.getNewGoal();
        }
    }

    /// <summary>
    /// Tracking food overrides default behavior.
    /// </summary>
    void TrackFood()
    {
        if (tracking)
        {
            Vector3 toFood = manager.foodQueue.Peek().transform.position;
            Vector3 dir = toFood - gameObject.transform.position;
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), manager.rotSpeed * Time.deltaTime);
            return;
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

        //float distanceToCenter = Vector3.Distance(this.gameObject.transform.position, center);
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
