# V4 replay regression

`evo-manual.json.gz` was generated using the C# runtime from Git commit `871fa5b2c`, before D34 edits. It uses a synthetic match, starts with full energy and includes one real manual ultimate input at tick 1. Its synthetic level 60 evolution adds 75 damage to a 15 damage attack against an 80 HP target. The expected result is team 0 winning at tick 2 with digest `49990036945569340`. Disabling V4 Evo therefore changes the outcome.
