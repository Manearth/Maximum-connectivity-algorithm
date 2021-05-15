# Maximum-connectivity-algorithm
We obtained some candidate small molecule compounds through high-throughput screening. Since the proliferation of cardiomyocytes require simultaneous activation or shutdown of multiple signaling pathways, we further established combinations of these candidate molecules according to the following strategies.
We aim to find a small molecule combination that can achieve an utmost efficacy among all combinations. However, if the number of candidate molecules is n, then the possible combinations would be 2^n-1, when n is relatively large, it is impossible to complete all of the experiments. In order to complete the combination of candidate small molecules, we designed a set of prediction combination model（Extended Data Fig. 2）. Based on the efficacy of each small molecule individually and in pairs, we could predict better combinations.
If the efficacy of the combination of two compounds is better than that of two compounds individually, then the two small molecules have synergistic effect which can be defined as interconnected. Then, we define the efficacy of A as RA, the efficacy of B as RB, the efficacy of A and B as RA+B, if（RA+B）/RA≥1.3 and（RA+B）/RB≥1.3 , A and B are considered to be interconnected (we decide 1.3 as the threshold, which means that the mutual promotion between small molecules should achieve at least 30% increase in efficacy). 
Based on this principle, we wrote scripts that could be run on Matlab with customizable thresholds to find small molecule combinations that have satisfying synergistic effect. Specific parameters and details are as follows:
By inputting the efficacy of single small molecule and pairwise combination into the program, the program will output: all connections; all the combinations. All of these combinations satisfy the interconnection between any two small molecules.


How to use:
The input should be an xlsx file, as shown in Extended Data Fig. 2b. The cells in the first row and first column are the threshold values with connection. The other parts in the first row and column of the table are the names of the small molecules, and the order should be consistent. The remaining table is an upper triangular matrix, the diagonal is the efficacy of the corresponding small molecules administrated alone, and the other is the efficacy of the corresponding two small molecules administrated together. When using this system, the protocol is to run enhancing_conbinations.m in MATLAB and select the xlsx file. The following introduction is illustrated with the file data.xlsx.

Output:
The outputs are 3 xlsx files: data_strength.xlsx, data_link.xlsx, and data _combination.xlsx.
data_strength.xlsx contains the strength of the compound pairs acting together. The strength is defined as: the average times of the effect of the two compounds working together to each acting alone. For example, the effect of A acting alone is RA, the effect of B acting alone is RB, and the effect of A and B acting together is RA+B, then the strength of the pair is SAB (the calculation formula of SAB is shown in the Extended Data Fig. 2a).
data_link.xlsx contains all links in those compounds, and the strength of the corresponding compounds pairs.
data _combination.xlsx contains all combinations, each combination satisfies any two compounds in the combination are linked. For each combination, give the number of compounds in the combination (Comb_Num), sum of all link strength (Strength_Sum) and product of all link strength (Strength_Prod).


