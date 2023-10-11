"""
Archetype is the name I have chosen to use instead of Class as that term in code gets used everywhere.
"""


class Archetype:
    def __init__(self, name):
        self.name = name
        self.features = []
        self.unlock_levels = []

    def add_feature(self, feature, unlock_level):
        self.features.append(feature)
        self.unlock_levels.append(unlock_level)

    def get_features_for_level(self, level):
        features = []
        for i in range(0, len(self.features)):
            if level >= self.unlock_levels[i]:
                features.append(self.features[i])
        return features


"""
Features are how I am expressing every feature a character gets from race, class, and feats.
"""


class Feature:
    def __init__(self, name):
        self.name = name
        self.desc = ""
        self.uses = "N/A"
        self.prereq = "N/A"

    def edit_desc(self, desc):
        self.desc = desc

    def edit_uses(self, uses):
        self.uses = uses

    def edit_prereq(self, prereq):
        self.prereq = prereq


"""
Character is the object that holds all the data on a given character's features.
"""


class Character:
    def __init__(self, name):
        self.name = name
        self.level = 1
        self.archetypes = []
        self.arch_levels = []

    def level_up(self):
        self.level = self.level + 1

    def add_archetype(self, archetype):
        if self.level > sum(self.arch_levels):
            self.archetypes.append(archetype)
            self.arch_levels.append(1)
        else:
            raise Exception("No open level to add a new class.")
