def probable_payouts(ph, pa):
    winProb = [[0 for i in range(19)] for j in range(10)]
    winProb[0][0] = 1
    for inning in range(1, 10):
        for score in range((inning) * 2 + 1):
            winProb[inning][score] = winProb[inning-1][score]*(1-ph)*(1-pa)
            if(score>0):
                winProb[inning][score] += winProb[inning-1][score-1]*((1-ph)*(pa)+(ph)*(1-pa))
            if(score>1):
                winProb[inning][score] += winProb[inning-1][score-2]*(ph)*(pa)
    payout = {}
    for score in range(10):
        payout[score] = 0;
    for score in range(19):
        for inning in range(1,10):
            payout[score%10] += winProb[inning][score] * 5
    return payout