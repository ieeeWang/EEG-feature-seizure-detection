Matlab code for hurst parameter estimate
===========================================
The routines are used to estimate the hurst parameter of a given sequence. In the FGN.mat, two different FGN sequences are generated with FFT method. The fgn070_S is a simulated FGN sequence with H=0.7 and length=1000 while the fgn080_L is a simulated FGN sequence with H=0.8 and length=10000. For more details about FFT method, see Paxson's "Fast, Approximate Synthesis of Fractional Gaussian Noise for Generating Self-Similar Network Traffic".

example use:
    load FGN.mat;
    hurst_estimate(fgn080_L, 'absval', 1, 1);





self-similar process
==========================================
The most important characteristic of a covariance stationary self-similar stochastic process is that it is long-range dependent. The long-range dependent time series hold significant correlations across arbitrarily large time scales. And the Hurst parameter H measure the degree of long-range dependence and can be estimated by several methods.

The estimate effect for longer time series is better than shorter one's.





Some remarks about the estimators
==========================================
The theories of the methods can be found in Murad's Taqqu, Vadim Teverovsky and Walter Willinger's paper "Estimators for long-range dependence: an empirical study" or other related papers.

Although there are several methods to estimate the Hurst parameter of a time series, none of them is perfect. They can be easily cheated by some non-LRD data, e.g., there is periodicity or trend exit in the time series.  The white gauss noise can also affect the estimate effect.

However, the plot can show some useful information. For a real LRD time series, the line fitting is natural and reasonable. For a careful estimation, we strongly recommend use more than one estimate method and draw plot.





Other estimators
==========================================
The other common used estimators are wavelet estimator and whittle estimator. The matlab code of wavelet estimator can be obtained from: http://www.cubinlab.ee.unimelb.edu.au/~darryl/secondorder_code.html. 

The S language whittle estimator can be found from:  http://math.bu.edu/people/murad/methods/implementations/whittle/whittle.S.
Whittle estimator is the most accurate one, however, it can't provide plot and can only used to a time series with strict mathematical expression. 





Any comments and suggestions are welcome. 
Author:  Chu Chen
chen-chu@163.com