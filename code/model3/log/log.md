# cpp log

- in lambdas, using `[&]` to capture is most efficient
- indeed, using arrays is faster than vector, (about 1.2 times faster)
- Need to be very careful to pass the correct size to the DP algo8 if using arrays over vectors. I feel writing safe code is easiest in scala. 
  - It seems scala code is about 2x slower than rcpp. But using rscala makes
    it 3x slower. Strange.

