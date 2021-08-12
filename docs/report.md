---
title: "Psychiatric Symptoms of Veterans Surveyed Through Facebook Ads"
date: "2021-08-12 15:10:53"
author: Benjamin Chan (chanb@ohsu.edu)
output:
  html_document:
    toc: true
    theme: simplex
---

# Read data

**Most of this code was developed in Phase 1.**
Results will be suppressed for brevity.

**Use only the REDCap survey data**

Notes on the REDCap identifier variables:

* If `[consent] == 1`, they started the eligibility survey; 
  * if `== 0` or `== NA`, they didn't.
* If `[consent_and_eligibility_complete] == 2`, they finished the screener (whether eligible or ineligible); 
  * if `== 0`, they dropped out or never started.
* If `[eligible] == 1`, they completed the screener and were eligible; 
  * if `== 0`, they completed and were ineligible;
  * if `== NA` , they dropped out or never started.
* If `[veterans_and_social_media_use_co] == 2`, they finished the survey; 
  * if `== 0`, they dropped out or never started (this includes people who were ineligible or didn't consent).
* If `[analytic_sample] == 0`, they completed the survey but were disqualified for data quality reasons; 
  * if `== 1`, they completed survey and was not disqualified for data quality reasons;
  * if `== NA`, they didn't complete the survey.


| consent| consent_and_eligibility_complete| eligible| veterans_and_social_media_use_co| analytic_sample|   n|
|-------:|--------------------------------:|--------:|--------------------------------:|---------------:|---:|
|       0|                                0|       NA|                                0|              NA|   8|
|       0|                                2|        0|                                0|              NA|   7|
|       1|                                0|       NA|                                0|              NA|  84|
|       1|                                2|        0|                                0|              NA| 534|
|       1|                                2|        1|                                0|              NA| 106|
|       1|                                2|        1|                                2|               0|  18|
|       1|                                2|        1|                                2|               1| 587|
|      NA|                                0|       NA|                                0|              NA|  96|

Inclusion criteria

* Completed survey and was not disqualified for data quality reasons; `[analytic_sample] == 1`

**Number included: n = 587**

Cleaning

* Parse out `fba` into 2 separate variables for `image` and `text`
* Assign indicator for survey participation, `indSurveyParticipation`
  * `analytic_sample == 1`: Participant completed survey and was not disqualified for data quality reasons
* Assign indicator for eligibility screener participation, `indScreenerParticipation`
  * `eligible == 1`: Participant completed eligibility screener and was eligible to participate in full survey



## Use of VA health services



Recoding logic

* Primary analysis will code `9` (not sure) as `0` (No)
* Sensitivity analysis will exclude the `9` values from the analysis
* If `va_ever_enrolled == FALSE` & `is.na(va_use_12mo)`, then recode `va_use_12mo` to `FALSE`
* If `va_use_12mo == TRUE` & `va_ever_enrolled == FALSE`, then recode `va_ever_enrolled` to `TRUE`
* Code indicators `indVANeverEnrolled` and `indVANotUse12mo` as the logical opposites of `va_ever_enrolled` and `va_use_12mo`




## Independent variables

* Score the Modified Facebook Measure of Social Support (FMSS)
  * Reverse-scored items are `fmss_r7` through `fmss_r10`
* Standardize FMSS
* Prep FMSS items
  * Combine categories due to small cell sizes


```
##       fmss           fmssZ         
##  Min.   :14.00   Min.   :-2.29729  
##  1st Qu.:25.00   1st Qu.:-0.62179  
##  Median :29.00   Median :-0.01252  
##  Mean   :29.08   Mean   : 0.00000  
##  3rd Qu.:34.00   3rd Qu.: 0.74908  
##  Max.   :48.00   Max.   : 2.88153  
##  NA's   :15      NA's   :15
```

```
##       fmss fmssZ
## fmss     1     1
## fmssZ    1     1
```

```
##           fmss    fmssZ
## fmss  6.565197 2.562264
## fmssZ 2.562264 1.000000
```



|fmssQuartile |   n| min| max|
|:------------|---:|---:|---:|
|Q1: [14,25]  | 175|  14|  25|
|Q2: (25,29]  | 135|  26|  29|
|Q3: (29,34]  | 138|  30|  34|
|Q4: (34,48]  | 124|  35|  48|
|NA           |  15|  NA|  NA|

Check.

![plot of chunk histogramFMSS](../figures/histogramFMSS-1.png)

Cronbach's alpha for FMSS items 1-3.


```
## 
## Reliability analysis   
## Call: psych::alpha(x = .)
## 
##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean  sd median_r
##       0.91      0.91    0.87      0.77  10 0.0065  1.1 0.9     0.78
## 
##  lower alpha upper     95% confidence boundaries
## 0.9 0.91 0.92 
## 
##  Reliability if an item is dropped:
##         raw_alpha std.alpha G6(smc) average_r S/N alpha se var.r med.r
## fmss_r1      0.89      0.89    0.80      0.80 7.8   0.0094    NA  0.80
## fmss_r2      0.85      0.85    0.74      0.74 5.7   0.0124    NA  0.74
## fmss_r3      0.87      0.87    0.78      0.78 7.0   0.0104    NA  0.78
## 
##  Item statistics 
##           n raw.r std.r r.cor r.drop mean   sd
## fmss_r1 585  0.91  0.91  0.84   0.80  1.0 0.94
## fmss_r2 584  0.93  0.93  0.89   0.84  1.1 0.97
## fmss_r3 584  0.92  0.92  0.86   0.82  1.1 1.03
## 
## Non missing response frequency for each item
##            0    1    2    3    4 miss
## fmss_r1 0.36 0.37 0.21 0.06 0.01 0.00
## fmss_r2 0.33 0.38 0.21 0.08 0.01 0.01
## fmss_r3 0.33 0.35 0.21 0.10 0.02 0.01
```

Cronbach's alpha for FMSS items 1-3 = Cronbach's alpha = 0.910.

Create FMSS subscore for items 1-3.






## Dependent variables

### Psychiatric symptoms (RQ1)

Code indicators for psychiatric disorder screening scales

* PTSD
  * Name of scale: PC-PTSD 
  * Positive screen: `ptsd_intrusive` + `ptsd_avoidant` + `ptsd_guarded` + `ptsd_numb` + `ptsd_guilty` $\ge$ 3
* Major depression
  * Name of scale: PHQ-2
  * Positive screen: `phq_interest` + `phq_mood` $\ge$ 3
* Alcohol misuse
  * Name of scale: AUDIT-C
  * Positive screen: `auditc_freq` + `auditc_amount` + `auditc_binge` $\ge$ 4 for men, $\ge$ 3 for women

Presence of suicidality is defined as DSI-SS score $\ge$ 2.
This cut-off score was chosen based on recommendations for population-based samples noted in 
[von Glischinski M Clin Psychol Psychotherapy 2015](http://onlinelibrary.wiley.com/doi/10.1002/cpp.2007/full)

* Score the DSI-SS inventory
  * See [Joiner 2002](http://www.sciencedirect.com/science/article/pii/S0005796701000171)
  * *Scores on each item range from 0 to 3 and, for the inventory, from 0 to 12, with higher scores reflecting greater severity of suicidal ideation.*



Check.


|yvariable |indPTSD | mean | sd  | min | max |  n  | freq  |
|:---------|:-------|:----:|:---:|:---:|:---:|:---:|:-----:|
|ptsd      |FALSE   | 0.7  | 0.8 |  0  |  2  | 319 | 54.5% |
|ptsd      |TRUE    | 4.2  | 0.8 |  3  |  5  | 266 | 45.5% |

\newline


|yvariable |indPHQ | mean | sd  | min | max |  n  | freq  |
|:---------|:------|:----:|:---:|:---:|:---:|:---:|:-----:|
|phq       |FALSE  | 1.0  | 0.9 |  0  |  2  | 422 | 72.0% |
|phq       |TRUE   | 4.5  | 1.2 |  3  |  6  | 164 | 28.0% |

\newline


|yvariable |indAuditC | mean | sd  | min | max |  n  | freq  |
|:---------|:---------|:----:|:---:|:---:|:---:|:---:|:-----:|
|auditc    |FALSE     | 1.3  | 1.1 |  0  |  3  | 341 | 58.4% |
|auditc    |TRUE      | 5.9  | 2.1 |  3  | 12  | 243 | 41.6% |

\newline


|yvariable |indDSISS | mean | sd  | min | max |  n  | freq  |
|:---------|:--------|:----:|:---:|:---:|:---:|:---:|:-----:|
|dsiss     |FALSE    | 0.1  | 0.3 |  0  |  1  | 453 | 77.4% |
|dsiss     |TRUE     | 3.9  | 1.6 |  2  |  9  | 132 | 22.6% |

Also create logical opposite for use in RQ3 modeling




### Social media use (RQ2)

* Spending more time on Facebook?
  * Frequency of Facebook use: `fb_freq`
  * Active use of Facebook: `comm_facebook`
* Sharing more personal or health-related information on social media?
  * `sm_emot_support`
  * `sm_med_info`
  * `sm_med_advice`
  * `sm_med_questions`
  * `sm_share_sympt`
  * `sm_share_health`
  * `sm_share_suicide`
  
Mutate variables to factors.





## Covariates

* Social media platforms used: `sm_used___1`, ..., `sm_used___7`, `sm_used___99`, `sm_used_other`
  * Recode the following `sm_used_other` values such that `sm_used___99 = 0`
    * `I use Wikipedia to read about illnesses I don't have; it's a curiosity/hobby thing.`
    * `just in person`
    * `Just plain internet search`
    * `TV/phone conversations, veterans group meetings`
    * `google; bing`
    * `aol`
    * `e-mail`
    * `Web MD`
    * `webmd`
* Offline social contact: `comm_inperson`
* History of suicidal ideation and suicide attempts
  * `suicide_considered_ever`
  * `suicide_considered_12mo`
  * `suicide_attempts` 



Check.


|smOther |sm_used_other                                                                       |   n|
|:-------|:-----------------------------------------------------------------------------------|---:|
|FALSE   |                                                                                    | 552|
|FALSE   |aol                                                                                 |   1|
|FALSE   |e-mail                                                                              |   1|
|FALSE   |google; bing                                                                        |   1|
|FALSE   |I use Wikipedia to read about illnesses I don't have; it's a curiosity/hobby thing. |   1|
|FALSE   |just in person                                                                      |   1|
|FALSE   |TV/phone conversations, veterans group meetings                                     |   1|
|FALSE   |Web MD,                                                                             |   1|
|FALSE   |webmd                                                                               |   1|
|TRUE    |4chan                                                                               |   2|
|TRUE    |Gmail Hangouts; Reddit.com                                                          |   1|
|TRUE    |Google+                                                                             |   2|
|TRUE    |I used LiveJournal for the majority of my service as well as my deployment to Iraq  |   1|
|TRUE    |Linked In                                                                           |   1|
|TRUE    |LinkedIn, Snapchat                                                                  |   1|
|TRUE    |LiveJournal                                                                         |   1|
|TRUE    |MIL.MIL                                                                             |   1|
|TRUE    |Ravelry Forums                                                                      |   1|
|TRUE    |reddit                                                                              |   3|
|TRUE    |Reddit                                                                              |   5|
|TRUE    |Snao Chat                                                                           |   1|
|TRUE    |snapchat                                                                            |   3|
|TRUE    |Snapchat                                                                            |   1|
|TRUE    |SnapChat                                                                            |   1|
|TRUE    |webmd, mayoclinic,wikipedia, va                                                     |   1|
|TRUE    |www.coping-with-epilepsy.com                                                        |   1|

\newline

Number of social media platforms used (excluding Facebook):


| countSocialMediaExclFB|   n|
|----------------------:|---:|
|                      0| 347|
|                      1| 138|
|                      2|  68|
|                      3|  21|
|                      4|  11|
|                      5|   2|

\newline


|comm_inperson                 |   n|
|:-----------------------------|---:|
|Every few weeks or less often | 169|
|Once a week                   |  70|
|A few times a week            | 114|
|Once a day                    |  58|
|Several times a day           | 175|
|(Missing)                     |   1|

\newline


|indSuicideConsideredEver |indSuicideConsidered12mo |indSuicideAttempt | countSuicideAttempts|   n|
|:------------------------|:------------------------|:-----------------|--------------------:|---:|
|FALSE                    |FALSE                    |FALSE             |                    0| 330|
|TRUE                     |FALSE                    |FALSE             |                    0| 140|
|TRUE                     |FALSE                    |TRUE              |                    1|  31|
|TRUE                     |TRUE                     |FALSE             |                    0|  29|
|TRUE                     |FALSE                    |TRUE              |                    2|  16|
|TRUE                     |TRUE                     |TRUE              |                    1|  11|
|TRUE                     |FALSE                    |TRUE              |                    3|   9|
|TRUE                     |TRUE                     |TRUE              |                    3|   8|
|TRUE                     |TRUE                     |TRUE              |                    2|   7|
|TRUE                     |FALSE                    |TRUE              |                    4|   2|
|TRUE                     |FALSE                    |TRUE              |                    5|   2|
|TRUE                     |TRUE                     |TRUE              |                    5|   1|
|NA                       |NA                       |NA                |                  NaN|   1|



Of the 358 who had social contact on Facebook at least daily, 167 (47%) also had at least daily in-person social contact while 191 (53%) had in-person social contact less than daily, a non-significant difference (p = 0.224). 



Of the 233 who had in-person social contact at least daily, 167 (72%) also had at least daily social contact on Facebook while 66 (28%) had social contact on Facebook less than daily, a significant difference (p = 0.000).

# Research Question 1

**Is perceived social support received from Facebook (FMSS) associated with lower rates of**

* Positive screens for psychiatric disorders
  * PC-PTSD
  * PHQ-2
  * AUDIT-C
* Positive screen for suicidality?
  * DSI-SS


## Unadjusted comparisons


|yvariable |indPTSD | mean | sd  | min | max |  n  | freq  |
|:---------|:-------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE   | 29.7 | 6.3 | 14  | 45  | 309 | 54.2% |
|fmss      |TRUE    | 28.3 | 6.8 | 16  | 48  | 261 | 45.8% |

\newline


|yvariable |indPHQ | mean | sd  | min | max |  n  | freq  |
|:---------|:------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE  | 29.5 | 6.4 | 16  | 48  | 412 | 72.2% |
|fmss      |TRUE   | 27.9 | 6.9 | 14  | 44  | 159 | 27.8% |

\newline


|yvariable |indAuditC | mean | sd  | min | max |  n  | freq  |
|:---------|:---------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE     | 29.2 | 6.8 | 14  | 48  | 335 | 58.9% |
|fmss      |TRUE      | 29.0 | 6.3 | 16  | 45  | 234 | 41.1% |

\newline


|yvariable |indDSISS | mean | sd  | min | max |  n  | freq  |
|:---------|:--------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE    | 29.5 | 6.6 | 16  | 48  | 442 | 77.5% |
|fmss      |TRUE     | 27.6 | 6.4 | 14  | 44  | 128 | 22.5% |

\newline

![plot of chunk plot2GroupsRQ1](../figures/plot2GroupsRQ1-1.png)


## Adjusted comparisons


```
##           fmss fmssZ
## fmss  6.565197     0
## fmssZ 0.000000     1
```

Filter subjects with missing covariates.




### PC-PTSD


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.837|     0.085|    -2.101|   0.036|
|Unadjusted |fmssZ                            |     0.805|     0.086|    -2.535|   0.011|
|Adjusted   |(Intercept)                      |     0.816|     0.185|    -1.098|   0.272|
|Adjusted   |fmssZ                            |     0.827|     0.093|    -2.050|   0.040|
|Adjusted   |countSocialMediaExclFB           |     1.074|     0.094|     0.755|   0.450|
|Adjusted   |comm_inpersonOnce a week         |     0.792|     0.312|    -0.746|   0.456|
|Adjusted   |comm_inpersonA few times a week  |     0.530|     0.261|    -2.428|   0.015|
|Adjusted   |comm_inpersonOnce a day          |     0.547|     0.333|    -1.812|   0.070|
|Adjusted   |comm_inpersonSeveral times a day |     0.394|     0.239|    -3.900|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.114|     0.198|     3.783|   0.000|
|Adjusted   |countSuicideAttempts             |     1.675|     0.161|     3.203|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       783.008|     567| -388.240| 780.480| 789.164|  776.480|         566|
|Adjusted   |       783.008|     567| -352.488| 722.976| 762.055|  704.976|         559|


### PHQ-2


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.379|     0.095|   -10.232|   0.000|
|Unadjusted |fmssZ                            |     0.770|     0.096|    -2.713|   0.007|
|Adjusted   |(Intercept)                      |     0.354|     0.205|    -5.080|   0.000|
|Adjusted   |fmssZ                            |     0.814|     0.102|    -2.008|   0.045|
|Adjusted   |countSocialMediaExclFB           |     0.958|     0.105|    -0.405|   0.686|
|Adjusted   |comm_inpersonOnce a week         |     0.738|     0.314|    -0.967|   0.333|
|Adjusted   |comm_inpersonA few times a week  |     0.362|     0.301|    -3.380|   0.001|
|Adjusted   |comm_inpersonOnce a day          |     0.420|     0.401|    -2.165|   0.030|
|Adjusted   |comm_inpersonSeveral times a day |     0.399|     0.264|    -3.481|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.098|     0.222|     5.087|   0.000|
|Adjusted   |countSuicideAttempts             |     1.245|     0.124|     1.764|   0.078|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       672.272|     568| -332.363| 668.726| 677.413|  664.726|         567|
|Adjusted   |       672.272|     568| -297.957| 613.914| 653.009|  595.914|         560|


### AUDIT-C


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.703|     0.085|    -4.137|   0.000|
|Unadjusted |fmssZ                            |     0.967|     0.085|    -0.400|   0.689|
|Adjusted   |(Intercept)                      |     0.691|     0.182|    -2.037|   0.042|
|Adjusted   |fmssZ                            |     0.981|     0.087|    -0.217|   0.828|
|Adjusted   |countSocialMediaExclFB           |     1.071|     0.089|     0.772|   0.440|
|Adjusted   |comm_inpersonOnce a week         |     1.323|     0.292|     0.956|   0.339|
|Adjusted   |comm_inpersonA few times a week  |     0.931|     0.248|    -0.288|   0.773|
|Adjusted   |comm_inpersonOnce a day          |     0.810|     0.325|    -0.651|   0.515|
|Adjusted   |comm_inpersonSeveral times a day |     0.680|     0.228|    -1.691|   0.091|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.309|     0.192|     1.403|   0.161|
|Adjusted   |countSuicideAttempts             |     0.875|     0.123|    -1.087|   0.277|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       768.654|     566| -384.247| 772.494| 781.175|  768.494|         565|
|Adjusted   |       768.654|     566| -379.540| 777.081| 816.144|  759.081|         558|


### DSI-SS


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.280|     0.103|   -12.364|   0.000|
|Unadjusted |fmssZ                            |     0.732|     0.105|    -2.981|   0.003|
|Adjusted   |(Intercept)                      |     0.124|     0.256|    -8.161|   0.000|
|Adjusted   |fmssZ                            |     0.751|     0.114|    -2.514|   0.012|
|Adjusted   |countSocialMediaExclFB           |     1.047|     0.110|     0.414|   0.679|
|Adjusted   |comm_inpersonOnce a week         |     0.850|     0.342|    -0.476|   0.634|
|Adjusted   |comm_inpersonA few times a week  |     0.668|     0.319|    -1.266|   0.205|
|Adjusted   |comm_inpersonOnce a day          |     0.603|     0.457|    -1.107|   0.268|
|Adjusted   |comm_inpersonSeveral times a day |     0.595|     0.295|    -1.757|   0.079|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.491|     0.256|     6.664|   0.000|
|Adjusted   |countSuicideAttempts             |     1.295|     0.123|     2.102|   0.036|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       604.194|     568| -297.503| 599.006| 607.694|  595.006|         567|
|Adjusted   |       604.194|     568| -254.388| 526.776| 565.871|  508.776|         560|


## Additional questions

> Some issues that additional analysis could clarify is whether people have a
> tendency to substitute social contact on social media for in-person social
> contact, and whether that substitution is bad for your emotional well-being.
> It would be interesting to look at:
> 
> * Do people who spend a lot of time (or frequently use) Facebook spend less
>   time meeting up in-person (i.e., possibly substitute one form of social
>   contact for another)? Variables: `comm_facebook`, `fb_freq`, `comm_inperson`
> * Do people who spend a lot of time (or frequently use) Facebook and spend
>   less time in-person have higher risk for psychiatric disorders?


```
## $table
##                  fb_freq
## comm_facebook     Less than daily Daily or more Sum
##   Less than daily              59           170 229
##   Daily or more                 2           354 356
##   Sum                          61           524 585
## 
## $expected
##                  fb_freq
## comm_facebook     Less than daily Daily or more
##   Less than daily        23.87863      205.1214
##   Daily or more          37.12137      318.8786
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  T
## X-squared = 92.089, df = 1, p-value < 2.2e-16
```

```
## $table
##                  comm_inperson
## comm_facebook     Less than daily Daily or more Sum
##   Less than daily             162            66 228
##   Daily or more               191           167 358
##   Sum                         353           233 586
## 
## $expected
##                  comm_inperson
## comm_facebook     Less than daily Daily or more
##   Less than daily        137.3447      90.65529
##   Daily or more          215.6553     142.34471
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  T
## X-squared = 17.489, df = 1, p-value = 2.89e-05
```

```
## $table
##                  comm_inperson
## fb_freq           Less than daily Daily or more Sum
##   Less than daily              37            23  60
##   Daily or more               314           210 524
##   Sum                         351           233 584
## 
## $expected
##                  comm_inperson
## fb_freq           Less than daily Daily or more
##   Less than daily        36.06164      23.93836
##   Daily or more         314.93836     209.06164
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  T
## X-squared = 0.014885, df = 1, p-value = 0.9029
```


```
## $table
##              comm_facebook
## comm_inperson Daily or more Less than daily Sum
##           A             132              43 175
##           B              35              23  58
##           C              67              47 114
##           D              39              31  70
##           E              85              84 169
##           Sum           358             228 586
## 
## $expected
##              comm_facebook
## comm_inperson Daily or more Less than daily
##             A     106.91126        68.08874
##             B      35.43345        22.56655
##             C      69.64505        44.35495
##             D      42.76451        27.23549
##             E     103.24573        65.75427
## 
## $residual
##              comm_facebook
## comm_inperson Daily or more Less than daily
##             A    2.42642612     -3.04047308
##             B   -0.07281643      0.09124383
##             C   -0.31694868      0.39715775
##             D   -0.57566015      0.72134040
##             E   -1.79566483      2.25008729
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 24.543, df = 4, p-value = 6.216e-05
```

![plot of chunk unnamed-chunk-39](../figures/unnamed-chunk-39-1.png)

## FMSS items

Closely exam FMSS items 1, 2, 3, and 11

* `fmss_r1` For you, how good is Facebook for getting real help or support?
* `fmss_r2` For the support you get on Facebook, how much practical help is it?
* `fmss_r3` How much does the support you get on Facebook make you feel better?
* `fmss_r11` How close to people does Facebook make you feel?


```
## $table
##        fmss_r1
## indPHQ  Not at all A little Somewhat Very or Extremely Sum
##   FALSE        146      161       88                25 420
##   TRUE          61       55       33                15 164
##   Sum          207      216      121                40 584
## 
## $expected
##        fmss_r1
## indPHQ  Not at all  A little Somewhat Very or Extremely
##   FALSE  148.86986 155.34247 87.02055          28.76712
##   TRUE    58.13014  60.65753 33.97945          11.23288
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 2.7267, df = 3, p-value = 0.4357
```

```
## $table
##        fmss_r2
## indPHQ  None A little Some Quite a bit or A lot Sum
##   FALSE  132      160   93                   34 419
##   TRUE    59       58   27                   20 164
##   Sum    191      218  120                   54 583
## 
## $expected
##        fmss_r2
## indPHQ       None  A little     Some Quite a bit or A lot
##   FALSE 137.27101 156.67581 86.24357             38.80961
##   TRUE   53.72899  61.32419 33.75643             15.19039
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 4.9707, df = 3, p-value = 0.174
```

```
## $table
##        fmss_r3
## indPHQ  Not at all A little Somewhat Quite a bit or A lot Sum
##   FALSE        132      149       87                   51 419
##   TRUE          58       57       33                   16 164
##   Sum          190      206      120                   67 583
## 
## $expected
##        fmss_r3
## indPHQ  Not at all  A little Somewhat Quite a bit or A lot
##   FALSE  136.55232 148.05146 86.24357             48.15266
##   TRUE    53.44768  57.94854 33.75643             18.84734
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 1.1832, df = 3, p-value = 0.757
```

```
## $table
##        fmss_r11
## indPHQ  Not at all A little Somewhat Very or Extremely Sum
##   FALSE         77      192      126                26 421
##   TRUE          49       53       56                 6 164
##   Sum          126      245      182                32 585
## 
## $expected
##        fmss_r11
## indPHQ  Not at all  A little  Somewhat Very or Extremely
##   FALSE   90.67692 176.31624 130.97778          23.02906
##   TRUE    35.32308  68.68376  51.02222           8.97094
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 14.377, df = 3, p-value = 0.002434
```

```
## $table
##         fmss_r1
## indDSISS Not at all A little Somewhat Very or Extremely Sum
##    FALSE        157      164       98                33 452
##    TRUE          51       50       23                 7 131
##    Sum          208      214      121                40 583
## 
## $expected
##         fmss_r1
## indDSISS Not at all  A little Somewhat Very or Extremely
##    FALSE  161.26244 165.91424 93.81132         31.012007
##    TRUE    46.73756  48.08576 27.18868          8.987993
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 1.9992, df = 3, p-value = 0.5726
```

```
## $table
##         fmss_r2
## indDSISS None A little Some Quite a bit or A lot Sum
##    FALSE  148      159  101                   43 451
##    TRUE    43       58   19                   11 131
##    Sum    191      217  120                   54 582
## 
## $expected
##         fmss_r2
## indDSISS      None  A little     Some Quite a bit or A lot
##    FALSE 148.00859 168.15636 92.98969             41.84536
##    TRUE   42.99141  48.84364 27.01031             12.15464
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 5.4222, df = 3, p-value = 0.1434
```

```
## $table
##         fmss_r3
## indDSISS Not at all A little Somewhat Quite a bit or A lot Sum
##    FALSE        146      153       92                   59 450
##    TRUE          44       53       27                    8 132
##    Sum          190      206      119                   67 582
## 
## $expected
##         fmss_r3
## indDSISS Not at all  A little Somewhat Quite a bit or A lot
##    FALSE  146.90722 159.27835 92.01031             51.80412
##    TRUE    43.09278  46.72165 26.98969             15.19588
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 5.5229, df = 3, p-value = 0.1373
```

```
## $table
##         fmss_r11
## indDSISS Not at all A little Somewhat Very or Extremely Sum
##    FALSE         94      190      146                22 452
##    TRUE          33       53       36                10 132
##    Sum          127      243      182                32 584
## 
## $expected
##         fmss_r11
## indDSISS Not at all  A little  Somewhat Very or Extremely
##    FALSE   98.29452 188.07534 140.86301         24.767123
##    TRUE    28.70548  54.92466  41.13699          7.232877
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test
## 
## data:  T
## X-squared = 3.1139, df = 3, p-value = 0.3744
```




### PHQ-2


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.406|     0.142|    -6.329|   0.000|
|Unadjusted |fmssSubscore                     |     0.988|     0.034|    -0.355|   0.722|
|Adjusted   |(Intercept)                      |     0.401|     0.224|    -4.079|   0.000|
|Adjusted   |fmssSubscore                     |     0.972|     0.037|    -0.770|   0.441|
|Adjusted   |countSocialMediaExclFB           |     0.921|     0.104|    -0.794|   0.427|
|Adjusted   |comm_inpersonOnce a week         |     0.795|     0.309|    -0.741|   0.459|
|Adjusted   |comm_inpersonA few times a week  |     0.357|     0.299|    -3.450|   0.001|
|Adjusted   |comm_inpersonOnce a day          |     0.453|     0.387|    -2.044|   0.041|
|Adjusted   |comm_inpersonSeveral times a day |     0.388|     0.260|    -3.647|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.212|     0.219|     5.329|   0.000|
|Adjusted   |countSuicideAttempts             |     1.248|     0.125|     1.776|   0.076|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       688.956|     579| -344.415| 692.829| 701.555|  688.829|         578|
|Adjusted   |       688.956|     579| -306.439| 630.877| 670.145|  612.877|         571|


### DSI-SS


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.340|     0.150|    -7.176|   0.000|
|Unadjusted |fmssSubscore                     |     0.949|     0.038|    -1.391|   0.164|
|Adjusted   |(Intercept)                      |     0.171|     0.268|    -6.601|   0.000|
|Adjusted   |fmssSubscore                     |     0.909|     0.042|    -2.273|   0.023|
|Adjusted   |countSocialMediaExclFB           |     1.028|     0.109|     0.253|   0.800|
|Adjusted   |comm_inpersonOnce a week         |     0.803|     0.339|    -0.645|   0.519|
|Adjusted   |comm_inpersonA few times a week  |     0.649|     0.317|    -1.364|   0.173|
|Adjusted   |comm_inpersonOnce a day          |     0.567|     0.454|    -1.251|   0.211|
|Adjusted   |comm_inpersonSeveral times a day |     0.602|     0.289|    -1.755|   0.079|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.832|     0.253|     6.979|   0.000|
|Adjusted   |countSuicideAttempts             |     1.315|     0.123|     2.221|   0.026|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       617.231|     579| -307.628| 619.257| 627.983|  615.257|         578|
|Adjusted   |       617.231|     579| -260.629| 539.259| 578.526|  521.259|         571|


## FMSS quartiles

Stratify by FMSS quartile and compare Q1 vs Q4.


```
## $table
##        fmssQuartile
## indPHQ  Q1: [14,25] Q4: (34,48] Sum
##   FALSE         111          94 205
##   TRUE           63          30  93
##   Sum           174         124 298
## 
## $expected
##        fmssQuartile
## indPHQ  Q1: [14,25] Q4: (34,48]
##   FALSE   119.69799    85.30201
##   TRUE     54.30201    38.69799
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  T
## X-squared = 4.3237, df = 1, p-value = 0.03759
```

```
## $table
##         fmssQuartile
## indDSISS Q1: [14,25] Q4: (34,48] Sum
##    FALSE         127         104 231
##    TRUE           47          20  67
##    Sum           174         124 298
## 
## $expected
##         fmssQuartile
## indDSISS Q1: [14,25] Q4: (34,48]
##    FALSE   134.87919    96.12081
##    TRUE     39.12081    27.87919
## 
## $chisq.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  T
## X-squared = 4.3153, df = 1, p-value = 0.03777
```




### PHQ-2


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.568|     0.158|    -3.591|   0.000|
|Unadjusted |fmssQuartileQ4: (34,48]          |     0.562|     0.262|    -2.194|   0.028|
|Adjusted   |(Intercept)                      |     0.419|     0.287|    -3.032|   0.002|
|Adjusted   |fmssQuartileQ4: (34,48]          |     0.591|     0.287|    -1.836|   0.066|
|Adjusted   |countSocialMediaExclFB           |     0.946|     0.139|    -0.403|   0.687|
|Adjusted   |comm_inpersonOnce a week         |     1.269|     0.419|     0.568|   0.570|
|Adjusted   |comm_inpersonA few times a week  |     0.336|     0.419|    -2.606|   0.009|
|Adjusted   |comm_inpersonOnce a day          |     0.576|     0.537|    -1.028|   0.304|
|Adjusted   |comm_inpersonSeveral times a day |     0.603|     0.350|    -1.446|   0.148|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.084|     0.301|     3.747|   0.000|
|Adjusted   |countSuicideAttempts             |     1.170|     0.157|     1.001|   0.317|

\newline


|model      | null.deviance| df.null|  logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|-------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       369.970|     297| -182.51| 369.019| 376.413|  365.019|         296|
|Adjusted   |       366.891|     295| -162.91| 343.820| 377.033|  325.820|         287|


### DSI-SS


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.370|     0.171|    -5.822|   0.000|
|Unadjusted |fmssQuartileQ4: (34,48]          |     0.520|     0.298|    -2.197|   0.028|
|Adjusted   |(Intercept)                      |     0.158|     0.366|    -5.047|   0.000|
|Adjusted   |fmssQuartileQ4: (34,48]          |     0.524|     0.337|    -1.918|   0.055|
|Adjusted   |countSocialMediaExclFB           |     0.976|     0.157|    -0.155|   0.877|
|Adjusted   |comm_inpersonOnce a week         |     0.716|     0.465|    -0.718|   0.473|
|Adjusted   |comm_inpersonA few times a week  |     0.523|     0.440|    -1.475|   0.140|
|Adjusted   |comm_inpersonOnce a day          |     0.736|     0.609|    -0.503|   0.615|
|Adjusted   |comm_inpersonSeveral times a day |     0.385|     0.435|    -2.191|   0.028|
|Adjusted   |indSuicideConsideredEverTRUE     |     7.312|     0.378|     5.265|   0.000|
|Adjusted   |countSuicideAttempts             |     1.134|     0.156|     0.801|   0.423|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       317.642|     297| -156.291| 316.581| 323.975|  312.581|         296|
|Adjusted   |       314.645|     296| -129.592| 277.183| 310.427|  259.183|         288|
# Research Question 2

**Are certains features of social media use are associated with positive screens for psychiatric disorders or a positive screen for suicidality?**

* Spending more time on Facebook?
  * Frequency of Facebook use: `fb_freq`
  * Active use of Facebook: `comm_facebook`
* Sharing more personal or health-related information on social media?
  * Get emotional support from others `sm_emot_support`
  * Get information about health or medical topics `sm_med_info`
  * Get advice about health or medical topics `sm_med_advice`
  * Ask questions about health or medical issues `sm_med_questions`
  * Share symptoms such as mood swings, depression, anxiety, or sleep problems `sm_share_sympt`
  * Share information related to your health `sm_share_health`
  * Share thoughts about suicide or hurting yourself in some way `sm_share_suicide`
  
  
## Association between frequency of Facebook use and active use of Facebook

Correlation (Spearman) between frequency of Facebook use and active use of Facebook is
0.457


## Unadjusted comparisons



![plot of chunk plotRQ2](../figures/plotRQ2-1.png)![plot of chunk plotRQ2](../figures/plotRQ2-2.png)![plot of chunk plotRQ2](../figures/plotRQ2-3.png)![plot of chunk plotRQ2](../figures/plotRQ2-4.png)![plot of chunk plotRQ2](../figures/plotRQ2-5.png)![plot of chunk plotRQ2](../figures/plotRQ2-6.png)![plot of chunk plotRQ2](../figures/plotRQ2-7.png)![plot of chunk plotRQ2](../figures/plotRQ2-8.png)![plot of chunk plotRQ2](../figures/plotRQ2-9.png)


## Adjusted comparisons



Show the covariates used in the adjusted models.


```r
covar <- c("countSocialMediaExclFB",
           "comm_inperson",
           "indSuicideConsideredEver",
           "countSuicideAttempts")
```

Filter subjects with missing covariates.



Relabel factors; replace spaces with underscores.




### PC-PTSD vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.260|   5| 575|  0.280|
|Adjusted   | 1.421|   5| 568|  0.215|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.429|     0.690|    -1.228|   0.220|
|Unadjusted |fb_freqEvery_few_weeks           |     2.333|     1.215|     0.697|   0.486|
|Unadjusted |fb_freqOnce_a_week               |     1.167|     1.107|     0.139|   0.889|
|Unadjusted |fb_freqA_few_times_a_week        |     2.722|     0.761|     1.316|   0.188|
|Unadjusted |fb_freqOnce_a_day                |     2.917|     0.730|     1.467|   0.142|
|Unadjusted |fb_freqSeveral_times_a_day       |     1.768|     0.697|     0.818|   0.413|
|Adjusted   |(Intercept)                      |     0.498|     0.722|    -0.965|   0.335|
|Adjusted   |fb_freqEvery_few_weeks           |     2.182|     1.291|     0.604|   0.546|
|Adjusted   |fb_freqOnce_a_week               |     0.864|     1.133|    -0.129|   0.897|
|Adjusted   |fb_freqA_few_times_a_week        |     2.928|     0.783|     1.372|   0.170|
|Adjusted   |fb_freqOnce_a_day                |     2.497|     0.753|     1.215|   0.224|
|Adjusted   |fb_freqSeveral_times_a_day       |     1.525|     0.715|     0.590|   0.555|
|Adjusted   |countSocialMediaExclFB           |     1.081|     0.092|     0.841|   0.400|
|Adjusted   |comm_inpersonOnce a week         |     0.785|     0.311|    -0.777|   0.437|
|Adjusted   |comm_inpersonA few times a week  |     0.482|     0.263|    -2.778|   0.005|
|Adjusted   |comm_inpersonOnce a day          |     0.475|     0.329|    -2.261|   0.024|
|Adjusted   |comm_inpersonSeveral times a day |     0.388|     0.236|    -4.010|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.112|     0.197|     3.799|   0.000|
|Adjusted   |countSuicideAttempts             |     1.687|     0.165|     3.171|   0.002|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       799.836|     580| -396.710| 805.421| 831.609|  793.421|         575|
|Adjusted   |       799.836|     580| -359.238| 744.477| 801.219|  718.477|         568|


### PC-PTSD vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.410|   4| 578|  0.229|
|Adjusted   | 1.179|   4| 571|  0.319|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     1.059|     0.239|     0.239|   0.811|
|Unadjusted |comm_facebookOnce_a_week         |     1.102|     0.400|     0.242|   0.809|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.928|     0.302|    -0.246|   0.806|
|Unadjusted |comm_facebookOnce_a_day          |     0.787|     0.313|    -0.765|   0.444|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.638|     0.271|    -1.661|   0.097|
|Adjusted   |(Intercept)                      |     0.966|     0.281|    -0.125|   0.901|
|Adjusted   |comm_facebookOnce_a_week         |     1.128|     0.430|     0.281|   0.779|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.934|     0.324|    -0.210|   0.834|
|Adjusted   |comm_facebookOnce_a_day          |     0.925|     0.337|    -0.233|   0.816|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.652|     0.298|    -1.439|   0.150|
|Adjusted   |countSocialMediaExclFB           |     1.096|     0.093|     0.987|   0.324|
|Adjusted   |comm_inpersonOnce a week         |     0.781|     0.310|    -0.797|   0.425|
|Adjusted   |comm_inpersonA few times a week  |     0.512|     0.261|    -2.564|   0.010|
|Adjusted   |comm_inpersonOnce a day          |     0.495|     0.330|    -2.134|   0.033|
|Adjusted   |comm_inpersonSeveral times a day |     0.431|     0.240|    -3.508|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.134|     0.197|     3.846|   0.000|
|Adjusted   |countSuicideAttempts             |     1.738|     0.166|     3.338|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.013|     582| -398.671| 807.342| 829.183|  797.342|         578|
|Adjusted   |       803.013|     582| -361.361| 746.721| 799.139|  722.721|         571|


### PC-PTSD vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.202|   4| 578|  0.309|
|Adjusted   | 1.290|   4| 571|  0.273|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.699|     0.141|    -2.546|   0.011|
|Unadjusted |sm_emot_supportRarely            |     1.525|     0.203|     2.081|   0.037|
|Unadjusted |sm_emot_supportSometimes         |     1.068|     0.226|     0.291|   0.771|
|Unadjusted |sm_emot_supportUsually           |     1.210|     0.322|     0.593|   0.554|
|Unadjusted |sm_emot_supportAlways            |     1.073|     0.777|     0.090|   0.928|
|Adjusted   |(Intercept)                      |     0.763|     0.202|    -1.339|   0.181|
|Adjusted   |sm_emot_supportRarely            |     1.492|     0.221|     1.809|   0.070|
|Adjusted   |sm_emot_supportSometimes         |     0.918|     0.251|    -0.343|   0.731|
|Adjusted   |sm_emot_supportUsually           |     1.050|     0.357|     0.138|   0.891|
|Adjusted   |sm_emot_supportAlways            |     0.791|     0.860|    -0.272|   0.786|
|Adjusted   |countSocialMediaExclFB           |     1.066|     0.095|     0.678|   0.498|
|Adjusted   |comm_inpersonOnce a week         |     0.778|     0.311|    -0.807|   0.420|
|Adjusted   |comm_inpersonA few times a week  |     0.492|     0.262|    -2.706|   0.007|
|Adjusted   |comm_inpersonOnce a day          |     0.505|     0.329|    -2.079|   0.038|
|Adjusted   |comm_inpersonSeveral times a day |     0.377|     0.237|    -4.120|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.051|     0.197|     3.654|   0.000|
|Adjusted   |countSuicideAttempts             |     1.746|     0.167|     3.336|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.013|     582| -399.095| 808.191| 830.032|  798.191|         578|
|Adjusted   |       803.013|     582| -361.142| 746.284| 798.703|  722.284|         571|


### PC-PTSD vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.291|   4| 577|  0.272|
|Adjusted   | 1.491|   4| 570|  0.203|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.872|     0.166|    -0.827|   0.408|
|Unadjusted |sm_med_infoRarely                |     0.737|     0.226|    -1.354|   0.176|
|Unadjusted |sm_med_infoSometimes             |     1.095|     0.225|     0.402|   0.687|
|Unadjusted |sm_med_infoUsually               |     1.221|     0.300|     0.665|   0.506|
|Unadjusted |sm_med_infoAlways                |     0.706|     0.479|    -0.727|   0.467|
|Adjusted   |(Intercept)                      |     0.975|     0.235|    -0.110|   0.913|
|Adjusted   |sm_med_infoRarely                |     0.630|     0.244|    -1.894|   0.058|
|Adjusted   |sm_med_infoSometimes             |     1.018|     0.246|     0.074|   0.941|
|Adjusted   |sm_med_infoUsually               |     1.011|     0.331|     0.034|   0.973|
|Adjusted   |sm_med_infoAlways                |     0.659|     0.538|    -0.777|   0.437|
|Adjusted   |countSocialMediaExclFB           |     1.064|     0.096|     0.646|   0.518|
|Adjusted   |comm_inpersonOnce a week         |     0.799|     0.310|    -0.724|   0.469|
|Adjusted   |comm_inpersonA few times a week  |     0.505|     0.261|    -2.614|   0.009|
|Adjusted   |comm_inpersonOnce a day          |     0.510|     0.331|    -2.038|   0.042|
|Adjusted   |comm_inpersonSeveral times a day |     0.380|     0.237|    -4.086|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.065|     0.196|     3.696|   0.000|
|Adjusted   |countSuicideAttempts             |     1.727|     0.164|     3.324|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       801.427|     581| -398.107| 806.215| 828.047|  796.215|         577|
|Adjusted   |       801.427|     581| -360.415| 744.831| 797.229|  720.831|         570|


### PC-PTSD vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.913|   4| 578|  0.107|
|Adjusted   | 1.981|   4| 571|  0.096|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.766|     0.134|    -1.990|   0.047|
|Unadjusted |sm_med_adviceRarely              |     0.980|     0.203|    -0.101|   0.919|
|Unadjusted |sm_med_adviceSometimes           |     1.287|     0.219|     1.149|   0.250|
|Unadjusted |sm_med_adviceUsually             |     2.052|     0.367|     1.958|   0.050|
|Unadjusted |sm_med_adviceAlways              |     0.392|     0.672|    -1.395|   0.163|
|Adjusted   |(Intercept)                      |     0.822|     0.206|    -0.948|   0.343|
|Adjusted   |sm_med_adviceRarely              |     0.878|     0.221|    -0.588|   0.556|
|Adjusted   |sm_med_adviceSometimes           |     1.266|     0.238|     0.991|   0.322|
|Adjusted   |sm_med_adviceUsually             |     1.747|     0.396|     1.408|   0.159|
|Adjusted   |sm_med_adviceAlways              |     0.240|     0.788|    -1.813|   0.070|
|Adjusted   |countSocialMediaExclFB           |     1.064|     0.095|     0.654|   0.513|
|Adjusted   |comm_inpersonOnce a week         |     0.777|     0.310|    -0.815|   0.415|
|Adjusted   |comm_inpersonA few times a week  |     0.497|     0.262|    -2.665|   0.008|
|Adjusted   |comm_inpersonOnce a day          |     0.490|     0.331|    -2.152|   0.031|
|Adjusted   |comm_inpersonSeveral times a day |     0.389|     0.236|    -3.993|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.082|     0.197|     3.731|   0.000|
|Adjusted   |countSuicideAttempts             |     1.738|     0.164|     3.377|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.013|     582| -397.428| 804.855| 826.696|  794.855|         578|
|Adjusted   |       803.013|     582| -359.326| 742.651| 795.070|  718.651|         571|


### PC-PTSD vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.226|   4| 578|  0.065|
|Adjusted   | 1.171|   4| 571|  0.323|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.713|     0.124|    -2.731|   0.006|
|Unadjusted |sm_med_questionsRarely           |     1.107|     0.198|     0.512|   0.609|
|Unadjusted |sm_med_questionsSometimes        |     1.321|     0.234|     1.187|   0.235|
|Unadjusted |sm_med_questionsUsually          |     3.084|     0.401|     2.809|   0.005|
|Unadjusted |sm_med_questionsAlways           |     1.682|     0.618|     0.841|   0.400|
|Adjusted   |(Intercept)                      |     0.759|     0.201|    -1.377|   0.169|
|Adjusted   |sm_med_questionsRarely           |     1.057|     0.215|     0.258|   0.797|
|Adjusted   |sm_med_questionsSometimes        |     1.321|     0.250|     1.113|   0.266|
|Adjusted   |sm_med_questionsUsually          |     2.333|     0.431|     1.965|   0.049|
|Adjusted   |sm_med_questionsAlways           |     1.220|     0.689|     0.288|   0.773|
|Adjusted   |countSocialMediaExclFB           |     1.041|     0.094|     0.423|   0.672|
|Adjusted   |comm_inpersonOnce a week         |     0.799|     0.310|    -0.724|   0.469|
|Adjusted   |comm_inpersonA few times a week  |     0.518|     0.261|    -2.519|   0.012|
|Adjusted   |comm_inpersonOnce a day          |     0.474|     0.329|    -2.266|   0.023|
|Adjusted   |comm_inpersonSeveral times a day |     0.402|     0.235|    -3.873|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.047|     0.196|     3.656|   0.000|
|Adjusted   |countSuicideAttempts             |     1.701|     0.165|     3.210|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.013|     582| -396.748| 803.496| 825.337|  793.496|         578|
|Adjusted   |       803.013|     582| -361.314| 746.628| 799.046|  722.628|         571|


### PC-PTSD vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 5.179|   4| 577|   0.00|
|Adjusted   | 2.277|   4| 570|   0.06|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.676|     0.116|    -3.386|   0.001|
|Unadjusted |sm_share_symptRarely             |     1.048|     0.201|     0.231|   0.817|
|Unadjusted |sm_share_symptSometimes          |     2.108|     0.255|     2.925|   0.003|
|Unadjusted |sm_share_symptUsually            |     4.863|     0.447|     3.539|   0.000|
|Unadjusted |sm_share_symptAlways             |     2.220|     0.656|     1.216|   0.224|
|Adjusted   |(Intercept)                      |     0.763|     0.192|    -1.407|   0.159|
|Adjusted   |sm_share_symptRarely             |     0.862|     0.222|    -0.669|   0.504|
|Adjusted   |sm_share_symptSometimes          |     1.499|     0.277|     1.461|   0.144|
|Adjusted   |sm_share_symptUsually            |     3.066|     0.471|     2.378|   0.017|
|Adjusted   |sm_share_symptAlways             |     1.137|     0.724|     0.178|   0.859|
|Adjusted   |countSocialMediaExclFB           |     1.066|     0.094|     0.676|   0.499|
|Adjusted   |comm_inpersonOnce a week         |     0.859|     0.314|    -0.485|   0.628|
|Adjusted   |comm_inpersonA few times a week  |     0.552|     0.263|    -2.260|   0.024|
|Adjusted   |comm_inpersonOnce a day          |     0.514|     0.331|    -2.015|   0.044|
|Adjusted   |comm_inpersonSeveral times a day |     0.421|     0.237|    -3.642|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.973|     0.201|     3.382|   0.001|
|Adjusted   |countSuicideAttempts             |     1.673|     0.168|     3.053|   0.002|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       801.806|     581| -389.405| 788.810| 810.642|  778.810|         577|
|Adjusted   |       801.806|     581| -358.486| 740.972| 793.370|  716.972|         570|


### PC-PTSD vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.612|   4| 577|  0.006|
|Adjusted   | 2.077|   4| 570|  0.082|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.681|     0.122|    -3.154|   0.002|
|Unadjusted |sm_share_healthRarely            |     1.215|     0.187|     1.043|   0.297|
|Unadjusted |sm_share_healthSometimes         |     1.553|     0.265|     1.658|   0.097|
|Unadjusted |sm_share_healthUsually           |     9.304|     0.633|     3.523|   0.000|
|Unadjusted |sm_share_healthAlways            |     0.881|     0.740|    -0.170|   0.865|
|Adjusted   |(Intercept)                      |     0.781|     0.198|    -1.250|   0.211|
|Adjusted   |sm_share_healthRarely            |     0.966|     0.202|    -0.172|   0.863|
|Adjusted   |sm_share_healthSometimes         |     1.121|     0.294|     0.390|   0.696|
|Adjusted   |sm_share_healthUsually           |     5.375|     0.658|     2.554|   0.011|
|Adjusted   |sm_share_healthAlways            |     0.362|     0.904|    -1.122|   0.262|
|Adjusted   |countSocialMediaExclFB           |     1.063|     0.094|     0.650|   0.516|
|Adjusted   |comm_inpersonOnce a week         |     0.842|     0.313|    -0.550|   0.582|
|Adjusted   |comm_inpersonA few times a week  |     0.548|     0.262|    -2.290|   0.022|
|Adjusted   |comm_inpersonOnce a day          |     0.517|     0.331|    -1.992|   0.046|
|Adjusted   |comm_inpersonSeveral times a day |     0.407|     0.238|    -3.777|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.995|     0.200|     3.455|   0.001|
|Adjusted   |countSuicideAttempts             |     1.752|     0.170|     3.300|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       801.427|     581| -390.681| 791.361| 813.194|  781.361|         577|
|Adjusted   |       801.427|     581| -357.022| 738.045| 790.442|  714.045|         570|


### PC-PTSD vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 6.197|   4| 576|  0.000|
|Adjusted   | 4.201|   4| 569|  0.002|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.696|     0.091|    -3.970|   0.000|
|Unadjusted |sm_share_suicideRarely           |     3.032|     0.300|     3.694|   0.000|
|Unadjusted |sm_share_suicideSometimes        |     5.745|     0.652|     2.682|   0.007|
|Unadjusted |sm_share_suicideUsually          |    11.490|     1.065|     2.293|   0.022|
|Unadjusted |sm_share_suicideAlways           |     1.436|     1.004|     0.361|   0.718|
|Adjusted   |(Intercept)                      |     0.786|     0.187|    -1.288|   0.198|
|Adjusted   |sm_share_suicideRarely           |     2.579|     0.322|     2.938|   0.003|
|Adjusted   |sm_share_suicideSometimes        |     3.707|     0.686|     1.910|   0.056|
|Adjusted   |sm_share_suicideUsually          |    10.643|     1.083|     2.184|   0.029|
|Adjusted   |sm_share_suicideAlways           |     0.393|     1.257|    -0.742|   0.458|
|Adjusted   |countSocialMediaExclFB           |     1.061|     0.094|     0.629|   0.530|
|Adjusted   |comm_inpersonOnce a week         |     0.762|     0.313|    -0.869|   0.385|
|Adjusted   |comm_inpersonA few times a week  |     0.479|     0.266|    -2.765|   0.006|
|Adjusted   |comm_inpersonOnce a day          |     0.502|     0.332|    -2.077|   0.038|
|Adjusted   |comm_inpersonSeveral times a day |     0.379|     0.239|    -4.050|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.852|     0.200|     3.086|   0.002|
|Adjusted   |countSuicideAttempts             |     1.755|     0.169|     3.333|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       800.596|     580| -385.065| 780.130| 801.954|  770.130|         576|
|Adjusted   |       800.596|     580| -352.654| 729.308| 781.685|  705.308|         569|


### PHQ-2 vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.525|   5| 576|  0.757|
|Adjusted   | 0.389|   5| 569|  0.856|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.111|     1.054|    -2.084|   0.037|
|Unadjusted |fb_freqEvery_few_weeks           |     0.000|   441.373|    -0.028|   0.978|
|Unadjusted |fb_freqOnce_a_week               |     4.500|     1.364|     1.103|   0.270|
|Unadjusted |fb_freqA_few_times_a_week        |     3.536|     1.113|     1.135|   0.256|
|Unadjusted |fb_freqOnce_a_day                |     4.500|     1.083|     1.388|   0.165|
|Unadjusted |fb_freqSeveral_times_a_day       |     3.375|     1.059|     1.148|   0.251|
|Adjusted   |(Intercept)                      |     0.122|     1.087|    -1.938|   0.053|
|Adjusted   |fb_freqEvery_few_weeks           |     0.000|   650.476|    -0.021|   0.983|
|Adjusted   |fb_freqOnce_a_week               |     3.437|     1.392|     0.887|   0.375|
|Adjusted   |fb_freqA_few_times_a_week        |     3.692|     1.139|     1.147|   0.251|
|Adjusted   |fb_freqOnce_a_day                |     3.930|     1.109|     1.234|   0.217|
|Adjusted   |fb_freqSeveral_times_a_day       |     3.107|     1.080|     1.049|   0.294|
|Adjusted   |countSocialMediaExclFB           |     0.905|     0.104|    -0.961|   0.337|
|Adjusted   |comm_inpersonOnce a week         |     0.781|     0.312|    -0.791|   0.429|
|Adjusted   |comm_inpersonA few times a week  |     0.313|     0.307|    -3.782|   0.000|
|Adjusted   |comm_inpersonOnce a day          |     0.437|     0.387|    -2.136|   0.033|
|Adjusted   |comm_inpersonSeveral times a day |     0.373|     0.260|    -3.787|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.132|     0.220|     5.185|   0.000|
|Adjusted   |countSuicideAttempts             |     1.220|     0.127|     1.565|   0.118|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       686.463|     581| -340.364| 692.728| 718.927|  680.728|         576|
|Adjusted   |       686.463|     581| -302.813| 631.626| 688.390|  605.626|         569|


### PHQ-2 vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.482|   4| 579|  0.749|
|Adjusted   | 0.471|   4| 572|  0.757|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.489|     0.254|    -2.808|   0.005|
|Unadjusted |comm_facebookOnce_a_week         |     1.022|     0.424|     0.051|   0.960|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.705|     0.331|    -1.057|   0.290|
|Unadjusted |comm_facebookOnce_a_day          |     0.806|     0.338|    -0.638|   0.524|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.742|     0.291|    -1.026|   0.305|
|Adjusted   |(Intercept)                      |     0.431|     0.305|    -2.754|   0.006|
|Adjusted   |comm_facebookOnce_a_week         |     1.063|     0.465|     0.131|   0.896|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.679|     0.360|    -1.074|   0.283|
|Adjusted   |comm_facebookOnce_a_day          |     0.929|     0.372|    -0.199|   0.842|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.808|     0.324|    -0.657|   0.511|
|Adjusted   |countSocialMediaExclFB           |     0.919|     0.104|    -0.814|   0.416|
|Adjusted   |comm_inpersonOnce a week         |     0.794|     0.311|    -0.740|   0.459|
|Adjusted   |comm_inpersonA few times a week  |     0.358|     0.300|    -3.429|   0.001|
|Adjusted   |comm_inpersonOnce a day          |     0.429|     0.387|    -2.187|   0.029|
|Adjusted   |comm_inpersonSeveral times a day |     0.397|     0.266|    -3.474|   0.001|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.268|     0.221|     5.367|   0.000|
|Adjusted   |countSuicideAttempts             |     1.239|     0.126|     1.700|   0.089|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       691.585|     583| -344.845| 699.691| 721.540|  689.691|         579|
|Adjusted   |       691.585|     583| -306.816| 637.632| 690.071|  613.632|         572|


### PHQ-2 vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.990|   4| 579|  0.412|
|Adjusted   | 0.789|   4| 572|  0.533|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.338|     0.159|    -6.836|   0.000|
|Unadjusted |sm_emot_supportRarely            |     1.225|     0.226|     0.899|   0.369|
|Unadjusted |sm_emot_supportSometimes         |     1.256|     0.248|     0.916|   0.359|
|Unadjusted |sm_emot_supportUsually           |     0.987|     0.369|    -0.034|   0.973|
|Unadjusted |sm_emot_supportAlways            |     3.950|     0.780|     1.761|   0.078|
|Adjusted   |(Intercept)                      |     0.344|     0.224|    -4.771|   0.000|
|Adjusted   |sm_emot_supportRarely            |     1.193|     0.249|     0.709|   0.478|
|Adjusted   |sm_emot_supportSometimes         |     1.211|     0.278|     0.690|   0.490|
|Adjusted   |sm_emot_supportUsually           |     0.929|     0.407|    -0.182|   0.856|
|Adjusted   |sm_emot_supportAlways            |     3.849|     0.851|     1.584|   0.113|
|Adjusted   |countSocialMediaExclFB           |     0.909|     0.106|    -0.903|   0.367|
|Adjusted   |comm_inpersonOnce a week         |     0.781|     0.313|    -0.791|   0.429|
|Adjusted   |comm_inpersonA few times a week  |     0.339|     0.300|    -3.600|   0.000|
|Adjusted   |comm_inpersonOnce a day          |     0.415|     0.391|    -2.253|   0.024|
|Adjusted   |comm_inpersonSeveral times a day |     0.371|     0.263|    -3.765|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.097|     0.220|     5.144|   0.000|
|Adjusted   |countSuicideAttempts             |     1.239|     0.128|     1.680|   0.093|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       691.585|     583| -343.808| 697.615| 719.465|  687.615|         579|
|Adjusted   |       691.585|     583| -306.174| 636.347| 688.786|  612.347|         572|


### PHQ-2 vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.870|   4| 578|  0.114|
|Adjusted   | 2.022|   4| 571|  0.090|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.374|     0.185|    -5.309|   0.000|
|Unadjusted |sm_med_infoRarely                |     0.770|     0.258|    -1.014|   0.310|
|Unadjusted |sm_med_infoSometimes             |     1.224|     0.248|     0.817|   0.414|
|Unadjusted |sm_med_infoUsually               |     1.605|     0.318|     1.489|   0.137|
|Unadjusted |sm_med_infoAlways                |     0.629|     0.586|    -0.790|   0.429|
|Adjusted   |(Intercept)                      |     0.374|     0.259|    -3.798|   0.000|
|Adjusted   |sm_med_infoRarely                |     0.709|     0.279|    -1.230|   0.219|
|Adjusted   |sm_med_infoSometimes             |     1.345|     0.273|     1.083|   0.279|
|Adjusted   |sm_med_infoUsually               |     1.539|     0.355|     1.216|   0.224|
|Adjusted   |sm_med_infoAlways                |     0.733|     0.647|    -0.480|   0.631|
|Adjusted   |countSocialMediaExclFB           |     0.880|     0.107|    -1.190|   0.234|
|Adjusted   |comm_inpersonOnce a week         |     0.776|     0.313|    -0.809|   0.419|
|Adjusted   |comm_inpersonA few times a week  |     0.345|     0.302|    -3.524|   0.000|
|Adjusted   |comm_inpersonOnce a day          |     0.446|     0.391|    -2.061|   0.039|
|Adjusted   |comm_inpersonSeveral times a day |     0.363|     0.264|    -3.849|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.146|     0.221|     5.185|   0.000|
|Adjusted   |countSuicideAttempts             |     1.250|     0.126|     1.766|   0.077|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       689.028|     582| -340.729| 691.458| 713.299|  681.458|         578|
|Adjusted   |       689.028|     582| -303.099| 630.198| 682.616|  606.198|         571|


### PHQ-2 vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.053|   4| 579|  0.086|
|Adjusted   | 2.147|   4| 572|  0.074|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.343|     0.152|    -7.028|   0.000|
|Unadjusted |sm_med_adviceRarely              |     0.979|     0.231|    -0.093|   0.926|
|Unadjusted |sm_med_adviceSometimes           |     1.392|     0.240|     1.379|   0.168|
|Unadjusted |sm_med_adviceUsually             |     2.331|     0.368|     2.298|   0.022|
|Unadjusted |sm_med_adviceAlways              |     0.530|     0.784|    -0.811|   0.418|
|Adjusted   |(Intercept)                      |     0.345|     0.228|    -4.662|   0.000|
|Adjusted   |sm_med_adviceRarely              |     0.916|     0.252|    -0.349|   0.727|
|Adjusted   |sm_med_adviceSometimes           |     1.519|     0.263|     1.589|   0.112|
|Adjusted   |sm_med_adviceUsually             |     2.205|     0.407|     1.942|   0.052|
|Adjusted   |sm_med_adviceAlways              |     0.419|     0.857|    -1.015|   0.310|
|Adjusted   |countSocialMediaExclFB           |     0.888|     0.106|    -1.124|   0.261|
|Adjusted   |comm_inpersonOnce a week         |     0.770|     0.313|    -0.834|   0.404|
|Adjusted   |comm_inpersonA few times a week  |     0.339|     0.303|    -3.571|   0.000|
|Adjusted   |comm_inpersonOnce a day          |     0.416|     0.390|    -2.247|   0.025|
|Adjusted   |comm_inpersonSeveral times a day |     0.374|     0.262|    -3.748|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.144|     0.221|     5.189|   0.000|
|Adjusted   |countSuicideAttempts             |     1.260|     0.125|     1.842|   0.065|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       691.585|     583| -341.701| 693.402| 715.252|  683.402|         579|
|Adjusted   |       691.585|     583| -303.356| 630.712| 683.151|  606.712|         572|


### PHQ-2 vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.746|   4| 579|  0.028|
|Adjusted   | 2.065|   4| 572|  0.084|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.317|     0.142|    -8.069|   0.000|
|Unadjusted |sm_med_questionsRarely           |     1.135|     0.225|     0.565|   0.572|
|Unadjusted |sm_med_questionsSometimes        |     1.600|     0.254|     1.850|   0.064|
|Unadjusted |sm_med_questionsUsually          |     3.154|     0.381|     3.014|   0.003|
|Unadjusted |sm_med_questionsAlways           |     1.183|     0.692|     0.243|   0.808|
|Adjusted   |(Intercept)                      |     0.315|     0.224|    -5.145|   0.000|
|Adjusted   |sm_med_questionsRarely           |     1.204|     0.246|     0.754|   0.451|
|Adjusted   |sm_med_questionsSometimes        |     1.697|     0.275|     1.925|   0.054|
|Adjusted   |sm_med_questionsUsually          |     2.702|     0.422|     2.358|   0.018|
|Adjusted   |sm_med_questionsAlways           |     0.762|     0.764|    -0.356|   0.722|
|Adjusted   |countSocialMediaExclFB           |     0.881|     0.106|    -1.194|   0.233|
|Adjusted   |comm_inpersonOnce a week         |     0.761|     0.314|    -0.870|   0.385|
|Adjusted   |comm_inpersonA few times a week  |     0.344|     0.302|    -3.533|   0.000|
|Adjusted   |comm_inpersonOnce a day          |     0.416|     0.389|    -2.256|   0.024|
|Adjusted   |comm_inpersonSeveral times a day |     0.382|     0.262|    -3.671|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.134|     0.220|     5.181|   0.000|
|Adjusted   |countSuicideAttempts             |     1.240|     0.126|     1.710|   0.087|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       691.585|     583| -340.411| 690.822| 712.672|  680.822|         579|
|Adjusted   |       691.585|     583| -303.640| 631.279| 683.718|  607.279|         572|


### PHQ-2 vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 5.983|   4| 578|  0.000|
|Adjusted   | 2.574|   4| 571|  0.037|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.285|     0.136|    -9.195|   0.000|
|Unadjusted |sm_share_symptRarely             |     1.295|     0.228|     1.135|   0.256|
|Unadjusted |sm_share_symptSometimes          |     2.338|     0.266|     3.194|   0.001|
|Unadjusted |sm_share_symptUsually            |     5.261|     0.397|     4.183|   0.000|
|Unadjusted |sm_share_symptAlways             |     1.503|     0.703|     0.579|   0.562|
|Adjusted   |(Intercept)                      |     0.327|     0.213|    -5.247|   0.000|
|Adjusted   |sm_share_symptRarely             |     1.090|     0.251|     0.344|   0.731|
|Adjusted   |sm_share_symptSometimes          |     1.779|     0.292|     1.971|   0.049|
|Adjusted   |sm_share_symptUsually            |     3.128|     0.425|     2.681|   0.007|
|Adjusted   |sm_share_symptAlways             |     0.827|     0.770|    -0.247|   0.805|
|Adjusted   |countSocialMediaExclFB           |     0.905|     0.107|    -0.933|   0.351|
|Adjusted   |comm_inpersonOnce a week         |     0.794|     0.318|    -0.726|   0.468|
|Adjusted   |comm_inpersonA few times a week  |     0.366|     0.302|    -3.322|   0.001|
|Adjusted   |comm_inpersonOnce a day          |     0.434|     0.391|    -2.137|   0.033|
|Adjusted   |comm_inpersonSeveral times a day |     0.393|     0.264|    -3.545|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.888|     0.224|     4.731|   0.000|
|Adjusted   |countSuicideAttempts             |     1.209|     0.127|     1.491|   0.136|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|    BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|------:|--------:|-----------:|
|Unadjusted |        690.93|     582| -333.355| 676.710| 698.55|  666.710|         578|
|Adjusted   |        690.93|     582| -302.471| 628.941| 681.36|  604.941|         571|


### PHQ-2 vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.919|   4| 578|  0.004|
|Adjusted   | 1.739|   4| 571|  0.140|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.308|     0.141|    -8.355|   0.000|
|Unadjusted |sm_share_healthRarely            |     1.380|     0.209|     1.542|   0.123|
|Unadjusted |sm_share_healthSometimes         |     1.427|     0.292|     1.217|   0.224|
|Unadjusted |sm_share_healthUsually           |     5.674|     0.465|     3.733|   0.000|
|Unadjusted |sm_share_healthAlways            |     0.463|     1.078|    -0.714|   0.475|
|Adjusted   |(Intercept)                      |     0.348|     0.218|    -4.835|   0.000|
|Adjusted   |sm_share_healthRarely            |     1.088|     0.227|     0.370|   0.711|
|Adjusted   |sm_share_healthSometimes         |     1.070|     0.324|     0.208|   0.836|
|Adjusted   |sm_share_healthUsually           |     2.995|     0.502|     2.184|   0.029|
|Adjusted   |sm_share_healthAlways            |     0.203|     1.182|    -1.349|   0.177|
|Adjusted   |countSocialMediaExclFB           |     0.908|     0.105|    -0.914|   0.361|
|Adjusted   |comm_inpersonOnce a week         |     0.806|     0.314|    -0.689|   0.491|
|Adjusted   |comm_inpersonA few times a week  |     0.368|     0.302|    -3.313|   0.001|
|Adjusted   |comm_inpersonOnce a day          |     0.443|     0.389|    -2.094|   0.036|
|Adjusted   |comm_inpersonSeveral times a day |     0.401|     0.263|    -3.481|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.979|     0.223|     4.903|   0.000|
|Adjusted   |countSuicideAttempts             |     1.280|     0.130|     1.901|   0.057|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        690.93|     582| -337.184| 684.368| 706.209|  674.368|         578|
|Adjusted   |        690.93|     582| -303.710| 631.420| 683.839|  607.420|         571|


### PHQ-2 vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 7.781|   4| 577|      0|
|Adjusted   | 5.292|   4| 570|      0|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.311|     0.105|   -11.097|   0.000|
|Unadjusted |sm_share_suicideRarely           |     3.220|     0.287|     4.071|   0.000|
|Unadjusted |sm_share_suicideSometimes        |     4.831|     0.537|     2.930|   0.003|
|Unadjusted |sm_share_suicideUsually          |    11.271|     0.809|     2.995|   0.003|
|Unadjusted |sm_share_suicideAlways           |     1.073|     1.159|     0.061|   0.951|
|Adjusted   |(Intercept)                      |     0.344|     0.207|    -5.159|   0.000|
|Adjusted   |sm_share_suicideRarely           |     2.702|     0.315|     3.157|   0.002|
|Adjusted   |sm_share_suicideSometimes        |     3.347|     0.568|     2.126|   0.034|
|Adjusted   |sm_share_suicideUsually          |    10.870|     0.870|     2.743|   0.006|
|Adjusted   |sm_share_suicideAlways           |     0.313|     1.257|    -0.925|   0.355|
|Adjusted   |countSocialMediaExclFB           |     0.887|     0.108|    -1.108|   0.268|
|Adjusted   |comm_inpersonOnce a week         |     0.764|     0.317|    -0.852|   0.394|
|Adjusted   |comm_inpersonA few times a week  |     0.322|     0.308|    -3.675|   0.000|
|Adjusted   |comm_inpersonOnce a day          |     0.443|     0.392|    -2.076|   0.038|
|Adjusted   |comm_inpersonSeveral times a day |     0.368|     0.267|    -3.741|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.825|     0.224|     4.634|   0.000|
|Adjusted   |countSuicideAttempts             |     1.263|     0.132|     1.768|   0.077|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       690.273|     581| -328.601| 667.202| 689.035|  657.202|         577|
|Adjusted   |       690.273|     581| -295.884| 615.767| 668.165|  591.767|         570|


### AUDIT-C vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.284|   5| 574|  0.269|
|Adjusted   | 1.320|   5| 567|  0.254|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.111|     1.054|    -2.085|   0.037|
|Unadjusted |fb_freqEvery_few_weeks           |     3.000|     1.563|     0.703|   0.482|
|Unadjusted |fb_freqOnce_a_week               |     1.800|     1.520|     0.387|   0.699|
|Unadjusted |fb_freqA_few_times_a_week        |     4.846|     1.105|     1.428|   0.153|
|Unadjusted |fb_freqOnce_a_day                |     7.615|     1.080|     1.879|   0.060|
|Unadjusted |fb_freqSeveral_times_a_day       |     6.812|     1.058|     1.813|   0.070|
|Adjusted   |(Intercept)                      |     0.106|     1.070|    -2.102|   0.036|
|Adjusted   |fb_freqEvery_few_weeks           |     3.302|     1.571|     0.760|   0.447|
|Adjusted   |fb_freqOnce_a_week               |     1.709|     1.529|     0.351|   0.726|
|Adjusted   |fb_freqA_few_times_a_week        |     5.243|     1.111|     1.492|   0.136|
|Adjusted   |fb_freqOnce_a_day                |     8.016|     1.087|     1.915|   0.055|
|Adjusted   |fb_freqSeveral_times_a_day       |     7.263|     1.064|     1.863|   0.062|
|Adjusted   |countSocialMediaExclFB           |     1.064|     0.088|     0.706|   0.480|
|Adjusted   |comm_inpersonOnce a week         |     1.253|     0.293|     0.770|   0.441|
|Adjusted   |comm_inpersonA few times a week  |     0.912|     0.250|    -0.366|   0.714|
|Adjusted   |comm_inpersonOnce a day          |     0.781|     0.321|    -0.770|   0.441|
|Adjusted   |comm_inpersonSeveral times a day |     0.657|     0.226|    -1.853|   0.064|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.338|     0.191|     1.524|   0.128|
|Adjusted   |countSuicideAttempts             |     0.860|     0.124|    -1.213|   0.225|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       788.749|     579| -389.984| 791.967| 818.146|  779.967|         574|
|Adjusted   |       788.749|     579| -384.969| 795.938| 852.657|  769.938|         567|


### AUDIT-C vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.091|   4| 577|  0.360|
|Adjusted   | 1.232|   4| 570|  0.296|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.892|     0.239|    -0.478|   0.633|
|Unadjusted |comm_facebookOnce_a_week         |     0.561|     0.416|    -1.393|   0.164|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.796|     0.304|    -0.750|   0.453|
|Unadjusted |comm_facebookOnce_a_day          |     0.605|     0.320|    -1.568|   0.117|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.888|     0.270|    -0.441|   0.659|
|Adjusted   |(Intercept)                      |     0.845|     0.270|    -0.622|   0.534|
|Adjusted   |comm_facebookOnce_a_week         |     0.579|     0.419|    -1.302|   0.193|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.799|     0.310|    -0.723|   0.469|
|Adjusted   |comm_facebookOnce_a_day          |     0.617|     0.328|    -1.473|   0.141|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.967|     0.281|    -0.121|   0.904|
|Adjusted   |countSocialMediaExclFB           |     1.050|     0.088|     0.551|   0.582|
|Adjusted   |comm_inpersonOnce a week         |     1.352|     0.292|     1.033|   0.301|
|Adjusted   |comm_inpersonA few times a week  |     0.954|     0.249|    -0.187|   0.852|
|Adjusted   |comm_inpersonOnce a day          |     0.798|     0.321|    -0.703|   0.482|
|Adjusted   |comm_inpersonSeveral times a day |     0.678|     0.231|    -1.687|   0.092|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.331|     0.191|     1.495|   0.135|
|Adjusted   |countSuicideAttempts             |     0.865|     0.124|    -1.174|   0.240|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.916|     581| -393.235| 796.471| 818.303|  786.471|         577|
|Adjusted   |       790.916|     581| -388.210| 800.420| 852.818|  776.420|         570|


### AUDIT-C vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.792|   4| 577|  0.531|
|Adjusted   | 0.731|   4| 570|  0.571|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.654|     0.141|    -3.014|   0.003|
|Unadjusted |sm_emot_supportRarely            |     1.263|     0.203|     1.147|   0.252|
|Unadjusted |sm_emot_supportSometimes         |     1.122|     0.227|     0.508|   0.612|
|Unadjusted |sm_emot_supportUsually           |     0.790|     0.339|    -0.697|   0.486|
|Unadjusted |sm_emot_supportAlways            |     2.040|     0.777|     0.918|   0.359|
|Adjusted   |(Intercept)                      |     0.672|     0.197|    -2.018|   0.044|
|Adjusted   |sm_emot_supportRarely            |     1.232|     0.211|     0.992|   0.321|
|Adjusted   |sm_emot_supportSometimes         |     1.043|     0.238|     0.178|   0.858|
|Adjusted   |sm_emot_supportUsually           |     0.792|     0.346|    -0.675|   0.500|
|Adjusted   |sm_emot_supportAlways            |     2.200|     0.789|     0.999|   0.318|
|Adjusted   |countSocialMediaExclFB           |     1.071|     0.090|     0.763|   0.445|
|Adjusted   |comm_inpersonOnce a week         |     1.283|     0.292|     0.853|   0.394|
|Adjusted   |comm_inpersonA few times a week  |     0.902|     0.248|    -0.415|   0.678|
|Adjusted   |comm_inpersonOnce a day          |     0.795|     0.321|    -0.716|   0.474|
|Adjusted   |comm_inpersonSeveral times a day |     0.672|     0.226|    -1.755|   0.079|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.295|     0.190|     1.355|   0.175|
|Adjusted   |countSuicideAttempts             |     0.880|     0.122|    -1.046|   0.296|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.916|     581| -393.853| 797.705| 819.537|  787.705|         577|
|Adjusted   |       790.916|     581| -389.241| 802.481| 854.879|  778.481|         570|


### AUDIT-C vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.956|   4| 576|  0.431|
|Adjusted   | 1.067|   4| 569|  0.372|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.873|     0.165|    -0.821|   0.411|
|Unadjusted |sm_med_infoRarely                |     0.796|     0.224|    -1.017|   0.309|
|Unadjusted |sm_med_infoSometimes             |     0.821|     0.227|    -0.870|   0.384|
|Unadjusted |sm_med_infoUsually               |     0.642|     0.308|    -1.436|   0.151|
|Unadjusted |sm_med_infoAlways                |     0.458|     0.510|    -1.530|   0.126|
|Adjusted   |(Intercept)                      |     0.869|     0.226|    -0.623|   0.533|
|Adjusted   |sm_med_infoRarely                |     0.748|     0.229|    -1.271|   0.204|
|Adjusted   |sm_med_infoSometimes             |     0.760|     0.235|    -1.167|   0.243|
|Adjusted   |sm_med_infoUsually               |     0.591|     0.319|    -1.646|   0.100|
|Adjusted   |sm_med_infoAlways                |     0.469|     0.521|    -1.455|   0.146|
|Adjusted   |countSocialMediaExclFB           |     1.117|     0.090|     1.224|   0.221|
|Adjusted   |comm_inpersonOnce a week         |     1.320|     0.291|     0.955|   0.340|
|Adjusted   |comm_inpersonA few times a week  |     0.924|     0.248|    -0.320|   0.749|
|Adjusted   |comm_inpersonOnce a day          |     0.829|     0.322|    -0.581|   0.561|
|Adjusted   |comm_inpersonSeveral times a day |     0.702|     0.226|    -1.563|   0.118|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.305|     0.191|     1.396|   0.163|
|Adjusted   |countSuicideAttempts             |     0.892|     0.124|    -0.925|   0.355|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       789.166|     580| -392.614| 795.227| 817.051|  785.227|         576|
|Adjusted   |       789.166|     580| -387.747| 799.495| 851.872|  775.495|         569|


### AUDIT-C vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.423|   4| 577|  0.225|
|Adjusted   | 1.703|   4| 570|  0.148|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.861|     0.133|    -1.127|   0.260|
|Unadjusted |sm_med_adviceRarely              |     0.687|     0.205|    -1.831|   0.067|
|Unadjusted |sm_med_adviceSometimes           |     0.789|     0.222|    -1.063|   0.288|
|Unadjusted |sm_med_adviceUsually             |     1.040|     0.359|     0.108|   0.914|
|Unadjusted |sm_med_adviceAlways              |     0.349|     0.672|    -1.569|   0.117|
|Adjusted   |(Intercept)                      |     0.851|     0.199|    -0.809|   0.418|
|Adjusted   |sm_med_adviceRarely              |     0.627|     0.211|    -2.213|   0.027|
|Adjusted   |sm_med_adviceSometimes           |     0.756|     0.228|    -1.229|   0.219|
|Adjusted   |sm_med_adviceUsually             |     0.922|     0.369|    -0.221|   0.825|
|Adjusted   |sm_med_adviceAlways              |     0.347|     0.681|    -1.554|   0.120|
|Adjusted   |countSocialMediaExclFB           |     1.106|     0.089|     1.129|   0.259|
|Adjusted   |comm_inpersonOnce a week         |     1.322|     0.292|     0.958|   0.338|
|Adjusted   |comm_inpersonA few times a week  |     0.934|     0.249|    -0.274|   0.784|
|Adjusted   |comm_inpersonOnce a day          |     0.801|     0.321|    -0.689|   0.491|
|Adjusted   |comm_inpersonSeveral times a day |     0.691|     0.226|    -1.638|   0.101|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.354|     0.191|     1.589|   0.112|
|Adjusted   |countSuicideAttempts             |     0.879|     0.124|    -1.037|   0.300|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.916|     581| -392.479| 794.958| 816.791|  784.958|         577|
|Adjusted   |       790.916|     581| -387.190| 798.379| 850.777|  774.379|         570|


### AUDIT-C vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.067|   4| 577|  0.372|
|Adjusted   | 1.057|   4| 570|  0.377|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.788|     0.123|    -1.943|   0.052|
|Unadjusted |sm_med_questionsRarely           |     0.897|     0.199|    -0.546|   0.585|
|Unadjusted |sm_med_questionsSometimes        |     0.683|     0.243|    -1.568|   0.117|
|Unadjusted |sm_med_questionsUsually          |     1.269|     0.374|     0.636|   0.524|
|Unadjusted |sm_med_questionsAlways           |     0.476|     0.688|    -1.079|   0.280|
|Adjusted   |(Intercept)                      |     0.786|     0.195|    -1.240|   0.215|
|Adjusted   |sm_med_questionsRarely           |     0.844|     0.204|    -0.832|   0.405|
|Adjusted   |sm_med_questionsSometimes        |     0.663|     0.246|    -1.672|   0.095|
|Adjusted   |sm_med_questionsUsually          |     1.120|     0.384|     0.294|   0.769|
|Adjusted   |sm_med_questionsAlways           |     0.466|     0.697|    -1.097|   0.272|
|Adjusted   |countSocialMediaExclFB           |     1.085|     0.089|     0.916|   0.359|
|Adjusted   |comm_inpersonOnce a week         |     1.277|     0.291|     0.839|   0.402|
|Adjusted   |comm_inpersonA few times a week  |     0.922|     0.248|    -0.328|   0.743|
|Adjusted   |comm_inpersonOnce a day          |     0.777|     0.319|    -0.788|   0.431|
|Adjusted   |comm_inpersonSeveral times a day |     0.700|     0.225|    -1.583|   0.113|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.349|     0.190|     1.575|   0.115|
|Adjusted   |countSuicideAttempts             |     0.874|     0.124|    -1.088|   0.276|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.916|     581| -393.261| 796.522| 818.355|  786.522|         577|
|Adjusted   |       790.916|     581| -388.549| 801.099| 853.497|  777.099|         570|


### AUDIT-C vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.568|   4| 576|  0.181|
|Adjusted   | 1.730|   4| 569|  0.142|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.703|     0.115|    -3.051|   0.002|
|Unadjusted |sm_share_symptRarely             |     1.314|     0.199|     1.371|   0.170|
|Unadjusted |sm_share_symptSometimes          |     0.900|     0.257|    -0.412|   0.680|
|Unadjusted |sm_share_symptUsually            |     0.452|     0.449|    -1.766|   0.077|
|Unadjusted |sm_share_symptAlways             |     0.948|     0.656|    -0.082|   0.935|
|Adjusted   |(Intercept)                      |     0.743|     0.187|    -1.587|   0.112|
|Adjusted   |sm_share_symptRarely             |     1.198|     0.209|     0.868|   0.385|
|Adjusted   |sm_share_symptSometimes          |     0.805|     0.268|    -0.810|   0.418|
|Adjusted   |sm_share_symptUsually            |     0.377|     0.461|    -2.119|   0.034|
|Adjusted   |sm_share_symptAlways             |     0.798|     0.672|    -0.336|   0.737|
|Adjusted   |countSocialMediaExclFB           |     1.066|     0.089|     0.712|   0.476|
|Adjusted   |comm_inpersonOnce a week         |     1.228|     0.295|     0.698|   0.485|
|Adjusted   |comm_inpersonA few times a week  |     0.880|     0.250|    -0.512|   0.609|
|Adjusted   |comm_inpersonOnce a day          |     0.743|     0.320|    -0.930|   0.352|
|Adjusted   |comm_inpersonSeveral times a day |     0.650|     0.227|    -1.898|   0.058|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.373|     0.195|     1.628|   0.104|
|Adjusted   |countSuicideAttempts             |     0.898|     0.126|    -0.855|   0.392|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       789.833|     580| -391.555| 793.110| 814.934|  783.110|         576|
|Adjusted   |       789.833|     580| -386.439| 796.879| 849.256|  772.879|         569|


### AUDIT-C vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.952|   4| 576|  0.433|
|Adjusted   | 0.973|   4| 569|  0.422|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.739|     0.121|    -2.500|   0.012|
|Unadjusted |sm_share_healthRarely            |     1.042|     0.187|     0.218|   0.827|
|Unadjusted |sm_share_healthSometimes         |     0.765|     0.274|    -0.981|   0.327|
|Unadjusted |sm_share_healthUsually           |     1.230|     0.453|     0.457|   0.648|
|Unadjusted |sm_share_healthAlways            |     0.193|     1.076|    -1.528|   0.127|
|Adjusted   |(Intercept)                      |     0.736|     0.192|    -1.593|   0.111|
|Adjusted   |sm_share_healthRarely            |     0.956|     0.192|    -0.235|   0.814|
|Adjusted   |sm_share_healthSometimes         |     0.697|     0.286|    -1.261|   0.207|
|Adjusted   |sm_share_healthUsually           |     1.019|     0.467|     0.041|   0.968|
|Adjusted   |sm_share_healthAlways            |     0.184|     1.087|    -1.560|   0.119|
|Adjusted   |countSocialMediaExclFB           |     1.093|     0.089|     1.004|   0.315|
|Adjusted   |comm_inpersonOnce a week         |     1.278|     0.291|     0.844|   0.399|
|Adjusted   |comm_inpersonA few times a week  |     0.923|     0.249|    -0.320|   0.749|
|Adjusted   |comm_inpersonOnce a day          |     0.795|     0.320|    -0.718|   0.473|
|Adjusted   |comm_inpersonSeveral times a day |     0.703|     0.226|    -1.558|   0.119|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.340|     0.193|     1.520|   0.128|
|Adjusted   |countSuicideAttempts             |     0.912|     0.125|    -0.733|   0.464|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       789.833|     580| -392.492| 794.985| 816.808|  784.985|         576|
|Adjusted   |       789.833|     580| -387.892| 799.784| 852.161|  775.784|         569|


### AUDIT-C vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.706|   4| 575|  0.588|
|Adjusted   | 0.479|   4| 568|  0.751|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.690|     0.091|    -4.059|   0.000|
|Unadjusted |sm_share_suicideRarely           |     1.556|     0.283|     1.564|   0.118|
|Unadjusted |sm_share_suicideSometimes        |     1.448|     0.542|     0.683|   0.495|
|Unadjusted |sm_share_suicideUsually          |     1.159|     0.677|     0.217|   0.828|
|Unadjusted |sm_share_suicideAlways           |     0.000|   441.372|    -0.032|   0.974|
|Adjusted   |(Intercept)                      |     0.716|     0.182|    -1.839|   0.066|
|Adjusted   |sm_share_suicideRarely           |     1.458|     0.290|     1.302|   0.193|
|Adjusted   |sm_share_suicideSometimes        |     1.377|     0.556|     0.576|   0.565|
|Adjusted   |sm_share_suicideUsually          |     1.021|     0.686|     0.030|   0.976|
|Adjusted   |sm_share_suicideAlways           |     0.000|   436.045|    -0.032|   0.974|
|Adjusted   |countSocialMediaExclFB           |     1.066|     0.088|     0.727|   0.468|
|Adjusted   |comm_inpersonOnce a week         |     1.226|     0.293|     0.694|   0.487|
|Adjusted   |comm_inpersonA few times a week  |     0.881|     0.248|    -0.510|   0.610|
|Adjusted   |comm_inpersonOnce a day          |     0.777|     0.320|    -0.787|   0.431|
|Adjusted   |comm_inpersonSeveral times a day |     0.668|     0.226|    -1.788|   0.074|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.280|     0.192|     1.285|   0.199|
|Adjusted   |countSuicideAttempts             |     0.883|     0.128|    -0.968|   0.333|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       788.749|     579| -390.783| 791.566| 813.382|  781.566|         575|
|Adjusted   |       788.749|     579| -386.537| 797.075| 849.431|  773.075|         568|


### DSI-SS vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.641|   5| 576|  0.669|
|Adjusted   | 0.692|   5| 569|  0.630|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.250|     0.791|    -1.754|   0.080|
|Unadjusted |fb_freqEvery_few_weeks           |     4.000|     1.275|     1.087|   0.277|
|Unadjusted |fb_freqOnce_a_week               |     0.800|     1.351|    -0.165|   0.869|
|Unadjusted |fb_freqA_few_times_a_week        |     0.706|     0.906|    -0.384|   0.701|
|Unadjusted |fb_freqOnce_a_day                |     1.333|     0.836|     0.344|   0.731|
|Unadjusted |fb_freqSeveral_times_a_day       |     1.172|     0.799|     0.199|   0.842|
|Adjusted   |(Intercept)                      |     0.170|     0.864|    -2.050|   0.040|
|Adjusted   |fb_freqEvery_few_weeks           |     4.880|     1.389|     1.141|   0.254|
|Adjusted   |fb_freqOnce_a_week               |     0.486|     1.416|    -0.510|   0.610|
|Adjusted   |fb_freqA_few_times_a_week        |     0.559|     0.963|    -0.604|   0.546|
|Adjusted   |fb_freqOnce_a_day                |     0.817|     0.893|    -0.227|   0.821|
|Adjusted   |fb_freqSeveral_times_a_day       |     0.788|     0.850|    -0.281|   0.779|
|Adjusted   |countSocialMediaExclFB           |     0.993|     0.108|    -0.065|   0.948|
|Adjusted   |comm_inpersonOnce a week         |     0.800|     0.341|    -0.654|   0.513|
|Adjusted   |comm_inpersonA few times a week  |     0.669|     0.316|    -1.273|   0.203|
|Adjusted   |comm_inpersonOnce a day          |     0.595|     0.438|    -1.184|   0.236|
|Adjusted   |comm_inpersonSeveral times a day |     0.610|     0.288|    -1.712|   0.087|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.612|     0.251|     6.878|   0.000|
|Adjusted   |countSuicideAttempts             |     1.295|     0.125|     2.068|   0.039|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       620.726|     581| -308.724| 629.448| 655.647|  617.448|         576|
|Adjusted   |       620.726|     581| -264.010| 554.021| 610.785|  528.021|         569|


### DSI-SS vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.577|   4| 579|  0.680|
|Adjusted   | 0.722|   4| 572|  0.577|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.373|     0.269|    -3.674|   0.000|
|Unadjusted |comm_facebookOnce_a_week         |     0.805|     0.465|    -0.465|   0.642|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.915|     0.342|    -0.260|   0.795|
|Unadjusted |comm_facebookOnce_a_day          |     0.688|     0.368|    -1.017|   0.309|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.691|     0.310|    -1.195|   0.232|
|Adjusted   |(Intercept)                      |     0.193|     0.344|    -4.785|   0.000|
|Adjusted   |comm_facebookOnce_a_week         |     0.728|     0.521|    -0.610|   0.542|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.741|     0.383|    -0.782|   0.434|
|Adjusted   |comm_facebookOnce_a_day          |     0.630|     0.411|    -1.127|   0.260|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.566|     0.355|    -1.606|   0.108|
|Adjusted   |countSocialMediaExclFB           |     1.005|     0.108|     0.044|   0.965|
|Adjusted   |comm_inpersonOnce a week         |     0.800|     0.341|    -0.655|   0.513|
|Adjusted   |comm_inpersonA few times a week  |     0.654|     0.317|    -1.340|   0.180|
|Adjusted   |comm_inpersonOnce a day          |     0.648|     0.435|    -0.998|   0.318|
|Adjusted   |comm_inpersonSeveral times a day |     0.657|     0.293|    -1.432|   0.152|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.650|     0.252|     6.874|   0.000|
|Adjusted   |countSuicideAttempts             |     1.293|     0.124|     2.075|   0.038|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.744|     583| -309.734| 629.468| 651.317|  619.468|         579|
|Adjusted   |       621.744|     583| -265.318| 554.636| 607.074|  530.636|         572|


### DSI-SS vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.485|   4| 579|  0.747|
|Adjusted   | 0.578|   4| 572|  0.679|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.263|     0.169|    -7.871|   0.000|
|Unadjusted |sm_emot_supportRarely            |     1.311|     0.238|     1.136|   0.256|
|Unadjusted |sm_emot_supportSometimes         |     0.985|     0.275|    -0.054|   0.957|
|Unadjusted |sm_emot_supportUsually           |     1.128|     0.383|     0.315|   0.752|
|Unadjusted |sm_emot_supportAlways            |     0.633|     1.093|    -0.419|   0.675|
|Adjusted   |(Intercept)                      |     0.141|     0.268|    -7.316|   0.000|
|Adjusted   |sm_emot_supportRarely            |     1.077|     0.267|     0.277|   0.781|
|Adjusted   |sm_emot_supportSometimes         |     0.746|     0.313|    -0.935|   0.350|
|Adjusted   |sm_emot_supportUsually           |     0.914|     0.432|    -0.208|   0.836|
|Adjusted   |sm_emot_supportAlways            |     0.348|     1.177|    -0.897|   0.370|
|Adjusted   |countSocialMediaExclFB           |     1.002|     0.111|     0.016|   0.987|
|Adjusted   |comm_inpersonOnce a week         |     0.817|     0.343|    -0.589|   0.556|
|Adjusted   |comm_inpersonA few times a week  |     0.632|     0.317|    -1.444|   0.149|
|Adjusted   |comm_inpersonOnce a day          |     0.667|     0.436|    -0.930|   0.352|
|Adjusted   |comm_inpersonSeveral times a day |     0.607|     0.289|    -1.728|   0.084|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.511|     0.250|     6.823|   0.000|
|Adjusted   |countSuicideAttempts             |     1.308|     0.125|     2.145|   0.032|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.744|     583| -309.895| 629.790| 651.639|  619.790|         579|
|Adjusted   |       621.744|     583| -265.502| 555.003| 607.442|  531.003|         572|


### DSI-SS vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.702|   4| 578|  0.591|
|Adjusted   | 0.768|   4| 571|  0.546|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.287|     0.197|    -6.322|   0.000|
|Unadjusted |sm_med_infoRarely                |     1.170|     0.262|     0.600|   0.549|
|Unadjusted |sm_med_infoSometimes             |     0.929|     0.272|    -0.269|   0.788|
|Unadjusted |sm_med_infoUsually               |     1.067|     0.355|     0.182|   0.856|
|Unadjusted |sm_med_infoAlways                |     0.367|     0.769|    -1.304|   0.192|
|Adjusted   |(Intercept)                      |     0.141|     0.305|    -6.439|   0.000|
|Adjusted   |sm_med_infoRarely                |     1.137|     0.290|     0.443|   0.657|
|Adjusted   |sm_med_infoSometimes             |     0.878|     0.304|    -0.428|   0.669|
|Adjusted   |sm_med_infoUsually               |     0.812|     0.399|    -0.523|   0.601|
|Adjusted   |sm_med_infoAlways                |     0.314|     0.850|    -1.364|   0.173|
|Adjusted   |countSocialMediaExclFB           |     1.007|     0.112|     0.063|   0.950|
|Adjusted   |comm_inpersonOnce a week         |     0.798|     0.339|    -0.666|   0.506|
|Adjusted   |comm_inpersonA few times a week  |     0.633|     0.317|    -1.444|   0.149|
|Adjusted   |comm_inpersonOnce a day          |     0.634|     0.438|    -1.040|   0.298|
|Adjusted   |comm_inpersonSeveral times a day |     0.618|     0.289|    -1.661|   0.097|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.413|     0.249|     6.772|   0.000|
|Adjusted   |countSuicideAttempts             |     1.336|     0.126|     2.298|   0.022|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.236|     582| -308.926| 627.852| 649.693|  617.852|         578|
|Adjusted   |       621.236|     582| -264.307| 552.614| 605.033|  528.614|         571|


### DSI-SS vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.606|   4| 579|  0.659|
|Adjusted   | 0.806|   4| 572|  0.521|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.295|     0.158|    -7.725|   0.000|
|Unadjusted |sm_med_adviceRarely              |     1.036|     0.238|     0.147|   0.883|
|Unadjusted |sm_med_adviceSometimes           |     0.870|     0.267|    -0.519|   0.603|
|Unadjusted |sm_med_adviceUsually             |     1.302|     0.404|     0.652|   0.514|
|Unadjusted |sm_med_adviceAlways              |     0.282|     1.052|    -1.203|   0.229|
|Adjusted   |(Intercept)                      |     0.151|     0.269|    -7.041|   0.000|
|Adjusted   |sm_med_adviceRarely              |     0.892|     0.264|    -0.431|   0.666|
|Adjusted   |sm_med_adviceSometimes           |     0.750|     0.297|    -0.966|   0.334|
|Adjusted   |sm_med_adviceUsually             |     0.996|     0.450|    -0.008|   0.993|
|Adjusted   |sm_med_adviceAlways              |     0.170|     1.128|    -1.570|   0.116|
|Adjusted   |countSocialMediaExclFB           |     1.009|     0.110|     0.086|   0.932|
|Adjusted   |comm_inpersonOnce a week         |     0.806|     0.341|    -0.634|   0.526|
|Adjusted   |comm_inpersonA few times a week  |     0.635|     0.316|    -1.434|   0.151|
|Adjusted   |comm_inpersonOnce a day          |     0.639|     0.437|    -1.026|   0.305|
|Adjusted   |comm_inpersonSeveral times a day |     0.613|     0.288|    -1.700|   0.089|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.452|     0.249|     6.801|   0.000|
|Adjusted   |countSuicideAttempts             |     1.326|     0.125|     2.253|   0.024|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.744|     583| -309.364| 628.727| 650.577|  618.727|         579|
|Adjusted   |       621.744|     583| -264.664| 553.327| 605.766|  529.327|         572|


### DSI-SS vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.683|   4| 579|  0.604|
|Adjusted   | 0.717|   4| 572|  0.581|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.284|     0.146|    -8.595|   0.000|
|Unadjusted |sm_med_questionsRarely           |     0.945|     0.238|    -0.239|   0.811|
|Unadjusted |sm_med_questionsSometimes        |     1.111|     0.276|     0.380|   0.704|
|Unadjusted |sm_med_questionsUsually          |     1.598|     0.408|     1.148|   0.251|
|Unadjusted |sm_med_questionsAlways           |     0.352|     1.059|    -0.987|   0.324|
|Adjusted   |(Intercept)                      |     0.144|     0.265|    -7.322|   0.000|
|Adjusted   |sm_med_questionsRarely           |     0.893|     0.268|    -0.424|   0.672|
|Adjusted   |sm_med_questionsSometimes        |     1.013|     0.303|     0.042|   0.966|
|Adjusted   |sm_med_questionsUsually          |     1.061|     0.459|     0.129|   0.897|
|Adjusted   |sm_med_questionsAlways           |     0.163|     1.117|    -1.622|   0.105|
|Adjusted   |countSocialMediaExclFB           |     0.996|     0.111|    -0.034|   0.973|
|Adjusted   |comm_inpersonOnce a week         |     0.794|     0.341|    -0.678|   0.498|
|Adjusted   |comm_inpersonA few times a week  |     0.617|     0.317|    -1.524|   0.128|
|Adjusted   |comm_inpersonOnce a day          |     0.621|     0.435|    -1.096|   0.273|
|Adjusted   |comm_inpersonSeveral times a day |     0.593|     0.288|    -1.814|   0.070|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.487|     0.249|     6.831|   0.000|
|Adjusted   |countSuicideAttempts             |     1.319|     0.125|     2.209|   0.027|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.744|     583| -309.374| 628.747| 650.597|  618.747|         579|
|Adjusted   |       621.744|     583| -264.738| 553.477| 605.915|  529.477|         572|


### DSI-SS vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 4.158|   4| 578|  0.002|
|Adjusted   | 1.348|   4| 571|  0.251|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.200|     0.152|   -10.595|   0.000|
|Unadjusted |sm_share_symptRarely             |     1.927|     0.237|     2.770|   0.006|
|Unadjusted |sm_share_symptSometimes          |     2.143|     0.287|     2.652|   0.008|
|Unadjusted |sm_share_symptUsually            |     3.333|     0.402|     2.992|   0.003|
|Unadjusted |sm_share_symptAlways             |     0.556|     1.065|    -0.552|   0.581|
|Adjusted   |(Intercept)                      |     0.126|     0.260|    -7.985|   0.000|
|Adjusted   |sm_share_symptRarely             |     1.476|     0.264|     1.475|   0.140|
|Adjusted   |sm_share_symptSometimes          |     1.345|     0.322|     0.920|   0.358|
|Adjusted   |sm_share_symptUsually            |     1.649|     0.438|     1.143|   0.253|
|Adjusted   |sm_share_symptAlways             |     0.218|     1.133|    -1.342|   0.179|
|Adjusted   |countSocialMediaExclFB           |     0.988|     0.110|    -0.106|   0.916|
|Adjusted   |comm_inpersonOnce a week         |     0.725|     0.346|    -0.930|   0.352|
|Adjusted   |comm_inpersonA few times a week  |     0.602|     0.320|    -1.590|   0.112|
|Adjusted   |comm_inpersonOnce a day          |     0.592|     0.438|    -1.197|   0.231|
|Adjusted   |comm_inpersonSeveral times a day |     0.580|     0.289|    -1.885|   0.059|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.016|     0.252|     6.387|   0.000|
|Adjusted   |countSuicideAttempts             |     1.323|     0.127|     2.196|   0.028|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.236|     582| -302.156| 614.311| 636.152|  604.311|         578|
|Adjusted   |       621.236|     582| -263.491| 550.983| 603.401|  526.983|         571|


### DSI-SS vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.283|   4| 578|  0.011|
|Adjusted   | 1.063|   4| 571|  0.374|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.222|     0.155|    -9.732|   0.000|
|Unadjusted |sm_share_healthRarely            |     1.626|     0.223|     2.182|   0.029|
|Unadjusted |sm_share_healthSometimes         |     1.289|     0.323|     0.785|   0.433|
|Unadjusted |sm_share_healthUsually           |     4.510|     0.454|     3.320|   0.001|
|Unadjusted |sm_share_healthAlways            |     0.000|   514.561|    -0.027|   0.978|
|Adjusted   |(Intercept)                      |     0.130|     0.266|    -7.673|   0.000|
|Adjusted   |sm_share_healthRarely            |     1.167|     0.247|     0.625|   0.532|
|Adjusted   |sm_share_healthSometimes         |     0.712|     0.363|    -0.935|   0.350|
|Adjusted   |sm_share_healthUsually           |     2.127|     0.506|     1.493|   0.136|
|Adjusted   |sm_share_healthAlways            |     0.000|   722.393|    -0.022|   0.982|
|Adjusted   |countSocialMediaExclFB           |     1.009|     0.110|     0.077|   0.938|
|Adjusted   |comm_inpersonOnce a week         |     0.796|     0.346|    -0.660|   0.509|
|Adjusted   |comm_inpersonA few times a week  |     0.649|     0.320|    -1.349|   0.177|
|Adjusted   |comm_inpersonOnce a day          |     0.631|     0.438|    -1.052|   0.293|
|Adjusted   |comm_inpersonSeveral times a day |     0.629|     0.291|    -1.588|   0.112|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.233|     0.253|     6.549|   0.000|
|Adjusted   |countSuicideAttempts             |     1.387|     0.132|     2.488|   0.013|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       621.236|     582| -302.129| 614.258| 636.099|  604.258|         578|
|Adjusted   |       621.236|     582| -260.905| 545.810| 598.228|  521.810|         571|


### DSI-SS vs Share thoughts about suicide or hurting yourself in some way


|model      |      F| df1| df2| pValue|
|:----------|------:|---:|---:|------:|
|Unadjusted | 11.132|   4| 577|      0|
|Adjusted   |  6.657|   4| 570|      0|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.215|     0.117|   -13.098|   0.000|
|Unadjusted |sm_share_suicideRarely           |     5.376|     0.293|     5.749|   0.000|
|Unadjusted |sm_share_suicideSometimes        |     5.325|     0.531|     3.151|   0.002|
|Unadjusted |sm_share_suicideUsually          |     5.824|     0.681|     2.587|   0.010|
|Unadjusted |sm_share_suicideAlways           |     0.000|   727.699|    -0.019|   0.985|
|Adjusted   |(Intercept)                      |     0.122|     0.257|    -8.184|   0.000|
|Adjusted   |sm_share_suicideRarely           |     4.466|     0.326|     4.584|   0.000|
|Adjusted   |sm_share_suicideSometimes        |     3.064|     0.575|     1.948|   0.051|
|Adjusted   |sm_share_suicideUsually          |     4.781|     0.750|     2.087|   0.037|
|Adjusted   |sm_share_suicideAlways           |     0.000|   639.363|    -0.024|   0.981|
|Adjusted   |countSocialMediaExclFB           |     0.954|     0.113|    -0.416|   0.678|
|Adjusted   |comm_inpersonOnce a week         |     0.733|     0.357|    -0.872|   0.383|
|Adjusted   |comm_inpersonA few times a week  |     0.573|     0.328|    -1.697|   0.090|
|Adjusted   |comm_inpersonOnce a day          |     0.633|     0.446|    -1.025|   0.305|
|Adjusted   |comm_inpersonSeveral times a day |     0.564|     0.298|    -1.924|   0.054|
|Adjusted   |indSuicideConsideredEverTRUE     |     4.893|     0.256|     6.207|   0.000|
|Adjusted   |countSuicideAttempts             |     1.334|     0.136|     2.122|   0.034|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       620.726|     581| -287.469| 584.937| 606.769|  574.937|         577|
|Adjusted   |       620.726|     581| -250.517| 525.033| 577.431|  501.033|         570|


## F-tests


|depvar    |indepvar         |model      |      F| df1| df2| pValue|indSig |
|:---------|:----------------|:----------|------:|---:|---:|------:|:------|
|indPTSD   |fb_freq          |Unadjusted |  1.260|   5| 575|  0.280|.      |
|indPTSD   |fb_freq          |Adjusted   |  1.421|   5| 568|  0.215|.      |
|indPTSD   |comm_facebook    |Unadjusted |  1.410|   4| 578|  0.229|.      |
|indPTSD   |comm_facebook    |Adjusted   |  1.179|   4| 571|  0.319|.      |
|indPTSD   |sm_emot_support  |Unadjusted |  1.202|   4| 578|  0.309|.      |
|indPTSD   |sm_emot_support  |Adjusted   |  1.290|   4| 571|  0.273|.      |
|indPTSD   |sm_med_info      |Unadjusted |  1.291|   4| 577|  0.272|.      |
|indPTSD   |sm_med_info      |Adjusted   |  1.491|   4| 570|  0.203|.      |
|indPTSD   |sm_med_advice    |Unadjusted |  1.913|   4| 578|  0.107|.      |
|indPTSD   |sm_med_advice    |Adjusted   |  1.981|   4| 571|  0.096|.      |
|indPTSD   |sm_med_questions |Unadjusted |  2.226|   4| 578|  0.065|.      |
|indPTSD   |sm_med_questions |Adjusted   |  1.171|   4| 571|  0.323|.      |
|indPTSD   |sm_share_sympt   |Unadjusted |  5.179|   4| 577|  0.000|***    |
|indPTSD   |sm_share_sympt   |Adjusted   |  2.277|   4| 570|  0.060|.      |
|indPTSD   |sm_share_health  |Unadjusted |  3.612|   4| 577|  0.006|**     |
|indPTSD   |sm_share_health  |Adjusted   |  2.077|   4| 570|  0.082|.      |
|indPTSD   |sm_share_suicide |Unadjusted |  6.197|   4| 576|  0.000|***    |
|indPTSD   |sm_share_suicide |Adjusted   |  4.201|   4| 569|  0.002|**     |
|indPHQ    |fb_freq          |Unadjusted |  0.525|   5| 576|  0.757|.      |
|indPHQ    |fb_freq          |Adjusted   |  0.389|   5| 569|  0.856|.      |
|indPHQ    |comm_facebook    |Unadjusted |  0.482|   4| 579|  0.749|.      |
|indPHQ    |comm_facebook    |Adjusted   |  0.471|   4| 572|  0.757|.      |
|indPHQ    |sm_emot_support  |Unadjusted |  0.990|   4| 579|  0.412|.      |
|indPHQ    |sm_emot_support  |Adjusted   |  0.789|   4| 572|  0.533|.      |
|indPHQ    |sm_med_info      |Unadjusted |  1.870|   4| 578|  0.114|.      |
|indPHQ    |sm_med_info      |Adjusted   |  2.022|   4| 571|  0.090|.      |
|indPHQ    |sm_med_advice    |Unadjusted |  2.053|   4| 579|  0.086|.      |
|indPHQ    |sm_med_advice    |Adjusted   |  2.147|   4| 572|  0.074|.      |
|indPHQ    |sm_med_questions |Unadjusted |  2.746|   4| 579|  0.028|*      |
|indPHQ    |sm_med_questions |Adjusted   |  2.065|   4| 572|  0.084|.      |
|indPHQ    |sm_share_sympt   |Unadjusted |  5.983|   4| 578|  0.000|***    |
|indPHQ    |sm_share_sympt   |Adjusted   |  2.574|   4| 571|  0.037|*      |
|indPHQ    |sm_share_health  |Unadjusted |  3.919|   4| 578|  0.004|**     |
|indPHQ    |sm_share_health  |Adjusted   |  1.739|   4| 571|  0.140|.      |
|indPHQ    |sm_share_suicide |Unadjusted |  7.781|   4| 577|  0.000|***    |
|indPHQ    |sm_share_suicide |Adjusted   |  5.292|   4| 570|  0.000|***    |
|indAuditC |fb_freq          |Unadjusted |  1.284|   5| 574|  0.269|.      |
|indAuditC |fb_freq          |Adjusted   |  1.320|   5| 567|  0.254|.      |
|indAuditC |comm_facebook    |Unadjusted |  1.091|   4| 577|  0.360|.      |
|indAuditC |comm_facebook    |Adjusted   |  1.232|   4| 570|  0.296|.      |
|indAuditC |sm_emot_support  |Unadjusted |  0.792|   4| 577|  0.531|.      |
|indAuditC |sm_emot_support  |Adjusted   |  0.731|   4| 570|  0.571|.      |
|indAuditC |sm_med_info      |Unadjusted |  0.956|   4| 576|  0.431|.      |
|indAuditC |sm_med_info      |Adjusted   |  1.067|   4| 569|  0.372|.      |
|indAuditC |sm_med_advice    |Unadjusted |  1.423|   4| 577|  0.225|.      |
|indAuditC |sm_med_advice    |Adjusted   |  1.703|   4| 570|  0.148|.      |
|indAuditC |sm_med_questions |Unadjusted |  1.067|   4| 577|  0.372|.      |
|indAuditC |sm_med_questions |Adjusted   |  1.057|   4| 570|  0.377|.      |
|indAuditC |sm_share_sympt   |Unadjusted |  1.568|   4| 576|  0.181|.      |
|indAuditC |sm_share_sympt   |Adjusted   |  1.730|   4| 569|  0.142|.      |
|indAuditC |sm_share_health  |Unadjusted |  0.952|   4| 576|  0.433|.      |
|indAuditC |sm_share_health  |Adjusted   |  0.973|   4| 569|  0.422|.      |
|indAuditC |sm_share_suicide |Unadjusted |  0.706|   4| 575|  0.588|.      |
|indAuditC |sm_share_suicide |Adjusted   |  0.479|   4| 568|  0.751|.      |
|indDSISS  |fb_freq          |Unadjusted |  0.641|   5| 576|  0.669|.      |
|indDSISS  |fb_freq          |Adjusted   |  0.692|   5| 569|  0.630|.      |
|indDSISS  |comm_facebook    |Unadjusted |  0.577|   4| 579|  0.680|.      |
|indDSISS  |comm_facebook    |Adjusted   |  0.722|   4| 572|  0.577|.      |
|indDSISS  |sm_emot_support  |Unadjusted |  0.485|   4| 579|  0.747|.      |
|indDSISS  |sm_emot_support  |Adjusted   |  0.578|   4| 572|  0.679|.      |
|indDSISS  |sm_med_info      |Unadjusted |  0.702|   4| 578|  0.591|.      |
|indDSISS  |sm_med_info      |Adjusted   |  0.768|   4| 571|  0.546|.      |
|indDSISS  |sm_med_advice    |Unadjusted |  0.606|   4| 579|  0.659|.      |
|indDSISS  |sm_med_advice    |Adjusted   |  0.806|   4| 572|  0.521|.      |
|indDSISS  |sm_med_questions |Unadjusted |  0.683|   4| 579|  0.604|.      |
|indDSISS  |sm_med_questions |Adjusted   |  0.717|   4| 572|  0.581|.      |
|indDSISS  |sm_share_sympt   |Unadjusted |  4.158|   4| 578|  0.002|**     |
|indDSISS  |sm_share_sympt   |Adjusted   |  1.348|   4| 571|  0.251|.      |
|indDSISS  |sm_share_health  |Unadjusted |  3.283|   4| 578|  0.011|*      |
|indDSISS  |sm_share_health  |Adjusted   |  1.063|   4| 571|  0.374|.      |
|indDSISS  |sm_share_suicide |Unadjusted | 11.132|   4| 577|  0.000|***    |
|indDSISS  |sm_share_suicide |Adjusted   |  6.657|   4| 570|  0.000|***    |


## Additional questions

> An issue that additional data analysis could clarify is whether veterans who
> are actively experiencing psychiatric problems are using social media for
> health-related purposes. If so, this would suggest potential for an
> intervention that aims to increase the likelihood of veterans using social
> media to initiate help-seeking or take a screener for psychiatric problems
> after developing psychiatric symptoms. It would be interest to see if:
> 
> * Of those who screen positive for PTSD, alcohol misuse, depression, and
>   suicidal ideation, how often do they use a social media platform for health-
>   related concerns?
> * Anything else???

# Research Question 3

**Is perceived social support received from Facebook (fmssSubscore) associated with health service utilization?**

* Among participants with positive screens for psychiatric disorders or suicidal ideation?
* Among all participants?

Use interaction terms to examine effect modification by positive screens for
psychiatric disorders or suicidal ideation.
**Look at the unadjusted and adjusted odds ratio for the `fmssSubscore` term.**

## Unadjusted comparisons


|yvariable    |indVANeverEnrolled | mean | sd  | min | max |  n  | freq  |
|:------------|:------------------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmssSubscore |FALSE              | 3.4  | 2.7 |  0  | 12  | 392 | 67.2% |
|fmssSubscore |TRUE               | 2.9  | 2.6 |  0  | 10  | 191 | 32.8% |

\newline


|yvariable    |indVANotUse12mo | mean | sd  | min | max |  n  | freq  |
|:------------|:---------------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmssSubscore |FALSE           | 3.5  | 2.8 |  0  | 12  | 262 | 45.0% |
|fmssSubscore |TRUE            | 3.0  | 2.6 |  0  | 12  | 320 | 55.0% |

\newline

![plot of chunk plot2GroupsRQ3](../figures/plot2GroupsRQ3-1.png)


## Adjusted comparisons



Filter subjects with missing covariates.




### Never enrolled in VA



**PC-PTSD**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.345|     0.224|    -4.750|   0.000|
|Unadjusted |fmssSubscore                     |     0.922|     0.057|    -1.407|   0.159|
|Unadjusted |indNotPTSDTRUE                   |     2.631|     0.285|     3.390|   0.001|
|Unadjusted |fmssSubscore:indNotPTSDTRUE      |     1.017|     0.072|     0.229|   0.819|
|Adjusted   |(Intercept)                      |     0.367|     0.292|    -3.441|   0.001|
|Adjusted   |fmssSubscore                     |     0.943|     0.059|    -1.004|   0.315|
|Adjusted   |countSocialMediaExclFB           |     0.842|     0.103|    -1.664|   0.096|
|Adjusted   |comm_inpersonOnce a week         |     1.030|     0.337|     0.087|   0.930|
|Adjusted   |comm_inpersonA few times a week  |     0.921|     0.283|    -0.292|   0.771|
|Adjusted   |comm_inpersonOnce a day          |     1.598|     0.335|     1.397|   0.162|
|Adjusted   |comm_inpersonSeveral times a day |     1.277|     0.245|     0.997|   0.319|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.206|     0.208|     0.899|   0.369|
|Adjusted   |countSuicideAttempts             |     0.516|     0.230|    -2.870|   0.004|
|Adjusted   |indNotPTSDTRUE                   |     2.360|     0.297|     2.890|   0.004|
|Adjusted   |fmssSubscore:indNotPTSDTRUE      |     1.001|     0.073|     0.012|   0.990|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       732.854|     578| -349.089| 706.178| 723.623|  698.178|         575|
|Adjusted   |       732.854|     578| -339.589| 701.178| 749.153|  679.178|         568|

**PHQ-2**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.463|     0.264|    -2.916|   0.004|
|Unadjusted |fmssSubscore                     |     0.862|     0.073|    -2.030|   0.042|
|Unadjusted |indNotPHQTRUE                    |     1.461|     0.308|     1.232|   0.218|
|Unadjusted |fmssSubscore:indNotPHQTRUE       |     1.106|     0.083|     1.209|   0.226|
|Adjusted   |(Intercept)                      |     0.536|     0.319|    -1.951|   0.051|
|Adjusted   |fmssSubscore                     |     0.871|     0.072|    -1.908|   0.056|
|Adjusted   |countSocialMediaExclFB           |     0.827|     0.102|    -1.869|   0.062|
|Adjusted   |comm_inpersonOnce a week         |     0.994|     0.333|    -0.018|   0.985|
|Adjusted   |comm_inpersonA few times a week  |     0.928|     0.278|    -0.267|   0.789|
|Adjusted   |comm_inpersonOnce a day          |     1.638|     0.330|     1.497|   0.134|
|Adjusted   |comm_inpersonSeveral times a day |     1.348|     0.241|     1.241|   0.215|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.156|     0.207|     0.699|   0.485|
|Adjusted   |countSuicideAttempts             |     0.501|     0.223|    -3.096|   0.002|
|Adjusted   |indNotPHQTRUE                    |     1.209|     0.318|     0.595|   0.552|
|Adjusted   |fmssSubscore:indNotPHQTRUE       |     1.115|     0.083|     1.316|   0.188|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       735.079|     579| -359.548| 727.097| 744.549|  719.097|         576|
|Adjusted   |       735.079|     579| -347.374| 716.748| 764.741|  694.748|         569|

**AUDIT-C**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.800|     0.209|    -1.067|   0.286|
|Unadjusted |fmssSubscore                     |     0.890|     0.055|    -2.107|   0.035|
|Unadjusted |indNotAuditCTRUE                 |     0.612|     0.275|    -1.787|   0.074|
|Unadjusted |fmssSubscore:indNotAuditCTRUE    |     1.082|     0.070|     1.136|   0.256|
|Adjusted   |(Intercept)                      |     0.842|     0.270|    -0.636|   0.525|
|Adjusted   |fmssSubscore                     |     0.896|     0.057|    -1.911|   0.056|
|Adjusted   |countSocialMediaExclFB           |     0.826|     0.102|    -1.868|   0.062|
|Adjusted   |comm_inpersonOnce a week         |     1.035|     0.333|     0.102|   0.919|
|Adjusted   |comm_inpersonA few times a week  |     1.066|     0.276|     0.231|   0.817|
|Adjusted   |comm_inpersonOnce a day          |     1.950|     0.332|     2.011|   0.044|
|Adjusted   |comm_inpersonSeveral times a day |     1.541|     0.239|     1.805|   0.071|
|Adjusted   |indSuicideConsideredEverTRUE     |     0.977|     0.204|    -0.112|   0.911|
|Adjusted   |countSuicideAttempts             |     0.505|     0.221|    -3.087|   0.002|
|Adjusted   |indNotAuditCTRUE                 |     0.553|     0.284|    -2.088|   0.037|
|Adjusted   |fmssSubscore:indNotAuditCTRUE    |     1.096|     0.072|     1.277|   0.202|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       730.622|     577| -361.523| 731.046| 748.484|  723.046|         574|
|Adjusted   |       730.622|     577| -345.979| 713.959| 761.914|  691.959|         567|

**DSI-SS**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.365|     0.297|    -3.386|   0.001|
|Unadjusted |fmssSubscore                     |     1.068|     0.075|     0.881|   0.378|
|Unadjusted |indNotDSISSTRUE                  |     1.904|     0.334|     1.928|   0.054|
|Unadjusted |fmssSubscore:indNotDSISSTRUE     |     0.846|     0.084|    -2.000|   0.046|
|Adjusted   |(Intercept)                      |     0.484|     0.367|    -1.976|   0.048|
|Adjusted   |fmssSubscore                     |     1.080|     0.077|     1.003|   0.316|
|Adjusted   |countSocialMediaExclFB           |     0.838|     0.101|    -1.757|   0.079|
|Adjusted   |comm_inpersonOnce a week         |     1.056|     0.331|     0.165|   0.869|
|Adjusted   |comm_inpersonA few times a week  |     1.037|     0.275|     0.132|   0.895|
|Adjusted   |comm_inpersonOnce a day          |     1.771|     0.328|     1.740|   0.082|
|Adjusted   |comm_inpersonSeveral times a day |     1.503|     0.238|     1.709|   0.087|
|Adjusted   |indSuicideConsideredEverTRUE     |     0.998|     0.212|    -0.009|   0.993|
|Adjusted   |countSuicideAttempts             |     0.479|     0.222|    -3.316|   0.001|
|Adjusted   |indNotDSISSTRUE                  |     1.329|     0.357|     0.797|   0.426|
|Adjusted   |fmssSubscore:indNotDSISSTRUE     |     0.852|     0.086|    -1.865|   0.062|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       735.079|     579| -363.228| 734.456| 751.908|  726.456|         576|
|Adjusted   |       735.079|     579| -348.516| 719.032| 767.026|  697.032|         569|


### Did not use VA health services in prior 12 months



**PC-PTSD**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.777|     0.192|    -1.312|   0.190|
|Unadjusted |fmssSubscore                     |     0.950|     0.046|    -1.102|   0.271|
|Unadjusted |indNotPTSDTRUE                   |     3.486|     0.273|     4.574|   0.000|
|Unadjusted |fmssSubscore:indNotPTSDTRUE      |     0.971|     0.064|    -0.464|   0.643|
|Adjusted   |(Intercept)                      |     0.731|     0.259|    -1.210|   0.226|
|Adjusted   |fmssSubscore                     |     0.965|     0.047|    -0.761|   0.447|
|Adjusted   |countSocialMediaExclFB           |     0.985|     0.093|    -0.168|   0.867|
|Adjusted   |comm_inpersonOnce a week         |     1.085|     0.306|     0.268|   0.789|
|Adjusted   |comm_inpersonA few times a week  |     1.224|     0.261|     0.774|   0.439|
|Adjusted   |comm_inpersonOnce a day          |     1.854|     0.341|     1.810|   0.070|
|Adjusted   |comm_inpersonSeveral times a day |     1.272|     0.234|     1.028|   0.304|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.067|     0.200|     0.326|   0.745|
|Adjusted   |countSuicideAttempts             |     0.678|     0.146|    -2.656|   0.008|
|Adjusted   |indNotPTSDTRUE                   |     3.121|     0.283|     4.025|   0.000|
|Adjusted   |fmssSubscore:indNotPTSDTRUE      |     0.957|     0.066|    -0.670|   0.503|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       795.844|     577| -373.155| 754.310| 771.748|  746.310|         574|
|Adjusted   |       795.844|     577| -366.340| 754.681| 802.636|  732.681|         567|

**PHQ-2**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.830|     0.240|    -0.776|   0.438|
|Unadjusted |fmssSubscore                     |     0.897|     0.060|    -1.798|   0.072|
|Unadjusted |indNotPHQTRUE                    |     2.320|     0.288|     2.919|   0.004|
|Unadjusted |fmssSubscore:indNotPHQTRUE       |     1.056|     0.071|     0.769|   0.442|
|Adjusted   |(Intercept)                      |     0.855|     0.294|    -0.532|   0.595|
|Adjusted   |fmssSubscore                     |     0.905|     0.061|    -1.649|   0.099|
|Adjusted   |countSocialMediaExclFB           |     0.955|     0.091|    -0.502|   0.615|
|Adjusted   |comm_inpersonOnce a week         |     1.052|     0.303|     0.168|   0.867|
|Adjusted   |comm_inpersonA few times a week  |     1.150|     0.258|     0.543|   0.587|
|Adjusted   |comm_inpersonOnce a day          |     1.822|     0.337|     1.780|   0.075|
|Adjusted   |comm_inpersonSeveral times a day |     1.301|     0.231|     1.141|   0.254|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.074|     0.200|     0.357|   0.721|
|Adjusted   |countSuicideAttempts             |     0.646|     0.146|    -2.987|   0.003|
|Adjusted   |indNotPHQTRUE                    |     1.964|     0.298|     2.267|   0.023|
|Adjusted   |fmssSubscore:indNotPHQTRUE       |     1.059|     0.072|     0.803|   0.422|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       797.044|     578| -381.761| 771.523| 788.968|  763.523|         575|
|Adjusted   |       797.044|     578| -373.244| 768.488| 816.462|  746.488|         568|

**AUDIT-C**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     1.876|     0.211|     2.983|   0.003|
|Unadjusted |fmssSubscore                     |     0.910|     0.052|    -1.799|   0.072|
|Unadjusted |indNotAuditCTRUE                 |     0.688|     0.269|    -1.387|   0.166|
|Unadjusted |fmssSubscore:indNotAuditCTRUE    |     1.048|     0.065|     0.719|   0.472|
|Adjusted   |(Intercept)                      |     1.786|     0.262|     2.216|   0.027|
|Adjusted   |fmssSubscore                     |     0.910|     0.054|    -1.759|   0.079|
|Adjusted   |countSocialMediaExclFB           |     0.962|     0.090|    -0.428|   0.669|
|Adjusted   |comm_inpersonOnce a week         |     1.087|     0.298|     0.279|   0.780|
|Adjusted   |comm_inpersonA few times a week  |     1.436|     0.252|     1.435|   0.151|
|Adjusted   |comm_inpersonOnce a day          |     2.291|     0.338|     2.449|   0.014|
|Adjusted   |comm_inpersonSeveral times a day |     1.563|     0.226|     1.978|   0.048|
|Adjusted   |indSuicideConsideredEverTRUE     |     0.874|     0.193|    -0.698|   0.485|
|Adjusted   |countSuicideAttempts             |     0.632|     0.144|    -3.188|   0.001|
|Adjusted   |indNotAuditCTRUE                 |     0.613|     0.277|    -1.762|   0.078|
|Adjusted   |fmssSubscore:indNotAuditCTRUE    |     1.066|     0.067|     0.962|   0.336|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       794.252|     576| -393.779| 795.557| 812.988|  787.557|         573|
|Adjusted   |       794.252|     576| -378.535| 779.069| 827.005|  757.069|         566|

**DSI-SS**




|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.952|     0.270|    -0.181|   0.856|
|Unadjusted |fmssSubscore                     |     0.933|     0.072|    -0.963|   0.336|
|Unadjusted |indNotDSISSTRUE                  |     1.863|     0.310|     2.010|   0.044|
|Unadjusted |fmssSubscore:indNotDSISSTRUE     |     0.998|     0.080|    -0.028|   0.978|
|Adjusted   |(Intercept)                      |     1.033|     0.336|     0.096|   0.923|
|Adjusted   |fmssSubscore                     |     0.936|     0.073|    -0.910|   0.363|
|Adjusted   |countSocialMediaExclFB           |     0.969|     0.090|    -0.347|   0.728|
|Adjusted   |comm_inpersonOnce a week         |     1.083|     0.297|     0.267|   0.789|
|Adjusted   |comm_inpersonA few times a week  |     1.361|     0.251|     1.227|   0.220|
|Adjusted   |comm_inpersonOnce a day          |     1.994|     0.332|     2.080|   0.037|
|Adjusted   |comm_inpersonSeveral times a day |     1.506|     0.226|     1.816|   0.069|
|Adjusted   |indSuicideConsideredEverTRUE     |     0.981|     0.201|    -0.093|   0.926|
|Adjusted   |countSuicideAttempts             |     0.638|     0.144|    -3.108|   0.002|
|Adjusted   |indNotDSISSTRUE                  |     1.386|     0.331|     0.984|   0.325|
|Adjusted   |fmssSubscore:indNotDSISSTRUE     |     1.009|     0.081|     0.114|   0.909|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       796.642|     578| -391.470| 790.939| 808.384|  782.939|         575|
|Adjusted   |       796.642|     578| -380.441| 782.882| 830.856|  760.882|         568|
# Respond to peer review comments

> On Jul 25, 2018, at 1:46 PM, Alan Teo <teoa@ohsu.edu> wrote:
> 
> Hi Ben, 
> 
> Hope summer is going great for you! Could you respond to two of the peer review
> comments? I'd appreciate if you could provide information to include in the
> response letter and any additional text to include in the paper.
> 
> For your convenience I've attached the paper and appended the two items below:
> 
> 3. Were demographic variables such as age, sex, marital status, etc. related to
> the frequency of social contact (either in-person or Facebook)? These
> demographic characteristics, in particular, may meaningfully relate to your
> constructs of interest and provide a context for some of the findings. 


|yvariable |fb_freq                       | mean |  sd  | min | max |  n  | freq  |
|:---------|:-----------------------------|:----:|:----:|:---:|:---:|:---:|:-----:|
|age       |Less_than_several_times_a_day | 42.8 | 12.9 | 22  | 75  | 133 | 22.7% |
|age       |Several_times_a_day           | 39.2 | 11.6 | 20  | 74  | 452 | 77.3% |

```
## 
## 	Welch Two Sample t-test
## 
## data:  age by fb_freq
## t = 2.9466, df = 198.73, p-value = 0.003597
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  1.214001 6.126840
## sample estimates:
## mean in group Less_than_several_times_a_day 
##                                    42.84962 
##           mean in group Several_times_a_day 
##                                    39.17920
```



|gender |fb_freq                       |  n  |  N  | freq  |
|:------|:-----------------------------|:---:|:---:|:-----:|
|1      |Less_than_several_times_a_day | 108 | 472 | 0.229 |
|1      |Several_times_a_day           | 364 | 472 | 0.771 |
|2      |Less_than_several_times_a_day | 25  | 111 | 0.225 |
|2      |Several_times_a_day           | 86  | 111 | 0.775 |
|99     |Several_times_a_day           |  2  |  2  | 1.000 |

```
## Warning in chisq.test(dfTemp$gender, dfTemp$fb_freq): Chi-squared
## approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  dfTemp$gender and dfTemp$fb_freq
## X-squared = 0.5971, df = 2, p-value = 0.7419
```



|marital                          |fb_freq                       |  n  |  N  | freq  |
|:--------------------------------|:-----------------------------|:---:|:---:|:-----:|
|Single/Divorce/Widowed/Separated |Less_than_several_times_a_day | 53  | 222 | 0.239 |
|Single/Divorce/Widowed/Separated |Several_times_a_day           | 169 | 222 | 0.761 |
|Married or living as married     |Less_than_several_times_a_day | 79  | 362 | 0.218 |
|Married or living as married     |Several_times_a_day           | 283 | 362 | 0.782 |

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  dfTemp$marital and dfTemp$fb_freq
## X-squared = 0.22395, df = 1, p-value = 0.636
```

Age was significantly associated with frequency of Facebook use `fb_freq`
(collapsed groups).
Several-times-a-day Facebook users were slightly younger on average.
The difference was only 
3.7 years
(42.8 years
versus
39.2 years).
Gender and marital status (collapsed groups) are not significantly associated with frequency of Facebook use.
 
> 4. How highly correlated are in-person contact with Facebook contact? Authors
> should address the potential concerns of multicollinearity of IVs in the
> logistic regression model.

Rerun `analyzeRQ[123].Rmd` without `comm_inperson` as a covariate in `covar`.
Compare with output from commit `632302` (6/11/2018).

* The models including `comm_inperson` had slightly attenuated coefficients for
`comm_facebook`
* The models not including `comm_inperson` had coefficients for `comm_facebook`
that were slightly away from the null; but still not significantly different
from the null
* Conclusion: the correlation between `comm_inperson` and `comm_facebook` does
not greatly bias the association between `comm_facebook` and any of the outcomes
