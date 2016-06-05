#!/usr/bin/python3
# Version dynamic programming
def lcs(a, b):
    lengths = [[0 for j in range(len(b)+1)] for i in range(len(a)+1)]

    # row 0 and column 0 are initialized to 0 already
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            if x == y:
                lengths[i+1][j+1] = lengths[i][j] + 1
            else:
                lengths[i+1][j+1] = max(lengths[i+1][j], lengths[i][j+1])

    # read the substring out from the matrix
    result = ""
    x, y = len(a), len(b)
    while x != 0 and y != 0:
        print("Debut: x=" + x.__str__() + "  y= " + y.__str__())
        if lengths[x][y] == lengths[x-1][y]:
            x -= 1
        elif lengths[x][y] == lengths[x][y-1]:
            y -= 1
        else:
            print ("test")
            assert a[x-1] == b[y-1]

            if (a[x-1] != b[y-1]):
                print("assert failed")
            else:
                print("assert success")

            result = a[x-1] + result
            x -= 1
            y -= 1
        print("result: " + result.__str__())

    return result

result = lcs("1234", "afghh")
print ( "LCS: " + result )

# result = lcs("thisisatest", "testing123testing")
# print ( "LCS: " + result )
