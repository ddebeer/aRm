# extracting results gives previous results

    Code
      results1
    Output
      
      Multivariate Tests: treatment:gender:phase:hour
                       df test stat approx F num df den df p_value
      Pillai            2   0.79277  0.32834     16      8 0.97237
      Wilks             2   0.36217  0.24812     16      6 0.98808
      Hotelling-Lawley  2   1.33332  0.16667     16      4 0.99620
      Roy               2   0.79560  0.39780      8      4 0.87560

---

    Code
      results2
    Output
      
      Multivariate Test: 
            df test stat approx F num df den df    p_value
      Wilks  1   0.20114   39.715      1     10 8.8853e-05

---

    Code
      results3
    Output
      
      Type III Repeated Measures MANOVA Tests: Wilks test statistic
                                  df test stat approx F num df den df p_value
      (Intercept)                  1   0.03264  296.389      1     10 0.00000
      treatment                    2   0.55925    3.940      2     10 0.05471
      gender                       1   0.73211    3.659      1     10 0.08480
      treatment:gender             2   0.63650    2.855      2     10 0.10447
      phase                        1   0.18637   19.645      2      9 0.00052
      treatment:phase              2   0.31068    3.573      4     18 0.02588
      gender:phase                 1   0.93386    0.319      2      9 0.73497
      treatment:gender:phase       2   0.69426    0.901      4     18 0.48413
      hour                         1   0.06714   24.315      4      7 0.00033
      treatment:hour               2   0.70618    0.332      8     14 0.93906
      gender:hour                  1   0.66078    0.898      4      7 0.51298
      treatment:gender:hour        2   0.49376    0.740      8     14 0.65676
      phase:hour                   1   0.43957    0.478      8      3 0.82027
      treatment:phase:hour         2   0.44604    0.186     16      6 0.99668
      gender:phase:hour            1   0.28849    0.925      8      3 0.58949
      treatment:gender:phase:hour  2   0.36217    0.248     16      6 0.98808

---

    Code
      results4
    Output
      
      Type III Repeated Measures MANOVA Tests: Roy test statistic
                                  df test stat approx F num df den df p_value
      (Intercept)                  1   29.6389  296.389      1     10 0.00000
      treatment                    2    0.7881    3.940      2     10 0.05471
      gender                       1    0.3659    3.659      1     10 0.08480
      treatment:gender             2    0.5711    2.855      2     10 0.10447
      phase                        1    4.3656   19.645      2      9 0.00052
      treatment:phase              2    2.1865   10.932      2     10 0.00304
      gender:phase                 1    0.0708    0.319      2      9 0.73497
      treatment:gender:phase       2    0.4166    2.083      2     10 0.17530
      hour                         1   13.8944   24.315      4      7 0.00033
      treatment:hour               2    0.2629    0.526      4      8 0.72045
      gender:hour                  1    0.5134    0.898      4      7 0.51298
      treatment:gender:hour        2    0.7143    1.429      4      8 0.30879
      phase:hour                   1    1.2750    0.478      8      3 0.82027
      treatment:phase:hour         2    0.5793    0.290      8      4 0.93605
      gender:phase:hour            1    2.4664    0.925      8      3 0.58949
      treatment:gender:phase:hour  2    0.7956    0.398      8      4 0.87560

---

    Code
      results5
    Output
      
      Type III Repeated Measures MANOVA Tests: Hotelling-Lawley test statistic
                                  df test stat approx F num df den df p_value
      (Intercept)                  1   29.6389  296.389      1     10 0.00000
      treatment                    2    0.7881    3.940      2     10 0.05471
      gender                       1    0.3659    3.659      1     10 0.08480
      treatment:gender             2    0.5711    2.855      2     10 0.10447
      phase                        1    4.3656   19.645      2      9 0.00052
      treatment:phase              2    2.1966    4.393      4     16 0.01380
      gender:phase                 1    0.0708    0.319      2      9 0.73497
      treatment:gender:phase       2    0.4334    0.867      4     16 0.50493
      hour                         1   13.8944   24.315      4      7 0.00033
      treatment:hour               2    0.3842    0.288      8     12 0.95699
      gender:hour                  1    0.5134    0.898      4      7 0.51298
      treatment:gender:hour        2    0.8957    0.672      8     12 0.70808
      phase:hour                   1    1.2750    0.478      8      3 0.82027
      treatment:phase:hour         2    0.9989    0.125     16      4 0.99904
      gender:phase:hour            1    2.4664    0.925      8      3 0.58949
      treatment:gender:phase:hour  2    1.3333    0.167     16      4 0.99620

