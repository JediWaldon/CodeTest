# Altered Dice

This is for coming up with alternate ways to read dice results for unusual encounters in DnD. In the process I discovered a couple rules for how dice are formatted. The only exception may be d10s.

| Die | Adjacency Rule |
|-----|----------------|
| d4 | `sur_this + sur_op = 15` |
| d6 | `sur_this = 14` |
| d8 | `sur_this + sur_op = 27` |
| d10 | `sur_this + sur_other = 44` |
| d12 | `sur_this + sur_op = 65` |
| d20 | `sur_this + sur_op = 63` |

`sur_this` is the sum of the face values immediately adjacent to the chosen die face. (EX: die face is 1 on a d20, the sum of the values around it is 39)

`sur_op` is the sum of the face values immediately adjacent to the number opposite of the chosen die face. (EX: die face is a 1 on a d20, the opposite is a 20, the sum of the values around the 20 face is 24)

`sur_other` is the sum of the face values immediately adjacent to some other die face. May not be the opposite of the chosen die.