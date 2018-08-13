---
title: "Psychiatric Symptoms of Veterans Surveyed Through Facebook Ads"
date: "2018-08-13 15:37:12"
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
##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean  sd
##       0.91      0.91    0.87      0.77  10 0.0065  1.1 0.9
## 
##  lower alpha upper     95% confidence boundaries
## 0.9 0.91 0.92 
## 
##  Reliability if an item is dropped:
##         raw_alpha std.alpha G6(smc) average_r S/N alpha se
## fmss_r1      0.89      0.89    0.80      0.80 7.8   0.0094
## fmss_r2      0.85      0.85    0.74      0.74 5.7   0.0124
## fmss_r3      0.87      0.87    0.78      0.78 7.0   0.0104
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
|NA                            |   1|

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


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.841|     0.085|    -2.053|   0.040|
|Unadjusted |fmssZ                        |     0.808|     0.086|    -2.492|   0.013|
|Adjusted   |(Intercept)                  |     0.506|     0.130|    -5.233|   0.000|
|Adjusted   |fmssZ                        |     0.812|     0.091|    -2.281|   0.023|
|Adjusted   |countSocialMediaExclFB       |     1.046|     0.092|     0.482|   0.630|
|Adjusted   |indSuicideConsideredEverTRUE |     2.154|     0.193|     3.980|   0.000|
|Adjusted   |countSuicideAttempts         |     1.742|     0.159|     3.482|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       784.577|     568| -389.135| 782.270| 790.958|  778.270|         567|
|Adjusted   |       784.577|     568| -361.835| 733.669| 755.389|  723.669|         564|


### PHQ-2


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.382|     0.095|   -10.185|   0.000|
|Unadjusted |fmssZ                        |     0.775|     0.096|    -2.648|   0.008|
|Adjusted   |(Intercept)                  |     0.207|     0.161|    -9.791|   0.000|
|Adjusted   |fmssZ                        |     0.799|     0.101|    -2.225|   0.026|
|Adjusted   |countSocialMediaExclFB       |     0.919|     0.102|    -0.824|   0.410|
|Adjusted   |indSuicideConsideredEverTRUE |     3.131|     0.216|     5.293|   0.000|
|Adjusted   |countSuicideAttempts         |     1.306|     0.121|     2.198|   0.028|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        674.83|     569| -333.825| 671.651| 680.342|  667.651|         568|
|Adjusted   |        674.83|     569| -308.510| 627.021| 648.749|  617.021|         565|


### AUDIT-C


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.701|     0.085|    -4.174|   0.000|
|Unadjusted |fmssZ                        |     0.964|     0.085|    -0.431|   0.666|
|Adjusted   |(Intercept)                  |     0.602|     0.126|    -4.028|   0.000|
|Adjusted   |fmssZ                        |     0.964|     0.087|    -0.426|   0.670|
|Adjusted   |countSocialMediaExclFB       |     1.067|     0.088|     0.738|   0.460|
|Adjusted   |indSuicideConsideredEverTRUE |     1.354|     0.189|     1.603|   0.109|
|Adjusted   |countSuicideAttempts         |     0.908|     0.121|    -0.796|   0.426|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       769.717|     567| -384.766| 773.531| 782.216|  769.531|         566|
|Adjusted   |       769.717|     567| -383.075| 776.150| 797.860|  766.150|         563|


### DSI-SS


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.283|     0.103|   -12.325|   0.000|
|Unadjusted |fmssZ                        |     0.739|     0.104|    -2.904|   0.004|
|Adjusted   |(Intercept)                  |     0.094|     0.210|   -11.295|   0.000|
|Adjusted   |fmssZ                        |     0.748|     0.113|    -2.564|   0.010|
|Adjusted   |countSocialMediaExclFB       |     1.016|     0.108|     0.151|   0.880|
|Adjusted   |indSuicideConsideredEverTRUE |     5.622|     0.252|     6.845|   0.000|
|Adjusted   |countSuicideAttempts         |     1.327|     0.121|     2.336|   0.020|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       607.188|     569| -299.242| 602.484| 611.175|  598.484|         568|
|Adjusted   |       607.188|     569| -257.578| 525.156| 546.884|  515.156|         565|


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


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.410|     0.142|    -6.281|   0.000|
|Unadjusted |fmssSubscore                 |     0.987|     0.034|    -0.384|   0.701|
|Adjusted   |(Intercept)                  |     0.237|     0.185|    -7.794|   0.000|
|Adjusted   |fmssSubscore                 |     0.969|     0.037|    -0.868|   0.385|
|Adjusted   |countSocialMediaExclFB       |     0.883|     0.101|    -1.226|   0.220|
|Adjusted   |indSuicideConsideredEverTRUE |     3.289|     0.212|     5.605|   0.000|
|Adjusted   |countSuicideAttempts         |     1.312|     0.122|     2.224|   0.026|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        691.49|     580| -345.671| 695.342| 704.072|  691.342|         579|
|Adjusted   |        691.49|     580| -317.606| 645.212| 667.036|  635.212|         576|


### DSI-SS


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.343|     0.150|    -7.126|   0.000|
|Unadjusted |fmssSubscore                 |     0.948|     0.038|    -1.421|   0.155|
|Adjusted   |(Intercept)                  |     0.128|     0.225|    -9.128|   0.000|
|Adjusted   |fmssSubscore                 |     0.906|     0.042|    -2.328|   0.020|
|Adjusted   |countSocialMediaExclFB       |     0.998|     0.107|    -0.018|   0.986|
|Adjusted   |indSuicideConsideredEverTRUE |     5.983|     0.249|     7.171|   0.000|
|Adjusted   |countSuicideAttempts         |     1.348|     0.122|     2.457|   0.014|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       620.216|     580| -309.076| 622.153| 630.882|  618.153|         579|
|Adjusted   |       620.216|     580| -263.618| 537.236| 559.059|  527.236|         576|


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


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.568|     0.158|    -3.591|   0.000|
|Unadjusted |fmssQuartileQ4: (34,48]      |     0.562|     0.262|    -2.194|   0.028|
|Adjusted   |(Intercept)                  |     0.303|     0.235|    -5.075|   0.000|
|Adjusted   |fmssQuartileQ4: (34,48]      |     0.593|     0.278|    -1.883|   0.060|
|Adjusted   |countSocialMediaExclFB       |     0.914|     0.138|    -0.651|   0.515|
|Adjusted   |indSuicideConsideredEverTRUE |     3.168|     0.291|     3.958|   0.000|
|Adjusted   |countSuicideAttempts         |     1.186|     0.151|     1.126|   0.260|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        369.97|     297| -182.510| 369.019| 376.413|  365.019|         296|
|Adjusted   |        369.22|     296| -169.349| 348.699| 367.167|  338.699|         292|


### DSI-SS


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.370|     0.171|    -5.822|   0.000|
|Unadjusted |fmssQuartileQ4: (34,48]      |     0.520|     0.298|    -2.197|   0.028|
|Adjusted   |(Intercept)                  |     0.106|     0.326|    -6.893|   0.000|
|Adjusted   |fmssQuartileQ4: (34,48]      |     0.555|     0.326|    -1.805|   0.071|
|Adjusted   |countSocialMediaExclFB       |     0.948|     0.153|    -0.349|   0.727|
|Adjusted   |indSuicideConsideredEverTRUE |     7.184|     0.368|     5.361|   0.000|
|Adjusted   |countSuicideAttempts         |     1.144|     0.152|     0.885|   0.376|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       317.642|     297| -156.291| 316.581| 323.975|  312.581|         296|
|Adjusted   |       317.642|     297| -133.646| 277.292| 295.778|  267.292|         293|
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
           "indSuicideConsideredEver",
           "countSuicideAttempts")
