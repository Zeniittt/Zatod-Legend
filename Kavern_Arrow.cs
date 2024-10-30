using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kavern_Arrow : Entity
{
    [SerializeField] private string targetLayerName = "Hero";
    public float speed;
    [SerializeField] private bool canMove;

    private CharacterStats myStats;
    public int direction;


}
