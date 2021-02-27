import operator as op
from functools import reduce

# Function for finding nCr
def ncr(n, r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer//denom

def probable_payouts(ph, pa):
    # make a list of length 10 to store the win probability
    # of each score
    winProb = [0] * 10
    # For each innning (there are 9)
    for inning in range(9):
        # inining ranges from 0 to 8.
        # But we want it to be rom 1 to 9
        # So we will use (inning + 1) everywhere
        # Since score can range from 0 to inning*2
        for score in range((inning+1) * 2 + 1):
            # Calculate the probability of scoring score here
            nCr = ncr((inning+1) * 2, score)
            # probability of getting a score is
            # = nCr * P^r * (1-P)^(n-r)
            # We use %(mod)10 to get the last digit
            winProb[score%10] += nCr * pow(ph, score) * pow(pa, (inning+1) * 2 - score)
            # winProb has the probability of winning
            # make a dictionary
            payout = {}
            for score in range(10):
                payout[score] = winProb[score] * 5
    return payout