def verify_graph():
    return True

def load_die(num: int):
    f = open("d{num}.txt")
    for i in range(1, num):
        str = f.readline()
        str.split(':')