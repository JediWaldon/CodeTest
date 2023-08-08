#!/usr/bin/env python3
import random
'''
roll4drop rolls 4d6 and drops the lowest die before totalling the dice together and reporting the modifier for the total.
'''
def roll4drop():
    arr = []
    for i in range(4):
        x = random.randint(1, 6)
        arr.append(x)
        # print("D6 #" + str(i) + ": " + str(x))
    arr.sort()
    # print(len(arr))
    sum = 0
    for j in range(1,4):
        # print(j)
        sum += arr[j]
    return sum
    # print("Total: " + str(sum))
    # mod = stat_mod(sum)
    # print("Mod: " + ("+", " ") [mod < 0] + str(mod))

'''
stat_mod takes a stat total and returns the modifier number for the number given.
@param num is the integer given
@return the integer modifier for the stat
'''
def stat_mod(num:int):
    return num // 2 - 5

'''
check_mod_calcs prints the stat numbers and the generated modifiers for them for manual review.
'''
def check_mod_calc():
    for i in range(1,19):
        print("Stat: " + str(i) + " Mod: " + str(stat_mod(i)))

'''
gen_array generates a statistics array for a player character
@return the stat array
'''
def gen_array():
    stats = []
    for i in range(6):
        stats.append(roll4drop())
    return stats

'''
class_recs gives recommendations on the class to play with the given stat array. The highest attributes are determined and then class recommendations are generated before being returned.
@param arr is the stat array for which class recommendations are going to be generated.
@return the list of class recommendations for the given stat array.
'''
def class_recs(arr:list):
    f_idx = -1
    f_hi = 0
    for idx in range(6):
        if arr[idx] > f_hi:
            f_hi = arr[idx]
            f_idx = idx
    s_idx = -1
    s_hi = 0
    for jdx in range(6):
            if arr[jdx] <= f_hi and arr[jdx] > s_hi and jdx != f_idx:
                s_hi = arr[jdx]
                s_idx = jdx
    options = []
    if f_hi != s_hi and f_idx != 2:
        options = get_opt(f_idx)
    else:
        short_names = ["STR", "DEX", "CON", "INT", "WIS", "CHA"]
        # print(short_names[f_idx] + " " + short_names[s_idx])
        options = list(set(get_opt(f_idx)) & set(get_opt(s_idx)))
        if len(options) == 0:
            options = list(set(get_opt(f_idx)) | set(get_opt(s_idx)))
    return options

'''
get_opt takes the index of the atttribute for which class recommendations are requested. The function returns the classes that make the most use of the given attribute in a list.
@param idx is the index of the attribute for which class recommendations are requested.
@return the list of classes that make a lot of use from the given attribute.
'''
def get_opt(idx:int):
    # if idx == 0:
    #     return ["barbarian", "fighter", "paladin", "ranger"]
    # elif idx == 1:
    #     return ["fighter", "monk", "ranger", "rogue"]
    # elif idx == 2:
    #     return ["artificer", "barbarian", "bard", "cleric", "druid", "fighter", "monk", "paladin", "ranger", "rogue", "sorcerer", "warlock", "wizard"]
    # elif idx == 3:
    #     return ["artificer", "wizard"]
    # elif idx == 4:
    #     return ["cleric", "druid", "monk", "ranger"]
    # else:
    #     return ["bard", "paladin", "sorcerer", "warlock"]
    match idx:
        case 0:
            return ["barbarian", "fighter", "paladin", "ranger"]
        case 1:
            return ["fighter", "monk", "ranger", "rogue"]
        case 2:
            return ["artificer", "barbarian", "bard", "cleric", "druid", "fighter", "monk", "paladin", "ranger", "rogue", "sorcerer", "warlock", "wizard"]
        case 3:
            return ["artificer", "wizard"]
        case 4:
            return ["cleric", "druid", "monk", "ranger"]
        case 5:
            return ["bard", "paladin", "sorcerer", "warlock"]

'''
mod_sum adds together all the modifiers for the stat array.
@param arr is the stat array being evaluated.
@return the cumulative modifier of the stat array.
'''
def mod_sum(arr:list):
    sum = 0
    for e in arr:
        sum += stat_mod(e)
    return sum

'''
pc_gen creates a stat array and a recommendation for what class to use with the given array.
''' 
def pc_gen():
    while True:
        arr = gen_array()
        if mod_sum(arr) >= 3:
            break
    stat_descr(arr)
    options = class_recs(arr)
    print(options)

'''
stat_descr prints out a description for all the attributes in the stat array.
'''
def stat_descr(arr:list):
    short_names = ["STR", "DEX", "CON", "INT", "WIS", "CHA"]
    for idx in range(6):
        mod = stat_mod(arr[idx])
        print(short_names[idx] + ": " + (" ", "") [mod >= 0] + str(arr[idx]) + " MOD: " + ("+", "") [mod < 0] + str(mod))


#check_mod_calc()
pc_gen()