import pytest
from ..gen_pc import pc_roller

"""
Tests the roll4drop method which rolls 4d6 and the sums the dice totals ignoring the lowest result
"""


def test_roll4drop():
    result = pc_roller.roll4drop(True, 10)
    assert result == 13, f"Expected 13 but was {result}"
    result = pc_roller.roll4drop(True, 11)
    assert result == 13, f"Expected 13 but was {result}"
    result = pc_roller.roll4drop(True, 12)
    assert result == 15, f"Expected 15 but was {result}"


"""
Tests the gen_array funciton which generates a stat array for a character.
"""


def test_gen_array():
    result = pc_roller.gen_array(True, 10)
    assert result == [
        13,
        13,
        15,
        15,
        17,
        13,
    ], f"Expected [13, 13, 15, 15, 17, 13] but was {result}"
    result = pc_roller.gen_array(True, 20)
    assert result == [
        15,
        14,
        9,
        9,
        15,
        9,
    ], f"Expected [15, 14, 9, 9, 15, 9] but was {result}"


"""
Tests the stat_mod function which generates a modifier for a given stat total.
"""


def test_stat_mod():
    result = pc_roller.stat_mod(1)
    assert result == -5, f"Expected -5 but was {result}"
    result = pc_roller.stat_mod(2)
    assert result == -4, f"Expected -4 but was {result}"
    result = pc_roller.stat_mod(3)
    assert result == -4, f"Expected -4 but was {result}"
    result = pc_roller.stat_mod(4)
    assert result == -3, f"Expected -3 but was {result}"
    result = pc_roller.stat_mod(5)
    assert result == -3, f"Expected -3 but was {result}"
    result = pc_roller.stat_mod(6)
    assert result == -2, f"Expected -2 but was {result}"
    result = pc_roller.stat_mod(7)
    assert result == -2, f"Expected -2 but was {result}"
    result = pc_roller.stat_mod(8)
    assert result == -1, f"Expected -1 but was {result}"
    result = pc_roller.stat_mod(9)
    assert result == -1, f"Expected -1 but was {result}"
    result = pc_roller.stat_mod(10)
    assert result == 0, f"Expected 0 but was {result}"
    result = pc_roller.stat_mod(11)
    assert result == 0, f"Expected 0 but was {result}"
    result = pc_roller.stat_mod(12)
    assert result == 1, f"Expected 1 but was {result}"
    result = pc_roller.stat_mod(13)
    assert result == 1, f"Expected 1 but was {result}"
    result = pc_roller.stat_mod(14)
    assert result == 2, f"Expected 2 but was {result}"
    result = pc_roller.stat_mod(15)
    assert result == 2, f"Expected 2 but was {result}"
    result = pc_roller.stat_mod(16)
    assert result == 3, f"Expected 3 but was {result}"
    result = pc_roller.stat_mod(17)
    assert result == 3, f"Expected 3 but was {result}"
    result = pc_roller.stat_mod(18)
    assert result == 4, f"Expected 4 but was {result}"

    # The following are not possible to generate but could be used by very high level characters
    result = pc_roller.stat_mod(19)
    assert result == 4, f"Expected 4 but was {result}"
    result = pc_roller.stat_mod(20)
    assert result == 5, f"Expected 5 but was {result}"
    result = pc_roller.stat_mod(21)
    assert result == 5, f"Expected 5 but was {result}"
    result = pc_roller.stat_mod(22)
    assert result == 6, f"Expected 6 but was {result}"
    result = pc_roller.stat_mod(23)
    assert result == 6, f"Expected 6 but was {result}"
    result = pc_roller.stat_mod(24)
    assert result == 7, f"Expected 7 but was {result}"
    result = pc_roller.stat_mod(25)
    assert result == 7, f"Expected 7 but was {result}"
    result = pc_roller.stat_mod(26)
    assert result == 8, f"Expected 8 but was {result}"
    result = pc_roller.stat_mod(27)
    assert result == 8, f"Expected 8 but was {result}"
    result = pc_roller.stat_mod(28)
    assert result == 9, f"Expected 9 but was {result}"
    result = pc_roller.stat_mod(29)
    assert result == 9, f"Expected 9 but was {result}"
    result = pc_roller.stat_mod(30)
    assert result == 10, f"Expected 10 but was {result}"


"""
Tests the mod_sum function which takes an array and checks the total modifier for the array.
"""


def test_mod_sum():
    arr = [13, 13, 15, 15, 17, 13]
    result = pc_roller.mod_sum(arr)
    assert result == 10, f"Expected 10 but was {result}"
    arr = [11, 6, 14, 8, 7, 8]
    result = pc_roller.mod_sum(arr)
    assert result == -4, f"Expected 3 but was {result}"


