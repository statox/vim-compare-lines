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
        if lengths[x][y] == lengths[x-1][y]:
            x -= 1
        elif lengths[x][y] == lengths[x][y-1]:
            y -= 1
        else:
            assert a[x-1] == b[y-1]
            result = a[x-1] + result
            x -= 1
            y -= 1

    return result

def diffLineWithLCS(line, lcs):
    # Will contain the part of the string whic differ from the LCS
    diffParts = []

    currentPart = ""
    comparedChar = lcs[0]

    # Creation of the diff
    for i in line:
        # Character commom with lcs: new separation in the differences
        if (i == comparedChar):
            lcs = lcs[1:]

            if currentPart != "":
                diffParts.append(currentPart)
                currentPart=""
            if len(lcs) > 0:
                comparedChar = lcs[0]
            else:
                comparedChar = None

        else:
            currentPart+=i

    # Add the last difference
    if currentPart != "":
        diffParts.append(currentPart)

    return diffParts

def diffLines(line1, line2):
    diffParts1 = diffLineWithLCS(line1, lcs(line1, line2))
    diffParts2 = diffLineWithLCS(line2, lcs(line1, line2))

    print(line1 + "   " + ",".join(diffParts1))
    print(line2 + "   " + ",".join(diffParts2))
    print("")
