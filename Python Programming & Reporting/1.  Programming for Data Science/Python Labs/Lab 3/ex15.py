def probable_payouts(ph, pa):
    winning_prob = [[0 for i in range(19)] for j in range(10)]
    winning_prob[0][0] = 1
    for inning in range(1, 10):
        for score in range((inning) * 2 + 1):
            winning_prob[inning][score] = winning_prob[inning-1][score]*(1-ph)*(1-pa)
            if(score>0):
                winning_prob[inning][score] += winning_prob[inning-1][score-1]*((1-ph)*(pa)+(ph)*(1-pa))
            if(score>1):
                winning_prob[inning][score] += winning_prob[inning-1][score-2]*(ph)*(pa)
    payout = {}
    for score in range(10):
        payout[score] = 0;
    for score in range(19):
        for inning in range(1,10):
            payout[score%10] += winning_prob[inning][score] * 5
    return payout