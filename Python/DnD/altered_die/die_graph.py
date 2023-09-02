import random

die_list = [4, 6, 8, 10, 12, 20]

"""
"""


def verify_graph(die_graph: dict):
    for face in range(1, len(die_graph)):
        for adj_face in die_graph[face]:
            if die_graph[adj_face].count(adj_face) != 0:
                print("{} {}".format(die_graph[adj_face], adj_face))
                return False
    return True


"""
"""


def load_die(num: int):
    try:
        die_graph = {}
        file = "d{}.txt".format(num)
        # print(file)
        f = open(file)
        for i in range(0, num):
            str = f.readline()
            str_list = str.split(":")
            face = str_list[0]  # The face showing on the die
            # print(face)
            # print(str_list[1])
            adj_str = str_list[1]  # Immediately adjacent faces
            adj_str_list = adj_str.split(",")
            adj_list = []
            for j in range(0, len(adj_str_list)):
                adj_face = int(adj_str_list[j].strip())
                adj_list.append(adj_face)
            die_graph[int(face)] = adj_list

        f.close()
        # print(die_graph)
        return die_graph
    except:
        print("The file d{}.txt does not exist.".format(num))


"""
"""


def check_dice():
    print("Dice Graphs:")
    for e in die_list:
        print("d{}: {}".format(e, verify_graph(load_die(e))))


"""
"""


def norn_roll(die, testing: bool = False, die_res: int = 0):
    die_graph = load_die(die)
    res = 0
    if testing:
        res = die_res
    else:
        res = random.randint(die)
    sum = 0
    for num in die_graph[res]:
        sum += num
    return sum


"""
"""


def norn_table(die):
    print("Norn d{} Result Table".format(die))
    print("Roll : Norn Result")
    for i in range(1, die + 1):
        res = norn_roll(die, True, i)
        print("{:4d} : {:2d}".format(i, res))


"""
"""


def norn_tables():
    for e in die_list:
        norn_table(e)


check_dice()
norn_tables()
