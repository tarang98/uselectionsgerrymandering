# for each in range(len(alist)):
#     if alist[each]['geometry']['type'] == 'Polygon':
#         numpoly += 1
#     else:
#         print(each)

import numpy as np
import fiona
import sys

src = fiona.open("zip://" + sys.argv[1])
num_precincts = len(src)
matrix = np.zeros((num_precincts, num_precincts))

for each_precinct in range(num_precincts):
    if src[each_precinct]['geometry']['type'] == 'Polygon':
        set1 = set(src[each_precinct]['geometry']['coordinates'][0][0])
        for each_other_precinct in range(each_precinct+1, num_precincts):
            set2 = set(src[each_other_precinct]['geometry']['coordinates'][0][0])
            iset = set.intersection(set1, set2)
            if len(iset) > 0:
                matrix[each_precinct, each_other_precinct] = 1
    print(each_precinct)

matrix = matrix.astype(bool)
np.savetxt(sys.argv[1] + ".txt", matrix, delimiter=",", fmt="%1.f")
[]
src.close()