"""
Tests the get_opt function to check that the simple function is working
"""


def test_get_opt():
    # STR as highest attribute
    result = pc_roller.get_opt(0)
    expected = ["barbarian", "fighter", "paladin", "ranger"]
    assert result == expected, f" Expected {expected} but was {result}"
    # DEX as highest attribute
    result = pc_roller.get_opt(1)
    expected = ["fighter", "monk", "ranger", "rogue"]
    assert result == expected, f" Expected {expected} but was {result}"
    # CON as highest attribute
    result = pc_roller.get_opt(2)
    expected = [
        "artificer",
        "barbarian",
        "bard",
        "cleric",
        "druid",
        "fighter",
        "monk",
        "paladin",
        "ranger",
        "rogue",
        "sorcerer",
        "warlock",
        "wizard",
    ]
    assert result == expected, f" Expected {expected} but was {result}"
    # INT as highest attribute
    result = pc_roller.get_opt(3)
    expected = ["artificer", "wizard"]
    assert result == expected, f" Expected {expected} but was {result}"
    # WIS as highest attribute
    result = pc_roller.get_opt(4)
    expected = ["cleric", "druid", "monk", "ranger"]
    assert result == expected, f" Expected {expected} but was {result}"
    # CHA as highest attribute
    result = pc_roller.get_opt(5)
    expected = ["bard", "paladin", "sorcerer", "warlock"]
    assert result == expected, f" Expected {expected} but was {result}"


"""
Tests the class recs function to ensure it is returning the expected recommendations.
This only accounts for the two highest stats and ignores the possibility of using a third.
"""


def test_class_recs():
    # All accounted for STR combos
    # STR array
    arr = [18, 17, 16, 15, 14, 13]
    result = pc_roller.class_recs(arr)
    expected = ["barbarian", "fighter", "paladin", "ranger"]
    assert result == expected, f"Expected {expected} but was {result}"
    # STR and DEX array
    arr = [18, 18, 16, 15, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["fighter", "ranger"]
    assert result == expected, f"Expected {expected} but was {result}"
    # STR and CON array
    arr = [18, 17, 18, 15, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["barbarian", "fighter", "paladin", "ranger"]
    assert result == expected, f"Expected {expected} but was {result}"
    # STR and INT
    arr = [18, 17, 16, 18, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["artificer", "barbarian", "fighter", "paladin", "ranger", "wizard"]
    assert result == expected, f"Expected {expected} but was {result}"
    # STR and WIS
    arr = [18, 17, 16, 15, 18, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["ranger"]
    assert result == expected, f"Expected {expected} but was {result}"
    # STR and CHA
    arr = [18, 17, 16, 15, 14, 18]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["paladin"]
    assert result == expected, f"Expected {expected} but was {result}"

    # All accounted for DEX combos
    # DEX array
    arr = [17, 18, 16, 15, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["fighter", "monk", "ranger", "rogue"]
    assert result == expected, f"Expected {expected} but was {result}"
    # DEX and STR done above
    # DEX and CON array
    arr = [17, 18, 18, 15, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["fighter", "monk", "ranger", "rogue"]
    assert result == expected, f"Expected {expected} but was {result}"
    # DEX and INT array
    arr = [17, 18, 16, 18, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["artificer", "fighter", "monk", "ranger", "rogue", "wizard"]
    assert result == expected, f"Expected {expected} but was {result}"
    # DEX and WIS array
    arr = [17, 18, 16, 15, 18, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["monk", "ranger"]
    assert result == expected, f"Expected {expected} but was {result}"
    # DEX and CHA
    arr = [17, 18, 16, 15, 14, 18]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = [
        "bard",
        "fighter",
        "monk",
        "paladin",
        "ranger",
        "rogue",
        "sorcerer",
        "warlock",
    ]
    assert result == expected, f"Expected {expected} but was {result}"

    # CON array will adapt to second highest stat every time

    # INT
    arr = [17, 16, 15, 18, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["artificer", "wizard"]
    assert result == expected, f"Expected {expected} but was {result}"
    # INT and STR done above
    # INT and DEX done above
    # INT and CON array
    arr = [17, 16, 18, 18, 14, 13]
    result = pc_roller.class_recs(arr)
    print(result)
    expected = ["artificer", "wizard"]
    assert result == expected, f"Expected {expected} but was {result}"


"""
This runs all of the tests in the file.
"""
if __name__ == "__main__":
    pytest.main()
    print("All tests passed successfully!")
