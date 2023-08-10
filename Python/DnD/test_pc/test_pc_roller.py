import pytest
from ..example import pc_roller


def test_roll4drop():
    result = pc_roller.roll4drop(True, 10)
    assert result == 13, f"Expected 13 but was {result}"
    result = pc_roller.roll4drop(True, 11)
    assert result == 13, f"Expected 13 but was {result}"
    result = pc_roller.roll4drop(True, 12)
    assert result == 15, f"Expected 15 but was {result}"


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


if __name__ == "__main__":
    pytest.main()
    print("All tests passed successfully!")
