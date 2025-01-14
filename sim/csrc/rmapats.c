// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  schedNewEvent (struct dummyq_struct * I1401, EBLK  * I1396, U  I622);
void  schedNewEvent (struct dummyq_struct * I1401, EBLK  * I1396, U  I622)
{
    U  I1665;
    U  I1666;
    U  I1667;
    struct futq * I1668;
    struct dummyq_struct * pQ = I1401;
    I1665 = ((U )vcs_clocks) + I622;
    I1667 = I1665 & ((1 << fHashTableSize) - 1);
    I1396->I664 = (EBLK  *)(-1);
    I1396->I665 = I1665;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1396);
    }
    if (I1665 < (U )vcs_clocks) {
        I1666 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1396, I1666 + 1, I1665);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I622 == 1)) {
        I1396->I667 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I664 = I1396;
        peblkFutQ1Tail = I1396;
    }
    else if ((I1668 = pQ->I1304[I1667].I687)) {
        I1396->I667 = (struct eblk *)I1668->I685;
        I1668->I685->I664 = (RP )I1396;
        I1668->I685 = (RmaEblk  *)I1396;
    }
    else {
        sched_hsopt(pQ, I1396, I1665);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