```

Filter subjects with missing covariates.



Relabel factors; replace spaces with underscores.




### PC-PTSD vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.333|   5| 576|  0.248|
|Adjusted   | 1.388|   5| 573|  0.227|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.429|     0.690|    -1.228|   0.220|
|Unadjusted |fb_freqEvery_few_weeks       |     2.333|     1.215|     0.697|   0.486|
|Unadjusted |fb_freqOnce_a_week           |     1.167|     1.107|     0.139|   0.889|
|Unadjusted |fb_freqA_few_times_a_week    |     2.852|     0.760|     1.379|   0.168|
|Unadjusted |fb_freqOnce_a_day            |     2.917|     0.730|     1.467|   0.142|
|Unadjusted |fb_freqSeveral_times_a_day   |     1.768|     0.697|     0.818|   0.413|
|Adjusted   |(Intercept)                  |     0.324|     0.705|    -1.599|   0.110|
|Adjusted   |fb_freqEvery_few_weeks       |     2.248|     1.255|     0.645|   0.519|
|Adjusted   |fb_freqOnce_a_week           |     0.995|     1.127|    -0.005|   0.996|
|Adjusted   |fb_freqA_few_times_a_week    |     2.743|     0.773|     1.306|   0.192|
|Adjusted   |fb_freqOnce_a_day            |     2.194|     0.745|     1.055|   0.291|
|Adjusted   |fb_freqSeveral_times_a_day   |     1.385|     0.709|     0.460|   0.646|
|Adjusted   |countSocialMediaExclFB       |     1.048|     0.091|     0.516|   0.606|
|Adjusted   |indSuicideConsideredEverTRUE |     2.172|     0.192|     4.048|   0.000|
|Adjusted   |countSuicideAttempts         |     1.768|     0.163|     3.497|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       801.427|     581| -397.319| 806.637| 832.836|  794.637|         576|
|Adjusted   |       801.427|     581| -369.359| 756.719| 796.017|  738.719|         573|


### PC-PTSD vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.456|   4| 579|  0.214|
|Adjusted   | 2.056|   4| 576|  0.085|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     1.059|     0.239|     0.239|   0.811|
|Unadjusted |comm_facebookOnce_a_week         |     1.102|     0.400|     0.242|   0.809|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.944|     0.302|    -0.189|   0.850|
|Unadjusted |comm_facebookOnce_a_day          |     0.787|     0.313|    -0.765|   0.444|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.638|     0.271|    -1.661|   0.097|
|Adjusted   |(Intercept)                      |     0.695|     0.259|    -1.406|   0.160|
|Adjusted   |comm_facebookOnce_a_week         |     1.032|     0.422|     0.074|   0.941|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.831|     0.318|    -0.584|   0.559|
|Adjusted   |comm_facebookOnce_a_day          |     0.761|     0.328|    -0.835|   0.404|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.531|     0.288|    -2.201|   0.028|
|Adjusted   |countSocialMediaExclFB           |     1.070|     0.092|     0.739|   0.460|
|Adjusted   |indSuicideConsideredEverTRUE     |     2.213|     0.193|     4.120|   0.000|
|Adjusted   |countSuicideAttempts             |     1.797|     0.163|     3.592|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       804.596|     583| -399.368| 808.737| 830.586|  798.737|         579|
|Adjusted   |       804.596|     583| -369.465| 754.931| 789.890|  738.931|         576|


### PC-PTSD vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.156|   4| 579|  0.329|
|Adjusted   | 0.959|   4| 576|  0.429|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.707|     0.140|    -2.472|   0.013|
|Unadjusted |sm_emot_supportRarely        |     1.507|     0.202|     2.027|   0.043|
|Unadjusted |sm_emot_supportSometimes     |     1.056|     0.225|     0.240|   0.810|
|Unadjusted |sm_emot_supportUsually       |     1.196|     0.322|     0.557|   0.578|
|Unadjusted |sm_emot_supportAlways        |     1.060|     0.777|     0.075|   0.940|
|Adjusted   |(Intercept)                  |     0.479|     0.162|    -4.540|   0.000|
|Adjusted   |sm_emot_supportRarely        |     1.318|     0.214|     1.292|   0.196|
|Adjusted   |sm_emot_supportSometimes     |     0.851|     0.245|    -0.657|   0.511|
|Adjusted   |sm_emot_supportUsually       |     0.964|     0.347|    -0.105|   0.917|
|Adjusted   |sm_emot_supportAlways        |     0.724|     0.867|    -0.372|   0.710|
|Adjusted   |countSocialMediaExclFB       |     1.041|     0.093|     0.430|   0.667|
|Adjusted   |indSuicideConsideredEverTRUE |     2.131|     0.192|     3.948|   0.000|
|Adjusted   |countSuicideAttempts         |     1.814|     0.164|     3.625|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       804.596|     583| -399.980| 809.960| 831.809|  799.960|         579|
|Adjusted   |       804.596|     583| -371.705| 759.409| 794.368|  743.409|         576|


### PC-PTSD vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.221|   4| 578|  0.301|
|Adjusted   | 1.147|   4| 575|  0.333|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.872|     0.166|    -0.827|   0.408|
|Unadjusted |sm_med_infoRarely            |     0.747|     0.225|    -1.293|   0.196|
|Unadjusted |sm_med_infoSometimes         |     1.095|     0.225|     0.402|   0.687|
|Unadjusted |sm_med_infoUsually           |     1.221|     0.300|     0.665|   0.506|
|Unadjusted |sm_med_infoAlways            |     0.706|     0.479|    -0.727|   0.467|
|Adjusted   |(Intercept)                  |     0.568|     0.188|    -3.002|   0.003|
|Adjusted   |sm_med_infoRarely            |     0.693|     0.238|    -1.544|   0.123|
|Adjusted   |sm_med_infoSometimes         |     1.036|     0.241|     0.147|   0.883|
|Adjusted   |sm_med_infoUsually           |     0.998|     0.323|    -0.005|   0.996|
|Adjusted   |sm_med_infoAlways            |     0.605|     0.530|    -0.948|   0.343|
|Adjusted   |countSocialMediaExclFB       |     1.033|     0.094|     0.345|   0.730|
|Adjusted   |indSuicideConsideredEverTRUE |     2.121|     0.191|     3.939|   0.000|
|Adjusted   |countSuicideAttempts         |     1.799|     0.162|     3.633|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.013|     582| -399.042| 808.084| 829.925|  798.084|         578|
|Adjusted   |       803.013|     582| -370.891| 757.781| 792.727|  741.781|         575|


### PC-PTSD vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.892|   4| 579|  0.110|
|Adjusted   | 1.918|   4| 576|  0.106|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.773|     0.134|    -1.920|   0.055|
|Unadjusted |sm_med_adviceRarely          |     0.970|     0.203|    -0.152|   0.880|
|Unadjusted |sm_med_adviceSometimes       |     1.274|     0.219|     1.104|   0.270|
|Unadjusted |sm_med_adviceUsually         |     2.032|     0.367|     1.931|   0.054|
|Unadjusted |sm_med_adviceAlways          |     0.388|     0.672|    -1.410|   0.159|
|Adjusted   |(Intercept)                  |     0.498|     0.160|    -4.368|   0.000|
|Adjusted   |sm_med_adviceRarely          |     0.881|     0.216|    -0.587|   0.557|
|Adjusted   |sm_med_adviceSometimes       |     1.181|     0.233|     0.713|   0.476|
|Adjusted   |sm_med_adviceUsually         |     1.775|     0.388|     1.479|   0.139|
|Adjusted   |sm_med_adviceAlways          |     0.234|     0.774|    -1.879|   0.060|
|Adjusted   |countSocialMediaExclFB       |     1.035|     0.093|     0.366|   0.714|
|Adjusted   |indSuicideConsideredEverTRUE |     2.146|     0.191|     3.991|   0.000|
|Adjusted   |countSuicideAttempts         |     1.820|     0.162|     3.698|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       804.596|     583| -398.260| 806.520| 828.370|  796.520|         579|
|Adjusted   |       804.596|     583| -369.332| 754.663| 789.623|  738.663|         576|


### PC-PTSD vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.187|   4| 579|  0.069|
|Adjusted   | 1.279|   4| 576|  0.277|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.720|     0.123|    -2.666|   0.008|
|Unadjusted |sm_med_questionsRarely       |     1.097|     0.198|     0.468|   0.640|
|Unadjusted |sm_med_questionsSometimes    |     1.309|     0.234|     1.150|   0.250|
|Unadjusted |sm_med_questionsUsually      |     3.057|     0.401|     2.787|   0.005|
|Unadjusted |sm_med_questionsAlways       |     1.667|     0.618|     0.827|   0.408|
|Adjusted   |(Intercept)                  |     0.464|     0.153|    -5.026|   0.000|
|Adjusted   |sm_med_questionsRarely       |     1.057|     0.210|     0.263|   0.793|
|Adjusted   |sm_med_questionsSometimes    |     1.263|     0.246|     0.949|   0.343|
|Adjusted   |sm_med_questionsUsually      |     2.487|     0.425|     2.146|   0.032|
|Adjusted   |sm_med_questionsAlways       |     1.184|     0.669|     0.252|   0.801|
|Adjusted   |countSocialMediaExclFB       |     1.009|     0.093|     0.096|   0.923|
|Adjusted   |indSuicideConsideredEverTRUE |     2.113|     0.191|     3.922|   0.000|
|Adjusted   |countSuicideAttempts         |     1.777|     0.164|     3.511|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       804.596|     583| -397.622| 805.243| 827.093|  795.243|         579|
|Adjusted   |       804.596|     583| -370.969| 757.939| 792.898|  741.939|         576|


### PC-PTSD vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 5.126|   4| 578|  0.000|
|Adjusted   | 2.812|   4| 575|  0.025|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.681|     0.116|    -3.325|   0.001|
|Unadjusted |sm_share_symptRarely         |     1.039|     0.201|     0.192|   0.848|
|Unadjusted |sm_share_symptSometimes      |     2.091|     0.255|     2.895|   0.004|
|Unadjusted |sm_share_symptUsually        |     4.824|     0.447|     3.522|   0.000|
|Unadjusted |sm_share_symptAlways         |     2.202|     0.656|     1.204|   0.229|
|Adjusted   |(Intercept)                  |     0.485|     0.141|    -5.135|   0.000|
|Adjusted   |sm_share_symptRarely         |     0.833|     0.215|    -0.847|   0.397|
|Adjusted   |sm_share_symptSometimes      |     1.508|     0.273|     1.502|   0.133|
|Adjusted   |sm_share_symptUsually        |     3.395|     0.465|     2.629|   0.009|
|Adjusted   |sm_share_symptAlways         |     1.353|     0.719|     0.420|   0.674|
|Adjusted   |countSocialMediaExclFB       |     1.033|     0.093|     0.349|   0.727|
|Adjusted   |indSuicideConsideredEverTRUE |     2.033|     0.196|     3.612|   0.000|
|Adjusted   |countSuicideAttempts         |     1.755|     0.166|     3.383|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.385|     582| -390.311| 790.621| 812.462|  780.621|         578|
|Adjusted   |       803.385|     582| -367.116| 750.232| 785.177|  734.232|         575|


### PC-PTSD vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.566|   4| 578|  0.007|
|Adjusted   | 2.427|   4| 575|  0.047|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.687|     0.122|    -3.089|   0.002|
|Unadjusted |sm_share_healthRarely        |     1.205|     0.187|     0.997|   0.319|
|Unadjusted |sm_share_healthSometimes     |     1.539|     0.265|     1.626|   0.104|
|Unadjusted |sm_share_healthUsually       |     9.222|     0.633|     3.509|   0.000|
|Unadjusted |sm_share_healthAlways        |     0.874|     0.740|    -0.182|   0.855|
|Adjusted   |(Intercept)                  |     0.489|     0.147|    -4.854|   0.000|
|Adjusted   |sm_share_healthRarely        |     0.975|     0.198|    -0.126|   0.900|
|Adjusted   |sm_share_healthSometimes     |     1.048|     0.288|     0.162|   0.871|
|Adjusted   |sm_share_healthUsually       |     6.431|     0.650|     2.862|   0.004|
|Adjusted   |sm_share_healthAlways        |     0.391|     0.878|    -1.071|   0.284|
|Adjusted   |countSocialMediaExclFB       |     1.031|     0.093|     0.334|   0.739|
|Adjusted   |indSuicideConsideredEverTRUE |     2.052|     0.195|     3.686|   0.000|
|Adjusted   |countSuicideAttempts         |     1.841|     0.169|     3.618|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       803.013|     582| -391.582| 793.164| 815.005|  783.164|         578|
|Adjusted   |       803.013|     582| -366.040| 748.080| 783.025|  732.080|         575|


### PC-PTSD vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 6.156|   4| 577|  0.000|
|Adjusted   | 3.962|   4| 574|  0.004|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.700|     0.091|    -3.922|   0.000|
|Unadjusted |sm_share_suicideRarely       |     3.017|     0.300|     3.678|   0.000|
|Unadjusted |sm_share_suicideSometimes    |     5.717|     0.652|     2.674|   0.007|
|Unadjusted |sm_share_suicideUsually      |    11.434|     1.065|     2.289|   0.022|
|Unadjusted |sm_share_suicideAlways       |     1.429|     1.004|     0.356|   0.722|
|Adjusted   |(Intercept)                  |     0.466|     0.131|    -5.805|   0.000|
|Adjusted   |sm_share_suicideRarely       |     2.388|     0.315|     2.763|   0.006|
|Adjusted   |sm_share_suicideSometimes    |     3.579|     0.681|     1.872|   0.061|
|Adjusted   |sm_share_suicideUsually      |    11.374|     1.072|     2.269|   0.023|
|Adjusted   |sm_share_suicideAlways       |     0.504|     1.214|    -0.565|   0.572|
|Adjusted   |countSocialMediaExclFB       |     1.029|     0.093|     0.309|   0.757|
|Adjusted   |indSuicideConsideredEverTRUE |     1.910|     0.194|     3.328|   0.001|
|Adjusted   |countSuicideAttempts         |     1.812|     0.167|     3.552|   0.000|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|    BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|------:|--------:|-----------:|
|Unadjusted |       802.171|     581| -385.954| 781.908| 803.74|  771.908|         577|
|Adjusted   |       802.171|     581| -363.009| 742.018| 776.95|  726.018|         574|


### PHQ-2 vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.540|   5| 577|  0.746|
|Adjusted   | 0.412|   5| 574|  0.840|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.111|     1.054|    -2.084|   0.037|
|Unadjusted |fb_freqEvery_few_weeks       |     0.000|   441.373|    -0.028|   0.978|
|Unadjusted |fb_freqOnce_a_week           |     4.500|     1.364|     1.103|   0.270|
|Unadjusted |fb_freqA_few_times_a_week    |     3.857|     1.109|     1.217|   0.224|
|Unadjusted |fb_freqOnce_a_day            |     4.500|     1.083|     1.388|   0.165|
|Unadjusted |fb_freqSeveral_times_a_day   |     3.375|     1.059|     1.148|   0.251|
|Adjusted   |(Intercept)                  |     0.075|     1.077|    -2.407|   0.016|
|Adjusted   |fb_freqEvery_few_weeks       |     0.000|   687.671|    -0.020|   0.984|
|Adjusted   |fb_freqOnce_a_week           |     3.834|     1.393|     0.965|   0.335|
|Adjusted   |fb_freqA_few_times_a_week    |     3.673|     1.130|     1.152|   0.250|
|Adjusted   |fb_freqOnce_a_day            |     3.477|     1.104|     1.129|   0.259|
|Adjusted   |fb_freqSeveral_times_a_day   |     2.804|     1.077|     0.957|   0.338|
|Adjusted   |countSocialMediaExclFB       |     0.869|     0.101|    -1.386|   0.166|
|Adjusted   |indSuicideConsideredEverTRUE |     3.191|     0.213|     5.451|   0.000|
|Adjusted   |countSuicideAttempts         |     1.297|     0.124|     2.107|   0.035|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       689.028|     582| -341.598| 695.196| 721.405|  683.196|         577|
|Adjusted   |       689.028|     582| -315.362| 648.725| 688.039|  630.725|         574|


### PHQ-2 vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.444|   4| 580|  0.777|
|Adjusted   | 0.899|   4| 577|  0.464|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.489|     0.254|    -2.808|   0.005|
|Unadjusted |comm_facebookOnce_a_week         |     1.022|     0.424|     0.051|   0.960|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.728|     0.329|    -0.963|   0.335|
|Unadjusted |comm_facebookOnce_a_day          |     0.806|     0.338|    -0.638|   0.524|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.742|     0.291|    -1.026|   0.305|
|Adjusted   |(Intercept)                      |     0.299|     0.286|    -4.228|   0.000|
|Adjusted   |comm_facebookOnce_a_week         |     0.967|     0.453|    -0.073|   0.942|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.584|     0.351|    -1.535|   0.125|
|Adjusted   |comm_facebookOnce_a_day          |     0.735|     0.359|    -0.860|   0.390|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.635|     0.311|    -1.460|   0.144|
|Adjusted   |countSocialMediaExclFB           |     0.886|     0.101|    -1.194|   0.232|
|Adjusted   |indSuicideConsideredEverTRUE     |     3.399|     0.215|     5.693|   0.000|
|Adjusted   |countSuicideAttempts             |     1.297|     0.123|     2.120|   0.034|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       694.133|     584| -346.194| 702.388| 724.246|  692.388|         580|
|Adjusted   |       694.133|     584| -317.610| 651.221| 686.194|  635.221|         577|


### PHQ-2 vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.943|   4| 580|  0.439|
|Adjusted   | 0.538|   4| 577|  0.708|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.344|     0.158|    -6.765|   0.000|
|Unadjusted |sm_emot_supportRarely        |     1.202|     0.225|     0.819|   0.413|
|Unadjusted |sm_emot_supportSometimes     |     1.232|     0.248|     0.844|   0.399|
|Unadjusted |sm_emot_supportUsually       |     0.969|     0.369|    -0.085|   0.932|
|Unadjusted |sm_emot_supportAlways        |     3.877|     0.780|     1.737|   0.082|
|Adjusted   |(Intercept)                  |     0.208|     0.193|    -8.142|   0.000|
|Adjusted   |sm_emot_supportRarely        |     1.046|     0.240|     0.187|   0.852|
|Adjusted   |sm_emot_supportSometimes     |     1.090|     0.269|     0.321|   0.749|
|Adjusted   |sm_emot_supportUsually       |     0.847|     0.395|    -0.420|   0.674|
|Adjusted   |sm_emot_supportAlways        |     3.045|     0.839|     1.327|   0.185|
|Adjusted   |countSocialMediaExclFB       |     0.876|     0.103|    -1.276|   0.202|
|Adjusted   |indSuicideConsideredEverTRUE |     3.196|     0.213|     5.449|   0.000|
|Adjusted   |countSuicideAttempts         |     1.316|     0.124|     2.209|   0.027|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       694.133|     584| -345.178| 700.355| 722.213|  690.355|         580|
|Adjusted   |       694.133|     584| -318.309| 652.618| 687.591|  636.618|         577|


### PHQ-2 vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.769|   4| 579|  0.134|
|Adjusted   | 1.665|   4| 576|  0.156|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.374|     0.185|    -5.309|   0.000|
|Unadjusted |sm_med_infoRarely            |     0.789|     0.257|    -0.923|   0.356|
|Unadjusted |sm_med_infoSometimes         |     1.224|     0.248|     0.817|   0.414|
|Unadjusted |sm_med_infoUsually           |     1.605|     0.318|     1.489|   0.137|
|Unadjusted |sm_med_infoAlways            |     0.629|     0.586|    -0.790|   0.429|
|Adjusted   |(Intercept)                  |     0.209|     0.223|    -7.026|   0.000|
|Adjusted   |sm_med_infoRarely            |     0.783|     0.270|    -0.905|   0.365|
|Adjusted   |sm_med_infoSometimes         |     1.320|     0.266|     1.042|   0.297|
|Adjusted   |sm_med_infoUsually           |     1.530|     0.343|     1.242|   0.214|
|Adjusted   |sm_med_infoAlways            |     0.650|     0.636|    -0.678|   0.498|
|Adjusted   |countSocialMediaExclFB       |     0.848|     0.104|    -1.576|   0.115|
|Adjusted   |indSuicideConsideredEverTRUE |     3.187|     0.214|     5.425|   0.000|
|Adjusted   |countSuicideAttempts         |     1.317|     0.123|     2.240|   0.025|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       691.585|     583| -342.218| 694.436| 716.285|  684.436|         579|
|Adjusted   |       691.585|     583| -315.254| 646.508| 681.467|  630.508|         576|


### PHQ-2 vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.008|   4| 580|  0.092|
|Adjusted   | 2.007|   4| 577|  0.092|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.349|     0.151|    -6.959|   0.000|
|Unadjusted |sm_med_adviceRarely          |     0.962|     0.231|    -0.168|   0.867|
|Unadjusted |sm_med_adviceSometimes       |     1.369|     0.239|     1.311|   0.190|
|Unadjusted |sm_med_adviceUsually         |     2.292|     0.368|     2.254|   0.024|
|Unadjusted |sm_med_adviceAlways          |     0.521|     0.783|    -0.833|   0.405|
|Adjusted   |(Intercept)                  |     0.200|     0.193|    -8.357|   0.000|
|Adjusted   |sm_med_adviceRarely          |     0.897|     0.245|    -0.444|   0.657|
|Adjusted   |sm_med_adviceSometimes       |     1.367|     0.255|     1.225|   0.221|
|Adjusted   |sm_med_adviceUsually         |     2.219|     0.394|     2.023|   0.043|
|Adjusted   |sm_med_adviceAlways          |     0.412|     0.844|    -1.052|   0.293|
|Adjusted   |countSocialMediaExclFB       |     0.854|     0.103|    -1.531|   0.126|
|Adjusted   |indSuicideConsideredEverTRUE |     3.239|     0.214|     5.497|   0.000|
|Adjusted   |countSuicideAttempts         |     1.326|     0.123|     2.301|   0.021|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       694.133|     584| -343.059| 696.119| 717.977|  686.119|         580|
|Adjusted   |       694.133|     584| -315.279| 646.557| 681.530|  630.557|         577|


### PHQ-2 vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.674|   4| 580|  0.031|
|Adjusted   | 2.069|   4| 577|  0.083|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.322|     0.142|    -8.008|   0.000|
|Unadjusted |sm_med_questionsRarely       |     1.118|     0.224|     0.498|   0.618|
|Unadjusted |sm_med_questionsSometimes    |     1.576|     0.254|     1.794|   0.073|
|Unadjusted |sm_med_questionsUsually      |     3.106|     0.381|     2.976|   0.003|
|Unadjusted |sm_med_questionsAlways       |     1.165|     0.692|     0.221|   0.825|
|Adjusted   |(Intercept)                  |     0.183|     0.187|    -9.074|   0.000|
|Adjusted   |sm_med_questionsRarely       |     1.169|     0.239|     0.655|   0.513|
|Adjusted   |sm_med_questionsSometimes    |     1.590|     0.268|     1.729|   0.084|
|Adjusted   |sm_med_questionsUsually      |     2.806|     0.410|     2.514|   0.012|
|Adjusted   |sm_med_questionsAlways       |     0.833|     0.740|    -0.248|   0.805|
|Adjusted   |countSocialMediaExclFB       |     0.843|     0.103|    -1.647|   0.100|
|Adjusted   |indSuicideConsideredEverTRUE |     3.205|     0.213|     5.460|   0.000|
|Adjusted   |countSuicideAttempts         |     1.301|     0.123|     2.135|   0.033|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       694.133|     584| -341.829| 693.659| 715.517|  683.659|         580|
|Adjusted   |       694.133|     584| -315.283| 646.566| 681.539|  630.566|         577|


### PHQ-2 vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 5.873|   4| 579|  0.000|
|Adjusted   | 2.989|   4| 576|  0.018|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.289|     0.136|    -9.140|   0.000|
|Unadjusted |sm_share_symptRarely         |     1.277|     0.228|     1.074|   0.283|
|Unadjusted |sm_share_symptSometimes      |     2.305|     0.266|     3.145|   0.002|
|Unadjusted |sm_share_symptUsually        |     5.186|     0.397|     4.150|   0.000|
|Unadjusted |sm_share_symptAlways         |     1.482|     0.703|     0.559|   0.576|
|Adjusted   |(Intercept)                  |     0.193|     0.173|    -9.490|   0.000|
|Adjusted   |sm_share_symptRarely         |     1.032|     0.241|     0.132|   0.895|
|Adjusted   |sm_share_symptSometimes      |     1.770|     0.286|     1.997|   0.046|
|Adjusted   |sm_share_symptUsually        |     3.415|     0.417|     2.949|   0.003|
|Adjusted   |sm_share_symptAlways         |     1.060|     0.763|     0.076|   0.939|
|Adjusted   |countSocialMediaExclFB       |     0.864|     0.104|    -1.402|   0.161|
|Adjusted   |indSuicideConsideredEverTRUE |     2.968|     0.218|     4.991|   0.000|
|Adjusted   |countSuicideAttempts         |     1.271|     0.126|     1.907|   0.057|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       693.474|     583| -334.855| 679.710| 701.559|  669.710|         579|
|Adjusted   |       693.474|     583| -313.196| 642.392| 677.351|  626.392|         576|


### PHQ-2 vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.838|   4| 579|  0.004|
|Adjusted   | 2.287|   4| 576|  0.059|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.313|     0.140|    -8.295|   0.000|
|Unadjusted |sm_share_healthRarely        |     1.359|     0.208|     1.474|   0.141|
|Unadjusted |sm_share_healthSometimes     |     1.405|     0.292|     1.167|   0.243|
|Unadjusted |sm_share_healthUsually       |     5.590|     0.465|     3.703|   0.000|
|Unadjusted |sm_share_healthAlways        |     0.456|     1.078|    -0.728|   0.467|
|Adjusted   |(Intercept)                  |     0.206|     0.178|    -8.885|   0.000|
|Adjusted   |sm_share_healthRarely        |     1.083|     0.221|     0.361|   0.718|
|Adjusted   |sm_share_healthSometimes     |     0.997|     0.316|    -0.010|   0.992|
|Adjusted   |sm_share_healthUsually       |     3.756|     0.494|     2.680|   0.007|
|Adjusted   |sm_share_healthAlways        |     0.238|     1.172|    -1.225|   0.221|
|Adjusted   |countSocialMediaExclFB       |     0.873|     0.103|    -1.327|   0.185|
|Adjusted   |indSuicideConsideredEverTRUE |     3.042|     0.216|     5.150|   0.000|
|Adjusted   |countSuicideAttempts         |     1.342|     0.127|     2.310|   0.021|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       693.474|     583| -338.623| 687.247| 709.096|  677.247|         579|
|Adjusted   |       693.474|     583| -314.162| 644.324| 679.284|  628.324|         576|


### PHQ-2 vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 7.700|   4| 578|  0.000|
|Adjusted   | 5.046|   4| 575|  0.001|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.313|     0.105|   -11.053|   0.000|
|Unadjusted |sm_share_suicideRarely       |     3.193|     0.287|     4.043|   0.000|
|Unadjusted |sm_share_suicideSometimes    |     4.790|     0.537|     2.915|   0.004|
|Unadjusted |sm_share_suicideUsually      |    11.176|     0.809|     2.985|   0.003|
|Unadjusted |sm_share_suicideAlways       |     1.064|     1.159|     0.054|   0.957|
|Adjusted   |(Intercept)                  |     0.195|     0.162|   -10.121|   0.000|
|Adjusted   |sm_share_suicideRarely       |     2.490|     0.304|     3.002|   0.003|
|Adjusted   |sm_share_suicideSometimes    |     3.191|     0.567|     2.047|   0.041|
|Adjusted   |sm_share_suicideUsually      |    10.560|     0.829|     2.844|   0.004|
|Adjusted   |sm_share_suicideAlways       |     0.413|     1.261|    -0.701|   0.483|
|Adjusted   |countSocialMediaExclFB       |     0.853|     0.105|    -1.519|   0.129|
|Adjusted   |indSuicideConsideredEverTRUE |     2.890|     0.217|     4.881|   0.000|
|Adjusted   |countSuicideAttempts         |     1.319|     0.128|     2.166|   0.030|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       692.814|     582| -330.038| 670.076| 691.917|  660.076|         578|
|Adjusted   |       692.814|     582| -308.051| 632.102| 667.047|  616.102|         575|


### AUDIT-C vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.332|   5| 575|  0.249|
|Adjusted   | 1.300|   5| 572|  0.262|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.111|     1.054|    -2.085|   0.037|
|Unadjusted |fb_freqEvery_few_weeks       |     3.000|     1.563|     0.703|   0.482|
|Unadjusted |fb_freqOnce_a_week           |     1.800|     1.520|     0.387|   0.699|
|Unadjusted |fb_freqA_few_times_a_week    |     4.667|     1.104|     1.395|   0.163|
|Unadjusted |fb_freqOnce_a_day            |     7.615|     1.080|     1.879|   0.060|
|Unadjusted |fb_freqSeveral_times_a_day   |     6.812|     1.058|     1.813|   0.070|
|Adjusted   |(Intercept)                  |     0.097|     1.058|    -2.206|   0.027|
|Adjusted   |fb_freqEvery_few_weeks       |     3.252|     1.566|     0.753|   0.452|
|Adjusted   |fb_freqOnce_a_week           |     1.681|     1.524|     0.341|   0.733|
|Adjusted   |fb_freqA_few_times_a_week    |     4.673|     1.106|     1.394|   0.163|
|Adjusted   |fb_freqOnce_a_day            |     7.571|     1.083|     1.870|   0.062|
|Adjusted   |fb_freqSeveral_times_a_day   |     6.710|     1.060|     1.795|   0.073|
|Adjusted   |countSocialMediaExclFB       |     1.056|     0.087|     0.623|   0.533|
|Adjusted   |indSuicideConsideredEverTRUE |     1.393|     0.188|     1.764|   0.078|
|Adjusted   |countSuicideAttempts         |     0.893|     0.122|    -0.931|   0.352|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       789.833|     580| -390.408| 792.816| 819.004|  780.816|         575|
|Adjusted   |       789.833|     580| -388.542| 795.084| 834.366|  777.084|         572|


### AUDIT-C vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.095|   4| 578|  0.358|
|Adjusted   | 1.082|   4| 575|  0.365|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.892|     0.239|    -0.478|   0.633|
|Unadjusted |comm_facebookOnce_a_week         |     0.561|     0.416|    -1.393|   0.164|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.785|     0.303|    -0.799|   0.425|
|Unadjusted |comm_facebookOnce_a_day          |     0.605|     0.320|    -1.568|   0.117|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.888|     0.270|    -0.441|   0.659|
|Adjusted   |(Intercept)                      |     0.798|     0.250|    -0.902|   0.367|
|Adjusted   |comm_facebookOnce_a_week         |     0.562|     0.417|    -1.383|   0.167|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.742|     0.306|    -0.974|   0.330|
|Adjusted   |comm_facebookOnce_a_day          |     0.583|     0.322|    -1.674|   0.094|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.848|     0.273|    -0.605|   0.545|
|Adjusted   |countSocialMediaExclFB           |     1.049|     0.087|     0.552|   0.581|
|Adjusted   |indSuicideConsideredEverTRUE     |     1.396|     0.188|     1.775|   0.076|
|Adjusted   |countSuicideAttempts             |     0.899|     0.121|    -0.876|   0.381|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       791.995|     582| -393.769| 797.538| 819.379|  787.538|         578|
|Adjusted   |       791.995|     582| -391.937| 799.874| 834.819|  783.874|         575|


### AUDIT-C vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.811|   4| 578|  0.518|
|Adjusted   | 0.664|   4| 575|  0.617|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.648|     0.141|    -3.074|   0.002|
|Unadjusted |sm_emot_supportRarely        |     1.273|     0.203|     1.186|   0.236|
|Unadjusted |sm_emot_supportSometimes     |     1.131|     0.227|     0.543|   0.587|
|Unadjusted |sm_emot_supportUsually       |     0.796|     0.339|    -0.674|   0.500|
|Unadjusted |sm_emot_supportAlways        |     2.056|     0.777|     0.928|   0.353|
|Adjusted   |(Intercept)                  |     0.580|     0.157|    -3.472|   0.001|
|Adjusted   |sm_emot_supportRarely        |     1.211|     0.207|     0.923|   0.356|
|Adjusted   |sm_emot_supportSometimes     |     1.053|     0.235|     0.220|   0.826|
|Adjusted   |sm_emot_supportUsually       |     0.784|     0.343|    -0.711|   0.477|
|Adjusted   |sm_emot_supportAlways        |     2.040|     0.782|     0.911|   0.362|
|Adjusted   |countSocialMediaExclFB       |     1.063|     0.089|     0.683|   0.494|
|Adjusted   |indSuicideConsideredEverTRUE |     1.346|     0.188|     1.584|   0.113|
|Adjusted   |countSuicideAttempts         |     0.913|     0.121|    -0.755|   0.450|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       791.995|     582| -394.354| 798.708| 820.549|  788.708|         578|
|Adjusted   |       791.995|     582| -392.787| 801.573| 836.519|  785.573|         575|


### AUDIT-C vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.962|   4| 577|  0.428|
|Adjusted   | 1.132|   4| 574|  0.340|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.873|     0.165|    -0.821|   0.411|
|Unadjusted |sm_med_infoRarely            |     0.788|     0.224|    -1.060|   0.289|
|Unadjusted |sm_med_infoSometimes         |     0.821|     0.227|    -0.870|   0.384|
|Unadjusted |sm_med_infoUsually           |     0.642|     0.308|    -1.436|   0.151|
|Unadjusted |sm_med_infoAlways            |     0.458|     0.510|    -1.530|   0.126|
|Adjusted   |(Intercept)                  |     0.758|     0.182|    -1.528|   0.126|
|Adjusted   |sm_med_infoRarely            |     0.765|     0.227|    -1.184|   0.237|
|Adjusted   |sm_med_infoSometimes         |     0.771|     0.234|    -1.112|   0.266|
|Adjusted   |sm_med_infoUsually           |     0.587|     0.316|    -1.682|   0.093|
|Adjusted   |sm_med_infoAlways            |     0.445|     0.519|    -1.562|   0.118|
|Adjusted   |countSocialMediaExclFB       |     1.110|     0.090|     1.170|   0.242|
|Adjusted   |indSuicideConsideredEverTRUE |     1.353|     0.188|     1.613|   0.107|
|Adjusted   |countSuicideAttempts         |     0.924|     0.122|    -0.650|   0.516|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.243|     581| -393.140| 796.279| 818.112|  786.279|         577|
|Adjusted   |       790.243|     581| -390.972| 797.944| 832.876|  781.944|         574|


### AUDIT-C vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.384|   4| 578|  0.238|
|Adjusted   | 1.613|   4| 575|  0.169|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.854|     0.133|    -1.191|   0.234|
|Unadjusted |sm_med_adviceRarely          |     0.692|     0.205|    -1.792|   0.073|
|Unadjusted |sm_med_adviceSometimes       |     0.796|     0.222|    -1.027|   0.304|
|Unadjusted |sm_med_adviceUsually         |     1.048|     0.359|     0.131|   0.896|
|Unadjusted |sm_med_adviceAlways          |     0.351|     0.672|    -1.557|   0.119|
|Adjusted   |(Intercept)                  |     0.735|     0.153|    -2.020|   0.043|
|Adjusted   |sm_med_adviceRarely          |     0.653|     0.209|    -2.041|   0.041|
|Adjusted   |sm_med_adviceSometimes       |     0.756|     0.226|    -1.238|   0.216|
|Adjusted   |sm_med_adviceUsually         |     0.961|     0.365|    -0.110|   0.912|
|Adjusted   |sm_med_adviceAlways          |     0.330|     0.679|    -1.635|   0.102|
|Adjusted   |countSocialMediaExclFB       |     1.098|     0.088|     1.055|   0.292|
|Adjusted   |indSuicideConsideredEverTRUE |     1.404|     0.188|     1.806|   0.071|
|Adjusted   |countSuicideAttempts         |     0.912|     0.122|    -0.752|   0.452|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       791.995|     582| -393.098| 796.197| 818.037|  786.197|         578|
|Adjusted   |       791.995|     582| -390.761| 797.523| 832.468|  781.523|         575|


### AUDIT-C vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.048|   4| 578|  0.382|
|Adjusted   | 1.142|   4| 575|  0.336|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.783|     0.122|    -2.000|   0.046|
|Unadjusted |sm_med_questionsRarely       |     0.903|     0.198|    -0.513|   0.608|
|Unadjusted |sm_med_questionsSometimes    |     0.688|     0.243|    -1.542|   0.123|
|Unadjusted |sm_med_questionsUsually      |     1.277|     0.374|     0.654|   0.513|
|Unadjusted |sm_med_questionsAlways       |     0.479|     0.688|    -1.070|   0.285|
|Adjusted   |(Intercept)                  |     0.676|     0.146|    -2.683|   0.007|
|Adjusted   |sm_med_questionsRarely       |     0.873|     0.202|    -0.674|   0.501|
|Adjusted   |sm_med_questionsSometimes    |     0.662|     0.245|    -1.684|   0.092|
|Adjusted   |sm_med_questionsUsually      |     1.194|     0.381|     0.464|   0.642|
|Adjusted   |sm_med_questionsAlways       |     0.446|     0.694|    -1.162|   0.245|
|Adjusted   |countSocialMediaExclFB       |     1.075|     0.088|     0.819|   0.413|
|Adjusted   |indSuicideConsideredEverTRUE |     1.399|     0.187|     1.793|   0.073|
|Adjusted   |countSuicideAttempts         |     0.905|     0.122|    -0.824|   0.410|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       791.995|     582| -393.841| 797.682| 819.523|  787.682|         578|
|Adjusted   |       791.995|     582| -391.772| 799.544| 834.490|  783.544|         575|


### AUDIT-C vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.574|   4| 577|  0.180|
|Adjusted   | 1.596|   4| 574|  0.174|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.699|     0.115|    -3.102|   0.002|
|Unadjusted |sm_share_symptRarely         |     1.321|     0.199|     1.399|   0.162|
|Unadjusted |sm_share_symptSometimes      |     0.904|     0.257|    -0.391|   0.696|
|Unadjusted |sm_share_symptUsually        |     0.455|     0.449|    -1.754|   0.079|
|Unadjusted |sm_share_symptAlways         |     0.953|     0.656|    -0.073|   0.942|
|Adjusted   |(Intercept)                  |     0.616|     0.136|    -3.573|   0.000|
|Adjusted   |sm_share_symptRarely         |     1.216|     0.205|     0.956|   0.339|
|Adjusted   |sm_share_symptSometimes      |     0.829|     0.266|    -0.706|   0.480|
|Adjusted   |sm_share_symptUsually        |     0.404|     0.457|    -1.985|   0.047|
|Adjusted   |sm_share_symptAlways         |     0.859|     0.671|    -0.226|   0.821|
|Adjusted   |countSocialMediaExclFB       |     1.054|     0.088|     0.598|   0.550|
|Adjusted   |indSuicideConsideredEverTRUE |     1.415|     0.192|     1.810|   0.070|
|Adjusted   |countSuicideAttempts         |     0.935|     0.123|    -0.548|   0.584|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.916|     581| -392.086| 794.173| 816.005|  784.173|         577|
|Adjusted   |       790.916|     581| -390.184| 796.369| 831.300|  780.369|         574|


### AUDIT-C vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.948|   4| 577|  0.435|
|Adjusted   | 1.068|   4| 574|  0.371|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.735|     0.121|    -2.555|   0.011|
|Unadjusted |sm_share_healthRarely        |     1.048|     0.187|     0.251|   0.801|
|Unadjusted |sm_share_healthSometimes     |     0.769|     0.273|    -0.958|   0.338|
|Unadjusted |sm_share_healthUsually       |     1.238|     0.453|     0.470|   0.638|
|Unadjusted |sm_share_healthAlways        |     0.194|     1.076|    -1.522|   0.128|
|Adjusted   |(Intercept)                  |     0.637|     0.142|    -3.187|   0.001|
|Adjusted   |sm_share_healthRarely        |     0.989|     0.190|    -0.056|   0.955|
|Adjusted   |sm_share_healthSometimes     |     0.687|     0.284|    -1.323|   0.186|
|Adjusted   |sm_share_healthUsually       |     1.096|     0.462|     0.198|   0.843|
|Adjusted   |sm_share_healthAlways        |     0.184|     1.086|    -1.558|   0.119|
|Adjusted   |countSocialMediaExclFB       |     1.087|     0.088|     0.951|   0.342|
|Adjusted   |indSuicideConsideredEverTRUE |     1.382|     0.190|     1.705|   0.088|
|Adjusted   |countSuicideAttempts         |     0.943|     0.123|    -0.476|   0.634|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       790.916|     581| -393.044| 796.089| 817.921|  786.089|         577|
|Adjusted   |       790.916|     581| -391.015| 798.030| 832.961|  782.030|         574|


### AUDIT-C vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.717|   4| 576|  0.580|
|Adjusted   | 0.541|   4| 573|  0.706|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.688|     0.091|    -4.099|   0.000|
|Unadjusted |sm_share_suicideRarely       |     1.561|     0.283|     1.576|   0.115|
|Unadjusted |sm_share_suicideSometimes    |     1.453|     0.542|     0.689|   0.491|
|Unadjusted |sm_share_suicideUsually      |     1.163|     0.677|     0.222|   0.824|
|Unadjusted |sm_share_suicideAlways       |     0.000|   441.372|    -0.032|   0.974|
|Adjusted   |(Intercept)                  |     0.605|     0.125|    -4.005|   0.000|
|Adjusted   |sm_share_suicideRarely       |     1.498|     0.287|     1.406|   0.160|
|Adjusted   |sm_share_suicideSometimes    |     1.351|     0.552|     0.545|   0.586|
|Adjusted   |sm_share_suicideUsually      |     1.055|     0.682|     0.079|   0.937|
|Adjusted   |sm_share_suicideAlways       |     0.000|   438.789|    -0.032|   0.974|
|Adjusted   |countSocialMediaExclFB       |     1.059|     0.087|     0.657|   0.511|
|Adjusted   |indSuicideConsideredEverTRUE |     1.322|     0.189|     1.476|   0.140|
|Adjusted   |countSuicideAttempts         |     0.914|     0.126|    -0.712|   0.476|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       789.833|     580| -391.308| 792.615| 814.439|  782.615|         576|
|Adjusted   |       789.833|     580| -389.911| 795.822| 830.740|  779.822|         573|


### DSI-SS vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.523|   5| 577|  0.759|
|Adjusted   | 0.659|   5| 574|  0.655|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.250|     0.791|    -1.754|   0.080|
|Unadjusted |fb_freqEvery_few_weeks       |     4.000|     1.275|     1.087|   0.277|
|Unadjusted |fb_freqOnce_a_week           |     0.800|     1.351|    -0.165|   0.869|
|Unadjusted |fb_freqA_few_times_a_week    |     0.824|     0.893|    -0.217|   0.828|
|Unadjusted |fb_freqOnce_a_day            |     1.333|     0.836|     0.344|   0.731|
|Unadjusted |fb_freqSeveral_times_a_day   |     1.172|     0.799|     0.199|   0.842|
|Adjusted   |(Intercept)                  |     0.124|     0.854|    -2.443|   0.015|
|Adjusted   |fb_freqEvery_few_weeks       |     5.146|     1.376|     1.191|   0.234|
|Adjusted   |fb_freqOnce_a_week           |     0.536|     1.420|    -0.439|   0.661|
|Adjusted   |fb_freqA_few_times_a_week    |     0.660|     0.953|    -0.436|   0.663|
|Adjusted   |fb_freqOnce_a_day            |     0.828|     0.897|    -0.210|   0.833|
|Adjusted   |fb_freqSeveral_times_a_day   |     0.802|     0.854|    -0.259|   0.796|
|Adjusted   |countSocialMediaExclFB       |     0.969|     0.106|    -0.293|   0.769|
|Adjusted   |indSuicideConsideredEverTRUE |     5.757|     0.248|     7.063|   0.000|
|Adjusted   |countSuicideAttempts         |     1.330|     0.123|     2.310|   0.021|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       623.703|     582| -310.555| 633.109| 659.318|  621.109|         577|
|Adjusted   |       623.703|     582| -267.052| 552.104| 591.418|  534.104|         574|


### DSI-SS vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.644|   4| 580|  0.631|
|Adjusted   | 1.060|   4| 577|  0.376|

\newline


|model      |term                             | oddsratio| std.error| statistic| p.value|
|:----------|:--------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                      |     0.373|     0.269|    -3.674|   0.000|
|Unadjusted |comm_facebookOnce_a_week         |     0.805|     0.465|    -0.465|   0.642|
|Unadjusted |comm_facebookA_few_times_a_week  |     0.946|     0.340|    -0.164|   0.869|
|Unadjusted |comm_facebookOnce_a_day          |     0.688|     0.368|    -1.017|   0.309|
|Unadjusted |comm_facebookSeveral_times_a_day |     0.691|     0.310|    -1.195|   0.232|
|Adjusted   |(Intercept)                      |     0.159|     0.325|    -5.653|   0.000|
|Adjusted   |comm_facebookOnce_a_week         |     0.705|     0.516|    -0.678|   0.498|
|Adjusted   |comm_facebookA_few_times_a_week  |     0.701|     0.377|    -0.943|   0.346|
|Adjusted   |comm_facebookOnce_a_day          |     0.569|     0.404|    -1.397|   0.163|
|Adjusted   |comm_facebookSeveral_times_a_day |     0.513|     0.346|    -1.930|   0.054|
|Adjusted   |countSocialMediaExclFB           |     0.983|     0.107|    -0.156|   0.876|
|Adjusted   |indSuicideConsideredEverTRUE     |     5.781|     0.249|     7.045|   0.000|
|Adjusted   |countSuicideAttempts             |     1.315|     0.122|     2.245|   0.025|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.728|     584| -311.091| 632.182| 654.040|  622.182|         580|
|Adjusted   |       624.728|     584| -267.724| 551.449| 586.422|  535.449|         577|


### DSI-SS vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.450|   4| 580|  0.772|
|Adjusted   | 0.669|   4| 577|  0.614|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.269|     0.168|    -7.807|   0.000|
|Unadjusted |sm_emot_supportRarely        |     1.282|     0.237|     1.046|   0.296|
|Unadjusted |sm_emot_supportSometimes     |     0.963|     0.274|    -0.136|   0.892|
|Unadjusted |sm_emot_supportUsually       |     1.103|     0.382|     0.257|   0.797|
|Unadjusted |sm_emot_supportAlways        |     0.619|     1.093|    -0.440|   0.660|
|Adjusted   |(Intercept)                  |     0.110|     0.232|    -9.525|   0.000|
|Adjusted   |sm_emot_supportRarely        |     0.999|     0.262|    -0.005|   0.996|
|Adjusted   |sm_emot_supportSometimes     |     0.697|     0.308|    -1.172|   0.241|
|Adjusted   |sm_emot_supportUsually       |     0.871|     0.428|    -0.323|   0.747|
|Adjusted   |sm_emot_supportAlways        |     0.295|     1.196|    -1.021|   0.307|
|Adjusted   |countSocialMediaExclFB       |     0.983|     0.109|    -0.152|   0.879|
|Adjusted   |indSuicideConsideredEverTRUE |     5.674|     0.247|     7.017|   0.000|
|Adjusted   |countSuicideAttempts         |     1.339|     0.123|     2.379|   0.017|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.728|     584| -311.454| 632.907| 654.765|  622.907|         580|
|Adjusted   |       624.728|     584| -268.357| 552.715| 587.688|  536.715|         577|


### DSI-SS vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.758|   4| 579|  0.553|
|Adjusted   | 0.963|   4| 576|  0.427|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.287|     0.197|    -6.322|   0.000|
|Unadjusted |sm_med_infoRarely            |     1.196|     0.261|     0.686|   0.493|
|Unadjusted |sm_med_infoSometimes         |     0.929|     0.272|    -0.269|   0.788|
|Unadjusted |sm_med_infoUsually           |     1.067|     0.355|     0.182|   0.856|
|Unadjusted |sm_med_infoAlways            |     0.367|     0.769|    -1.304|   0.192|
|Adjusted   |(Intercept)                  |     0.104|     0.265|    -8.543|   0.000|
|Adjusted   |sm_med_infoRarely            |     1.195|     0.286|     0.624|   0.533|
|Adjusted   |sm_med_infoSometimes         |     0.875|     0.302|    -0.442|   0.659|
|Adjusted   |sm_med_infoUsually           |     0.814|     0.394|    -0.521|   0.602|
|Adjusted   |sm_med_infoAlways            |     0.295|     0.847|    -1.442|   0.149|
|Adjusted   |countSocialMediaExclFB       |     0.984|     0.110|    -0.146|   0.884|
|Adjusted   |indSuicideConsideredEverTRUE |     5.522|     0.246|     6.935|   0.000|
|Adjusted   |countSuicideAttempts         |     1.367|     0.124|     2.518|   0.012|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.216|     583| -310.298| 630.597| 652.446|  620.597|         579|
|Adjusted   |       624.216|     583| -267.051| 550.103| 585.062|  534.103|         576|


### DSI-SS vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.612|   4| 580|  0.654|
|Adjusted   | 0.911|   4| 577|  0.457|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.301|     0.157|    -7.660|   0.000|
|Unadjusted |sm_med_adviceRarely          |     1.016|     0.237|     0.067|   0.947|
|Unadjusted |sm_med_adviceSometimes       |     0.854|     0.267|    -0.592|   0.554|
|Unadjusted |sm_med_adviceUsually         |     1.277|     0.404|     0.606|   0.544|
|Unadjusted |sm_med_adviceAlways          |     0.277|     1.052|    -1.221|   0.222|
|Adjusted   |(Intercept)                  |     0.115|     0.227|    -9.526|   0.000|
|Adjusted   |sm_med_adviceRarely          |     0.872|     0.261|    -0.523|   0.601|
|Adjusted   |sm_med_adviceSometimes       |     0.721|     0.294|    -1.111|   0.267|
|Adjusted   |sm_med_adviceUsually         |     0.993|     0.445|    -0.016|   0.987|
|Adjusted   |sm_med_adviceAlways          |     0.162|     1.124|    -1.621|   0.105|
|Adjusted   |countSocialMediaExclFB       |     0.986|     0.108|    -0.128|   0.898|
|Adjusted   |indSuicideConsideredEverTRUE |     5.584|     0.247|     6.976|   0.000|
|Adjusted   |countSuicideAttempts         |     1.355|     0.123|     2.465|   0.014|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.728|     584| -310.834| 631.669| 653.527|  621.669|         580|
|Adjusted   |       624.728|     584| -267.485| 550.970| 585.943|  534.970|         577|


### DSI-SS vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.675|   4| 580|  0.609|
|Adjusted   | 0.704|   4| 577|  0.589|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.289|     0.145|    -8.537|   0.000|
|Unadjusted |sm_med_questionsRarely       |     0.929|     0.237|    -0.309|   0.757|
|Unadjusted |sm_med_questionsSometimes    |     1.092|     0.276|     0.320|   0.749|
|Unadjusted |sm_med_questionsUsually      |     1.572|     0.408|     1.109|   0.268|
|Unadjusted |sm_med_questionsAlways       |     0.346|     1.059|    -1.003|   0.316|
|Adjusted   |(Intercept)                  |     0.107|     0.222|   -10.080|   0.000|
|Adjusted   |sm_med_questionsRarely       |     0.878|     0.263|    -0.495|   0.621|
|Adjusted   |sm_med_questionsSometimes    |     0.987|     0.300|    -0.044|   0.965|
|Adjusted   |sm_med_questionsUsually      |     1.079|     0.456|     0.167|   0.867|
|Adjusted   |sm_med_questionsAlways       |     0.169|     1.117|    -1.592|   0.111|
|Adjusted   |countSocialMediaExclFB       |     0.972|     0.109|    -0.259|   0.796|
|Adjusted   |indSuicideConsideredEverTRUE |     5.594|     0.246|     7.004|   0.000|
|Adjusted   |countSuicideAttempts         |     1.348|     0.124|     2.419|   0.016|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.728|     584| -310.875| 631.750| 653.608|  621.750|         580|
|Adjusted   |       624.728|     584| -267.860| 551.721| 586.694|  535.721|         577|


### DSI-SS vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 4.017|   4| 579|  0.003|
|Adjusted   | 1.201|   4| 576|  0.309|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.204|     0.151|   -10.553|   0.000|
|Unadjusted |sm_share_symptRarely         |     1.890|     0.236|     2.698|   0.007|
|Unadjusted |sm_share_symptSometimes      |     2.102|     0.287|     2.591|   0.010|
|Unadjusted |sm_share_symptUsually        |     3.270|     0.402|     2.948|   0.003|
|Unadjusted |sm_share_symptAlways         |     0.545|     1.065|    -0.570|   0.569|
|Adjusted   |(Intercept)                  |     0.092|     0.217|   -10.982|   0.000|
|Adjusted   |sm_share_symptRarely         |     1.388|     0.257|     1.275|   0.202|
|Adjusted   |sm_share_symptSometimes      |     1.320|     0.319|     0.872|   0.383|
|Adjusted   |sm_share_symptUsually        |     1.721|     0.436|     1.244|   0.214|
|Adjusted   |sm_share_symptAlways         |     0.238|     1.140|    -1.259|   0.208|
|Adjusted   |countSocialMediaExclFB       |     0.963|     0.108|    -0.347|   0.729|
|Adjusted   |indSuicideConsideredEverTRUE |     5.121|     0.249|     6.549|   0.000|
|Adjusted   |countSuicideAttempts         |     1.348|     0.126|     2.378|   0.017|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.216|     583| -303.939| 617.879| 639.728|  607.879|         579|
|Adjusted   |       624.216|     583| -266.921| 549.843| 584.802|  533.843|         576|


### DSI-SS vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.175|   4| 579|  0.014|
|Adjusted   | 1.302|   4| 576|  0.268|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.226|     0.154|    -9.683|   0.000|
|Unadjusted |sm_share_healthRarely        |     1.595|     0.222|     2.103|   0.035|
|Unadjusted |sm_share_healthSometimes     |     1.264|     0.322|     0.726|   0.468|
|Unadjusted |sm_share_healthUsually       |     4.423|     0.453|     3.281|   0.001|
|Unadjusted |sm_share_healthAlways        |     0.000|   514.561|    -0.027|   0.978|
|Adjusted   |(Intercept)                  |     0.099|     0.221|   -10.461|   0.000|
|Adjusted   |sm_share_healthRarely        |     1.149|     0.243|     0.570|   0.568|
|Adjusted   |sm_share_healthSometimes     |     0.689|     0.361|    -1.031|   0.303|
|Adjusted   |sm_share_healthUsually       |     2.359|     0.502|     1.709|   0.087|
|Adjusted   |sm_share_healthAlways        |     0.000|   728.350|    -0.022|   0.983|
|Adjusted   |countSocialMediaExclFB       |     0.984|     0.108|    -0.148|   0.882|
|Adjusted   |indSuicideConsideredEverTRUE |     5.319|     0.249|     6.703|   0.000|
|Adjusted   |countSuicideAttempts         |     1.416|     0.130|     2.673|   0.008|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       624.216|     583| -303.827| 617.655| 639.504|  607.655|         579|
|Adjusted   |       624.216|     583| -263.632| 543.265| 578.224|  527.265|         576|


### DSI-SS vs Share thoughts about suicide or hurting yourself in some way


|model      |      F| df1| df2| pValue|
|:----------|------:|---:|---:|------:|
|Unadjusted | 11.005|   4| 578|      0|
|Adjusted   |  6.523|   4| 575|      0|

\newline


|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.217|     0.117|   -13.062|   0.000|
|Unadjusted |sm_share_suicideRarely       |     5.315|     0.292|     5.714|   0.000|
|Unadjusted |sm_share_suicideSometimes    |     5.265|     0.531|     3.131|   0.002|
|Unadjusted |sm_share_suicideUsually      |     5.758|     0.681|     2.571|   0.010|
|Unadjusted |sm_share_suicideAlways       |     0.000|   727.699|    -0.019|   0.985|
|Adjusted   |(Intercept)                  |     0.087|     0.209|   -11.638|   0.000|
|Adjusted   |sm_share_suicideRarely       |     4.229|     0.322|     4.484|   0.000|
|Adjusted   |sm_share_suicideSometimes    |     2.966|     0.576|     1.888|   0.059|
|Adjusted   |sm_share_suicideUsually      |     5.198|     0.731|     2.256|   0.024|
|Adjusted   |sm_share_suicideAlways       |     0.000|   641.563|    -0.024|   0.981|
|Adjusted   |countSocialMediaExclFB       |     0.928|     0.111|    -0.669|   0.503|
|Adjusted   |indSuicideConsideredEverTRUE |     4.974|     0.252|     6.355|   0.000|
|Adjusted   |countSuicideAttempts         |     1.359|     0.133|     2.300|   0.021|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       623.703|     582| -289.197| 588.394| 610.235|  578.394|         578|
|Adjusted   |       623.703|     582| -254.092| 524.184| 559.129|  508.184|         575|


## F-tests


|depvar    |indepvar         |model      |      F| df1| df2| pValue|indSig |
|:---------|:----------------|:----------|------:|---:|---:|------:|:------|
|indPTSD   |fb_freq          |Unadjusted |  1.333|   5| 576|  0.248|.      |
|indPTSD   |fb_freq          |Adjusted   |  1.388|   5| 573|  0.227|.      |
|indPTSD   |comm_facebook    |Unadjusted |  1.456|   4| 579|  0.214|.      |
|indPTSD   |comm_facebook    |Adjusted   |  2.056|   4| 576|  0.085|.      |
|indPTSD   |sm_emot_support  |Unadjusted |  1.156|   4| 579|  0.329|.      |
|indPTSD   |sm_emot_support  |Adjusted   |  0.959|   4| 576|  0.429|.      |
|indPTSD   |sm_med_info      |Unadjusted |  1.221|   4| 578|  0.301|.      |
|indPTSD   |sm_med_info      |Adjusted   |  1.147|   4| 575|  0.333|.      |
|indPTSD   |sm_med_advice    |Unadjusted |  1.892|   4| 579|  0.110|.      |
|indPTSD   |sm_med_advice    |Adjusted   |  1.918|   4| 576|  0.106|.      |
|indPTSD   |sm_med_questions |Unadjusted |  2.187|   4| 579|  0.069|.      |
|indPTSD   |sm_med_questions |Adjusted   |  1.279|   4| 576|  0.277|.      |
|indPTSD   |sm_share_sympt   |Unadjusted |  5.126|   4| 578|  0.000|***    |
|indPTSD   |sm_share_sympt   |Adjusted   |  2.812|   4| 575|  0.025|*      |
|indPTSD   |sm_share_health  |Unadjusted |  3.566|   4| 578|  0.007|**     |
|indPTSD   |sm_share_health  |Adjusted   |  2.427|   4| 575|  0.047|*      |
|indPTSD   |sm_share_suicide |Unadjusted |  6.156|   4| 577|  0.000|***    |
|indPTSD   |sm_share_suicide |Adjusted   |  3.962|   4| 574|  0.004|**     |
|indPHQ    |fb_freq          |Unadjusted |  0.540|   5| 577|  0.746|.      |
|indPHQ    |fb_freq          |Adjusted   |  0.412|   5| 574|  0.840|.      |
|indPHQ    |comm_facebook    |Unadjusted |  0.444|   4| 580|  0.777|.      |
|indPHQ    |comm_facebook    |Adjusted   |  0.899|   4| 577|  0.464|.      |
|indPHQ    |sm_emot_support  |Unadjusted |  0.943|   4| 580|  0.439|.      |
|indPHQ    |sm_emot_support  |Adjusted   |  0.538|   4| 577|  0.708|.      |
|indPHQ    |sm_med_info      |Unadjusted |  1.769|   4| 579|  0.134|.      |
|indPHQ    |sm_med_info      |Adjusted   |  1.665|   4| 576|  0.156|.      |
|indPHQ    |sm_med_advice    |Unadjusted |  2.008|   4| 580|  0.092|.      |
|indPHQ    |sm_med_advice    |Adjusted   |  2.007|   4| 577|  0.092|.      |
|indPHQ    |sm_med_questions |Unadjusted |  2.674|   4| 580|  0.031|*      |
|indPHQ    |sm_med_questions |Adjusted   |  2.069|   4| 577|  0.083|.      |
|indPHQ    |sm_share_sympt   |Unadjusted |  5.873|   4| 579|  0.000|***    |
|indPHQ    |sm_share_sympt   |Adjusted   |  2.989|   4| 576|  0.018|*      |
|indPHQ    |sm_share_health  |Unadjusted |  3.838|   4| 579|  0.004|**     |
|indPHQ    |sm_share_health  |Adjusted   |  2.287|   4| 576|  0.059|.      |
|indPHQ    |sm_share_suicide |Unadjusted |  7.700|   4| 578|  0.000|***    |
|indPHQ    |sm_share_suicide |Adjusted   |  5.046|   4| 575|  0.001|***    |
|indAuditC |fb_freq          |Unadjusted |  1.332|   5| 575|  0.249|.      |
|indAuditC |fb_freq          |Adjusted   |  1.300|   5| 572|  0.262|.      |
|indAuditC |comm_facebook    |Unadjusted |  1.095|   4| 578|  0.358|.      |
|indAuditC |comm_facebook    |Adjusted   |  1.082|   4| 575|  0.365|.      |
|indAuditC |sm_emot_support  |Unadjusted |  0.811|   4| 578|  0.518|.      |
|indAuditC |sm_emot_support  |Adjusted   |  0.664|   4| 575|  0.617|.      |
|indAuditC |sm_med_info      |Unadjusted |  0.962|   4| 577|  0.428|.      |
|indAuditC |sm_med_info      |Adjusted   |  1.132|   4| 574|  0.340|.      |
|indAuditC |sm_med_advice    |Unadjusted |  1.384|   4| 578|  0.238|.      |
|indAuditC |sm_med_advice    |Adjusted   |  1.613|   4| 575|  0.169|.      |
|indAuditC |sm_med_questions |Unadjusted |  1.048|   4| 578|  0.382|.      |
|indAuditC |sm_med_questions |Adjusted   |  1.142|   4| 575|  0.336|.      |
|indAuditC |sm_share_sympt   |Unadjusted |  1.574|   4| 577|  0.180|.      |
|indAuditC |sm_share_sympt   |Adjusted   |  1.596|   4| 574|  0.174|.      |
|indAuditC |sm_share_health  |Unadjusted |  0.948|   4| 577|  0.435|.      |
|indAuditC |sm_share_health  |Adjusted   |  1.068|   4| 574|  0.371|.      |
|indAuditC |sm_share_suicide |Unadjusted |  0.717|   4| 576|  0.580|.      |
|indAuditC |sm_share_suicide |Adjusted   |  0.541|   4| 573|  0.706|.      |
|indDSISS  |fb_freq          |Unadjusted |  0.523|   5| 577|  0.759|.      |
|indDSISS  |fb_freq          |Adjusted   |  0.659|   5| 574|  0.655|.      |
|indDSISS  |comm_facebook    |Unadjusted |  0.644|   4| 580|  0.631|.      |
|indDSISS  |comm_facebook    |Adjusted   |  1.060|   4| 577|  0.376|.      |
|indDSISS  |sm_emot_support  |Unadjusted |  0.450|   4| 580|  0.772|.      |
|indDSISS  |sm_emot_support  |Adjusted   |  0.669|   4| 577|  0.614|.      |
|indDSISS  |sm_med_info      |Unadjusted |  0.758|   4| 579|  0.553|.      |
|indDSISS  |sm_med_info      |Adjusted   |  0.963|   4| 576|  0.427|.      |
|indDSISS  |sm_med_advice    |Unadjusted |  0.612|   4| 580|  0.654|.      |
|indDSISS  |sm_med_advice    |Adjusted   |  0.911|   4| 577|  0.457|.      |
|indDSISS  |sm_med_questions |Unadjusted |  0.675|   4| 580|  0.609|.      |
|indDSISS  |sm_med_questions |Adjusted   |  0.704|   4| 577|  0.589|.      |
|indDSISS  |sm_share_sympt   |Unadjusted |  4.017|   4| 579|  0.003|**     |
|indDSISS  |sm_share_sympt   |Adjusted   |  1.201|   4| 576|  0.309|.      |
|indDSISS  |sm_share_health  |Unadjusted |  3.175|   4| 579|  0.014|*      |
|indDSISS  |sm_share_health  |Adjusted   |  1.302|   4| 576|  0.268|.      |
|indDSISS  |sm_share_suicide |Unadjusted | 11.005|   4| 578|  0.000|***    |
|indDSISS  |sm_share_suicide |Adjusted   |  6.523|   4| 575|  0.000|***    |


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




|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.342|     0.224|    -4.782|   0.000|
|Unadjusted |fmssSubscore                 |     0.923|     0.058|    -1.395|   0.163|
|Unadjusted |indNotPTSDTRUE               |     2.650|     0.285|     3.415|   0.001|
|Unadjusted |fmssSubscore:indNotPTSDTRUE  |     1.016|     0.072|     0.220|   0.826|
|Adjusted   |(Intercept)                  |     0.403|     0.252|    -3.606|   0.000|
|Adjusted   |fmssSubscore                 |     0.944|     0.058|    -0.995|   0.320|
|Adjusted   |countSocialMediaExclFB       |     0.852|     0.103|    -1.555|   0.120|
|Adjusted   |indSuicideConsideredEverTRUE |     1.169|     0.206|     0.757|   0.449|
|Adjusted   |countSuicideAttempts         |     0.510|     0.229|    -2.942|   0.003|
|Adjusted   |indNotPTSDTRUE               |     2.442|     0.294|     3.036|   0.002|
|Adjusted   |fmssSubscore:indNotPTSDTRUE  |     1.001|     0.073|     0.018|   0.986|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       733.649|     579| -349.346| 706.691| 724.143|  698.691|         576|
|Adjusted   |       733.649|     579| -341.705| 697.411| 727.952|  683.411|         573|

**PHQ-2**




|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.458|     0.264|    -2.958|   0.003|
|Unadjusted |fmssSubscore                 |     0.862|     0.074|    -2.016|   0.044|
|Unadjusted |indNotPHQTRUE                |     1.476|     0.307|     1.267|   0.205|
|Unadjusted |fmssSubscore:indNotPHQTRUE   |     1.105|     0.083|     1.199|   0.231|
|Adjusted   |(Intercept)                  |     0.582|     0.291|    -1.860|   0.063|
|Adjusted   |fmssSubscore                 |     0.876|     0.072|    -1.833|   0.067|
|Adjusted   |countSocialMediaExclFB       |     0.836|     0.102|    -1.755|   0.079|
|Adjusted   |indSuicideConsideredEverTRUE |     1.117|     0.204|     0.542|   0.588|
|Adjusted   |countSuicideAttempts         |     0.493|     0.221|    -3.200|   0.001|
|Adjusted   |indNotPHQTRUE                |     1.296|     0.315|     0.822|   0.411|
|Adjusted   |fmssSubscore:indNotPHQTRUE   |     1.108|     0.082|     1.249|   0.212|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       735.877|     580| -359.843| 727.685| 745.144|  719.685|         577|
|Adjusted   |       735.877|     580| -350.017| 714.035| 744.588|  700.035|         574|

**AUDIT-C**




|model      |term                          | oddsratio| std.error| statistic| p.value|
|:----------|:-----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                   |     0.800|     0.209|    -1.067|   0.286|
|Unadjusted |fmssSubscore                  |     0.890|     0.055|    -2.107|   0.035|
|Unadjusted |indNotAuditCTRUE              |     0.608|     0.275|    -1.811|   0.070|
|Unadjusted |fmssSubscore:indNotAuditCTRUE |     1.083|     0.070|     1.145|   0.252|
|Adjusted   |(Intercept)                   |     1.025|     0.232|     0.104|   0.917|
|Adjusted   |fmssSubscore                  |     0.903|     0.057|    -1.809|   0.071|
|Adjusted   |countSocialMediaExclFB        |     0.841|     0.102|    -1.691|   0.091|
|Adjusted   |indSuicideConsideredEverTRUE  |     0.924|     0.200|    -0.393|   0.694|
|Adjusted   |countSuicideAttempts          |     0.490|     0.220|    -3.243|   0.001|
|Adjusted   |indNotAuditCTRUE              |     0.582|     0.280|    -1.932|   0.053|
|Adjusted   |fmssSubscore:indNotAuditCTRUE |     1.088|     0.071|     1.190|   0.234|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       731.413|     578| -361.896| 731.793| 749.238|  723.793|         575|
|Adjusted   |       731.413|     578| -349.757| 713.514| 744.043|  699.514|         572|

**DSI-SS**




|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.359|     0.297|    -3.441|   0.001|
|Unadjusted |fmssSubscore                 |     1.070|     0.075|     0.903|   0.366|
|Unadjusted |indNotDSISSTRUE              |     1.935|     0.334|     1.977|   0.048|
|Unadjusted |fmssSubscore:indNotDSISSTRUE |     0.844|     0.084|    -2.019|   0.044|
|Adjusted   |(Intercept)                  |     0.552|     0.341|    -1.742|   0.082|
|Adjusted   |fmssSubscore                 |     1.091|     0.076|     1.142|   0.254|
|Adjusted   |countSocialMediaExclFB       |     0.852|     0.101|    -1.593|   0.111|
|Adjusted   |indSuicideConsideredEverTRUE |     0.965|     0.209|    -0.170|   0.865|
|Adjusted   |countSuicideAttempts         |     0.469|     0.220|    -3.433|   0.001|
|Adjusted   |indNotDSISSTRUE              |     1.445|     0.354|     1.040|   0.298|
|Adjusted   |fmssSubscore:indNotDSISSTRUE |     0.843|     0.086|    -1.995|   0.046|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       735.877|     580| -363.574| 735.148| 752.607|  727.148|         577|
|Adjusted   |       735.877|     580| -351.788| 717.577| 748.130|  703.577|         574|


### Did not use VA health services in prior 12 months



**PC-PTSD**




|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.769|     0.192|    -1.364|   0.173|
|Unadjusted |fmssSubscore                 |     0.951|     0.046|    -1.080|   0.280|
|Unadjusted |indNotPTSDTRUE               |     3.520|     0.273|     4.612|   0.000|
|Unadjusted |fmssSubscore:indNotPTSDTRUE  |     0.970|     0.064|    -0.480|   0.632|
|Adjusted   |(Intercept)                  |     0.861|     0.222|    -0.675|   0.500|
|Adjusted   |fmssSubscore                 |     0.962|     0.047|    -0.820|   0.412|
|Adjusted   |countSocialMediaExclFB       |     1.005|     0.092|     0.049|   0.961|
|Adjusted   |indSuicideConsideredEverTRUE |     1.037|     0.198|     0.182|   0.856|
|Adjusted   |countSuicideAttempts         |     0.667|     0.146|    -2.778|   0.005|
|Adjusted   |indNotPTSDTRUE               |     3.197|     0.280|     4.146|   0.000|
|Adjusted   |fmssSubscore:indNotPTSDTRUE  |     0.963|     0.065|    -0.586|   0.558|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       797.432|     578| -373.685| 755.370| 772.815|  747.370|         575|
|Adjusted   |       797.432|     578| -368.772| 751.544| 782.073|  737.544|         572|

**PHQ-2**




|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.818|     0.239|    -0.838|   0.402|
|Unadjusted |fmssSubscore                 |     0.898|     0.060|    -1.776|   0.076|
|Unadjusted |indNotPHQTRUE                |     2.354|     0.288|     2.973|   0.003|
|Unadjusted |fmssSubscore:indNotPHQTRUE   |     1.055|     0.071|     0.750|   0.453|
|Adjusted   |(Intercept)                  |     0.968|     0.268|    -0.123|   0.902|
|Adjusted   |fmssSubscore                 |     0.907|     0.060|    -1.627|   0.104|
|Adjusted   |countSocialMediaExclFB       |     0.972|     0.091|    -0.317|   0.751|
|Adjusted   |indSuicideConsideredEverTRUE |     1.046|     0.198|     0.229|   0.819|
|Adjusted   |countSuicideAttempts         |     0.633|     0.145|    -3.143|   0.002|
|Adjusted   |indNotPHQTRUE                |     2.085|     0.295|     2.488|   0.013|
|Adjusted   |fmssSubscore:indNotPHQTRUE   |     1.058|     0.071|     0.791|   0.429|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       798.635|     579| -382.271| 772.541| 789.994|  764.541|         576|
|Adjusted   |       798.635|     579| -375.752| 765.504| 796.045|  751.504|         573|

**AUDIT-C**




|model      |term                          | oddsratio| std.error| statistic| p.value|
|:----------|:-----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                   |     1.876|     0.211|     2.983|   0.003|
|Unadjusted |fmssSubscore                  |     0.910|     0.052|    -1.799|   0.072|
|Unadjusted |indNotAuditCTRUE              |     0.682|     0.269|    -1.424|   0.154|
|Unadjusted |fmssSubscore:indNotAuditCTRUE |     1.049|     0.065|     0.735|   0.462|
|Adjusted   |(Intercept)                   |     2.302|     0.233|     3.581|   0.000|
|Adjusted   |fmssSubscore                  |     0.919|     0.053|    -1.593|   0.111|
|Adjusted   |countSocialMediaExclFB        |     0.988|     0.089|    -0.136|   0.892|
|Adjusted   |indSuicideConsideredEverTRUE  |     0.831|     0.190|    -0.976|   0.329|
|Adjusted   |countSuicideAttempts          |     0.610|     0.143|    -3.458|   0.001|
|Adjusted   |indNotAuditCTRUE              |     0.655|     0.274|    -1.544|   0.123|
|Adjusted   |fmssSubscore:indNotAuditCTRUE |     1.053|     0.066|     0.789|   0.430|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       795.844|     577| -394.554| 797.107| 814.545|  789.107|         574|
|Adjusted   |       795.844|     577| -383.485| 780.971| 811.488|  766.971|         571|

**DSI-SS**




|model      |term                         | oddsratio| std.error| statistic| p.value|
|:----------|:----------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                  |     0.934|     0.269|    -0.254|   0.799|
|Unadjusted |fmssSubscore                 |     0.935|     0.072|    -0.936|   0.349|
|Unadjusted |indNotDSISSTRUE              |     1.900|     0.309|     2.078|   0.038|
|Unadjusted |fmssSubscore:indNotDSISSTRUE |     0.996|     0.080|    -0.052|   0.958|
|Adjusted   |(Intercept)                  |     1.249|     0.313|     0.709|   0.479|
|Adjusted   |fmssSubscore                 |     0.944|     0.072|    -0.800|   0.424|
|Adjusted   |countSocialMediaExclFB       |     0.991|     0.089|    -0.098|   0.922|
|Adjusted   |indSuicideConsideredEverTRUE |     0.952|     0.199|    -0.249|   0.803|
|Adjusted   |countSuicideAttempts         |     0.622|     0.144|    -3.304|   0.001|
|Adjusted   |indNotDSISSTRUE              |     1.504|     0.328|     1.245|   0.213|
|Adjusted   |fmssSubscore:indNotDSISSTRUE |     1.000|     0.080|     0.001|   0.999|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       798.241|     579| -392.070| 792.140| 809.592|  784.140|         576|
|Adjusted   |       798.241|     579| -384.307| 782.614| 813.156|  768.614|         573|
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
