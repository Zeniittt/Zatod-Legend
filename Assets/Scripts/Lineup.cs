using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lineup : MonoBehaviour
{
    public List<GameObject> lineup;


    void Start()
    {
        lineup = new List<GameObject>();

        StartMatch();
    }

    void Update()
    {
        CheckAlive();
    }

    private void StartMatch()
    {
        foreach (Transform character in transform)
        {
            lineup.Add(character.gameObject);
        }
    }

    private void CheckAlive()
    {
        lineup.RemoveAll(character => character == null);
    }
}
