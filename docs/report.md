---
title: "Psychiatric Symptoms of Veterans Surveyed Through Facebook Ads"
date: "2021-09-03 17:38:53"
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


```
##   fmssSubscore   
##  Min.   : 0.000  
##  1st Qu.: 0.000  
##  Median : 3.000  
##  Mean   : 3.197  
##  3rd Qu.: 5.000  
##  Max.   :12.000  
##  NA's   :4
```




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
* Demographics
  * `age`
  * `gender`
  * `race`
  * `hispanic`
  * `marital`



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

Mean (SD) age: 40.0 (12.0)


|gender                   |   n|      prop|
|:------------------------|---:|---------:|
|Male                     | 474| 0.8074957|
|Female                   | 111| 0.1890971|
|A gender not listed here |   2| 0.0034072|



|fct_explicit_na(race)                         |   n|      prop|
|:---------------------------------------------|---:|---------:|
|White                                         | 492| 0.8381601|
|American Indian/Alaska Native/Native Hawaiian |   7| 0.0119250|
|Asian                                         |   8| 0.0136286|
|Black or African American                     |   7| 0.0119250|
|Multiple races                                |  52| 0.0885860|
|Other                                         |  17| 0.0289608|
|(Missing)                                     |   4| 0.0068143|



|fct_explicit_na(hispanic) |   n|      prop|
|:-------------------------|---:|---------:|
|Yes                       |  34| 0.0579216|
|No                        | 550| 0.9369676|
|(Missing)                 |   3| 0.0051107|



|fct_explicit_na(raceNonHispWhite) |   n|      prop|
|:---------------------------------|---:|---------:|
|Not non-Hispanic White            | 112| 0.1908007|
|Non-Hispanic White                | 473| 0.8057922|
|(Missing)                         |   2| 0.0034072|



|fct_explicit_na(educCollege) |   n|     prop|
|:----------------------------|---:|--------:|
|Some college or less         | 284| 0.483816|
|At least a college degree    | 303| 0.516184|



|fct_explicit_na(marital)   |   n|      prop|
|:--------------------------|---:|---------:|
|Single, never been married | 112| 0.1908007|
|Divorced                   |  88| 0.1499148|
|Separated                  |  16| 0.0272572|
|Married                    | 339| 0.5775128|
|Living as married          |  24| 0.0408859|
|Widowed                    |   7| 0.0119250|
|(Missing)                  |   1| 0.0017036|



|fct_explicit_na(marital2)         |   n|      prop|
|:---------------------------------|---:|---------:|
|Married or living as married      | 363| 0.6183986|
|Single/Divorced/Widowed/Separated | 223| 0.3798978|
|(Missing)                         |   1| 0.0017036|
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



Filter subjects with missing covariates.



Set modeling covariates.


```
## [1] "age"      "gender"   "race"     "hispanic" "marital2"
```

### PC-PTSD


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       2.299|     0.393|     2.119|   0.034|
|Unadjusted |fmss                                              |       0.965|     0.013|    -2.655|   0.008|
|Adjusted   |(Intercept)                                       |       1.584|     0.634|     0.726|   0.468|
|Adjusted   |fmss                                              |       0.964|     0.014|    -2.701|   0.007|
|Adjusted   |age                                               |       0.997|     0.007|    -0.461|   0.645|
|Adjusted   |genderFemale                                      |       1.134|     0.223|     0.565|   0.572|
|Adjusted   |genderA gender not listed here                    | 2666680.181|   613.740|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.849|     0.782|     0.786|   0.432|
|Adjusted   |raceAsian                                         |       1.105|     0.725|     0.138|   0.890|
|Adjusted   |raceBlack or African American                     |       1.626|     0.778|     0.625|   0.532|
|Adjusted   |raceMultiple races                                |       1.581|     0.300|     1.528|   0.126|
|Adjusted   |raceOther                                         |       1.797|     0.575|     1.019|   0.308|
|Adjusted   |hispanicNo                                        |       1.407|     0.401|     0.851|   0.395|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.400|     0.181|     1.856|   0.063|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       775.487|     562| -384.156| 772.311| 780.978|  768.311|         561|
|Adjusted   |       775.487|     562| -377.911| 779.822| 831.821|  755.822|         551|



For a 10-point increase in FMSS, the adjusted odds ratio is 0.692.


### PHQ-2


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     1.087|     0.431|     0.194|   0.846|
|Unadjusted |fmss                                              |     0.964|     0.015|    -2.454|   0.014|
|Adjusted   |(Intercept)                                       |     1.088|     0.726|     0.116|   0.907|
|Adjusted   |fmss                                              |     0.963|     0.015|    -2.461|   0.014|
|Adjusted   |age                                               |     0.981|     0.009|    -2.236|   0.025|
|Adjusted   |genderFemale                                      |     0.986|     0.252|    -0.055|   0.956|
|Adjusted   |genderA gender not listed here                    |     2.272|     1.441|     0.569|   0.569|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.493|     1.099|    -0.644|   0.519|
|Adjusted   |raceAsian                                         |     0.817|     0.838|    -0.241|   0.810|
|Adjusted   |raceBlack or African American                     |     1.179|     0.855|     0.193|   0.847|
|Adjusted   |raceMultiple races                                |     1.274|     0.320|     0.757|   0.449|
|Adjusted   |raceOther                                         |     3.398|     0.582|     2.101|   0.036|
|Adjusted   |hispanicNo                                        |     1.959|     0.479|     1.405|   0.160|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.307|     0.200|     1.340|   0.180|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       665.192|     563| -329.524| 663.048| 671.718|  659.048|         562|
|Adjusted   |       665.192|     563| -322.356| 668.711| 720.732|  644.711|         552|



For a 10-point increase in FMSS, the adjusted odds ratio is 0.686.

### AUDIT-C


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.857|     0.391|    -0.394|   0.694|
|Unadjusted |fmss                                              |     0.993|     0.013|    -0.499|   0.618|
|Adjusted   |(Intercept)                                       |     3.366|     0.654|     1.854|   0.064|
|Adjusted   |fmss                                              |     0.987|     0.014|    -0.949|   0.343|
|Adjusted   |age                                               |     0.967|     0.008|    -4.065|   0.000|
|Adjusted   |genderFemale                                      |     0.750|     0.236|    -1.217|   0.224|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     9.549|     1.099|     2.052|   0.040|
|Adjusted   |raceAsian                                         |     0.169|     1.094|    -1.627|   0.104|
|Adjusted   |raceBlack or African American                     |     1.212|     0.801|     0.240|   0.810|
|Adjusted   |raceMultiple races                                |     1.000|     0.306|     0.001|   0.999|
|Adjusted   |raceOther                                         |     0.216|     0.798|    -1.919|   0.055|
|Adjusted   |hispanicNo                                        |     0.992|     0.407|    -0.020|   0.984|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.723|     0.187|     2.915|   0.004|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       762.618|     561| -381.184| 766.369| 775.032|  762.369|         560|
|Adjusted   |       762.618|     561| -357.417| 736.833| 784.480|  714.833|         551|



For a 10-point increase in FMSS, the adjusted odds ratio is 0.876.


### DSI-SS


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     1.076|     0.462|     0.158|   0.874|
|Unadjusted |fmss                                              |     0.955|     0.016|    -2.875|   0.004|
|Adjusted   |(Intercept)                                       |     2.325|     0.757|     1.115|   0.265|
|Adjusted   |fmss                                              |     0.953|     0.017|    -2.873|   0.004|
|Adjusted   |age                                               |     0.972|     0.010|    -2.879|   0.004|
|Adjusted   |genderFemale                                      |     0.923|     0.277|    -0.290|   0.772|
|Adjusted   |genderA gender not listed here                    |     2.964|     1.468|     0.740|   0.459|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   532.102|    -0.027|   0.979|
|Adjusted   |raceAsian                                         |     1.055|     0.843|     0.064|   0.949|
|Adjusted   |raceBlack or African American                     |     1.592|     0.866|     0.537|   0.592|
|Adjusted   |raceMultiple races                                |     1.819|     0.322|     1.859|   0.063|
|Adjusted   |raceOther                                         |     1.534|     0.639|     0.669|   0.503|
|Adjusted   |hispanicNo                                        |     1.159|     0.456|     0.324|   0.746|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.570|     0.215|     2.102|   0.036|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       599.174|     563| -295.329| 594.658| 603.328|  590.658|         562|
|Adjusted   |       599.174|     563| -283.228| 590.456| 642.476|  566.456|         552|



For a 10-point increase in FMSS, the adjusted odds ratio is 0.617.


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

![plot of chunk unnamed-chunk-45](../figures/unnamed-chunk-45-1.png)

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




### PC-PTSD


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.841|     0.130|    -1.330|   0.183|
|Unadjusted |fmssSubscore                                      |       0.996|     0.031|    -0.120|   0.905|
|Adjusted   |(Intercept)                                       |       0.531|     0.489|    -1.296|   0.195|
|Adjusted   |fmssSubscore                                      |       0.989|     0.032|    -0.329|   0.742|
|Adjusted   |age                                               |       0.997|     0.007|    -0.376|   0.707|
|Adjusted   |genderFemale                                      |       1.049|     0.220|     0.216|   0.829|
|Adjusted   |genderA gender not listed here                    | 2614732.177|   620.381|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.654|     0.774|     0.650|   0.516|
|Adjusted   |raceAsian                                         |       1.296|     0.718|     0.361|   0.718|
|Adjusted   |raceBlack or African American                     |       1.806|     0.777|     0.760|   0.447|
|Adjusted   |raceMultiple races                                |       1.686|     0.297|     1.756|   0.079|
|Adjusted   |raceOther                                         |       2.069|     0.555|     1.311|   0.190|
|Adjusted   |hispanicNo                                        |       1.481|     0.396|     0.991|   0.322|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.360|     0.179|     1.721|   0.085|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       789.437|     572| -394.712| 793.423| 802.125|  789.423|         571|
|Adjusted   |       789.437|     572| -388.323| 800.646| 852.856|  776.646|         561|


### PHQ-2


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.391|     0.145|    -6.497|   0.000|
|Unadjusted |fmssSubscore                                      |     0.996|     0.035|    -0.102|   0.919|
|Adjusted   |(Intercept)                                       |     0.365|     0.570|    -1.769|   0.077|
|Adjusted   |fmssSubscore                                      |     0.995|     0.036|    -0.150|   0.881|
|Adjusted   |age                                               |     0.983|     0.008|    -2.006|   0.045|
|Adjusted   |genderFemale                                      |     0.908|     0.249|    -0.390|   0.696|
|Adjusted   |genderA gender not listed here                    |     2.209|     1.428|     0.555|   0.579|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.447|     1.089|    -0.738|   0.460|
|Adjusted   |raceAsian                                         |     0.947|     0.832|    -0.065|   0.948|
|Adjusted   |raceBlack or African American                     |     1.247|     0.855|     0.258|   0.797|
|Adjusted   |raceMultiple races                                |     1.327|     0.318|     0.891|   0.373|
|Adjusted   |raceOther                                         |     2.866|     0.555|     1.898|   0.058|
|Adjusted   |hispanicNo                                        |     1.917|     0.469|     1.387|   0.166|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.244|     0.196|     1.112|   0.266|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       679.346|     573| -339.668| 683.335| 692.041|  679.335|         572|
|Adjusted   |       679.346|     573| -333.503| 691.006| 743.238|  667.006|         562|


### AUDIT-C


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.793|     0.131|    -1.767|   0.077|
|Unadjusted |fmssSubscore                                      |     0.971|     0.032|    -0.924|   0.355|
|Adjusted   |(Intercept)                                       |     2.565|     0.508|     1.854|   0.064|
|Adjusted   |fmssSubscore                                      |     0.958|     0.034|    -1.282|   0.200|
|Adjusted   |age                                               |     0.967|     0.008|    -4.229|   0.000|
|Adjusted   |genderFemale                                      |     0.732|     0.236|    -1.320|   0.187|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     9.466|     1.101|     2.041|   0.041|
|Adjusted   |raceAsian                                         |     0.166|     1.095|    -1.641|   0.101|
|Adjusted   |raceBlack or African American                     |     1.251|     0.802|     0.279|   0.780|
|Adjusted   |raceMultiple races                                |     1.010|     0.305|     0.033|   0.974|
|Adjusted   |raceOther                                         |     0.318|     0.680|    -1.685|   0.092|
|Adjusted   |hispanicNo                                        |     1.068|     0.404|     0.164|   0.870|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.780|     0.186|     3.108|   0.002|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       778.099|     571| -388.621| 781.241| 789.940|  777.241|         570|
|Adjusted   |       778.099|     571| -363.968| 749.937| 797.777|  727.937|         561|


### DSI-SS


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.340|     0.152|    -7.106|   0.000|
|Unadjusted |fmssSubscore                                      |     0.950|     0.038|    -1.350|   0.177|
|Adjusted   |(Intercept)                                       |     0.695|     0.581|    -0.626|   0.531|
|Adjusted   |fmssSubscore                                      |     0.941|     0.040|    -1.518|   0.129|
|Adjusted   |age                                               |     0.973|     0.010|    -2.860|   0.004|
|Adjusted   |genderFemale                                      |     0.871|     0.275|    -0.501|   0.616|
|Adjusted   |genderA gender not listed here                    |     2.870|     1.444|     0.730|   0.465|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   538.057|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.171|     0.842|     0.188|   0.851|
|Adjusted   |raceBlack or African American                     |     1.758|     0.864|     0.653|   0.514|
|Adjusted   |raceMultiple races                                |     1.926|     0.320|     2.046|   0.041|
|Adjusted   |raceOther                                         |     1.383|     0.623|     0.521|   0.602|
|Adjusted   |hispanicNo                                        |     1.168|     0.449|     0.346|   0.730|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.574|     0.211|     2.147|   0.032|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       611.701|     573| -304.922| 613.844| 622.549|  609.844|         572|
|Adjusted   |       611.701|     573| -292.079| 608.158| 660.389|  584.158|         562|


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


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.568|     0.158|    -3.591|   0.000|
|Unadjusted |fmssQuartileQ4: (34,48]                           |     0.562|     0.262|    -2.194|   0.028|
|Adjusted   |(Intercept)                                       |     0.679|     0.745|    -0.519|   0.604|
|Adjusted   |fmssQuartileQ4: (34,48]                           |     0.584|     0.275|    -1.955|   0.051|
|Adjusted   |age                                               |     0.975|     0.011|    -2.170|   0.030|
|Adjusted   |genderFemale                                      |     0.668|     0.359|    -1.123|   0.261|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     1.621|     1.280|     0.377|   0.706|
|Adjusted   |raceAsian                                         |     0.482|     1.133|    -0.643|   0.520|
|Adjusted   |raceBlack or African American                     |     0.000|   611.618|    -0.022|   0.983|
|Adjusted   |raceMultiple races                                |     1.512|     0.410|     1.007|   0.314|
|Adjusted   |raceOther                                         |     3.320|     0.770|     1.559|   0.119|
|Adjusted   |hispanicNo                                        |     2.158|     0.618|     1.246|   0.213|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.227|     0.278|     0.734|   0.463|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       369.970|     297| -182.510| 369.019| 376.413|  365.019|         296|
|Adjusted   |       363.807|     293| -173.396| 368.793| 409.312|  346.793|         283|


### DSI-SS


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.370|     0.171|    -5.822|   0.000|
|Unadjusted |fmssQuartileQ4: (34,48]                           |     0.520|     0.298|    -2.197|   0.028|
|Adjusted   |(Intercept)                                       |     0.719|     0.748|    -0.441|   0.659|
|Adjusted   |fmssQuartileQ4: (34,48]                           |     0.535|     0.311|    -2.016|   0.044|
|Adjusted   |age                                               |     0.982|     0.013|    -1.461|   0.144|
|Adjusted   |genderFemale                                      |     0.684|     0.405|    -0.937|   0.349|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|  1353.333|    -0.011|   0.991|
|Adjusted   |raceAsian                                         |     0.683|     1.125|    -0.339|   0.735|
|Adjusted   |raceBlack or African American                     |     0.000|  1696.580|    -0.009|   0.993|
|Adjusted   |raceMultiple races                                |     1.662|     0.429|     1.186|   0.236|
|Adjusted   |raceOther                                         |     3.101|     0.828|     1.367|   0.172|
|Adjusted   |hispanicNo                                        |     0.960|     0.586|    -0.069|   0.945|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.332|     0.304|     0.945|   0.345|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       317.642|     297| -156.291| 316.581| 323.975|  312.581|         296|
|Adjusted   |       313.129|     293| -149.158| 320.315| 360.835|  298.315|         283|
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
covarDemog <- c("age", "gender", "race", "hispanic", "marital2")
covarPsySoc <- c("countSocialMediaExclFB",
                 "comm_inperson",
                 "indSuicideConsideredEver",
                 "countSuicideAttempts")
```

Filter subjects with missing covariates.



Set modeling covariates.


```
## [1] "age"      "gender"   "race"     "hispanic" "marital2"
```

Relabel factors; replace spaces with underscores.




### PC-PTSD vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.373|   5| 570|  0.233|
|Adjusted   | 1.302|   5| 560|  0.262|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.429|     0.690|    -1.228|   0.220|
|Unadjusted |fb_freqEvery_few_weeks                            |       2.333|     1.215|     0.697|   0.486|
|Unadjusted |fb_freqOnce_a_week                                |       1.167|     1.107|     0.139|   0.889|
|Unadjusted |fb_freqA_few_times_a_week                         |       2.882|     0.763|     1.387|   0.165|
|Unadjusted |fb_freqOnce_a_day                                 |       2.935|     0.731|     1.474|   0.141|
|Unadjusted |fb_freqSeveral_times_a_day                        |       1.750|     0.697|     0.803|   0.422|
|Adjusted   |(Intercept)                                       |       0.346|     0.842|    -1.262|   0.207|
|Adjusted   |fb_freqEvery_few_weeks                            |       2.573|     1.218|     0.776|   0.438|
|Adjusted   |fb_freqOnce_a_week                                |       0.905|     1.137|    -0.088|   0.930|
|Adjusted   |fb_freqA_few_times_a_week                         |       2.684|     0.769|     1.284|   0.199|
|Adjusted   |fb_freqOnce_a_day                                 |       2.642|     0.737|     1.319|   0.187|
|Adjusted   |fb_freqSeveral_times_a_day                        |       1.599|     0.700|     0.671|   0.502|
|Adjusted   |age                                               |       0.993|     0.007|    -0.907|   0.364|
|Adjusted   |genderFemale                                      |       1.033|     0.219|     0.149|   0.882|
|Adjusted   |genderA gender not listed here                    | 2782181.627|   620.266|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.997|     0.787|     0.879|   0.379|
|Adjusted   |raceAsian                                         |       1.294|     0.718|     0.359|   0.720|
|Adjusted   |raceBlack or African American                     |       1.525|     0.784|     0.538|   0.591|
|Adjusted   |raceMultiple races                                |       1.600|     0.301|     1.563|   0.118|
|Adjusted   |raceOther                                         |       2.131|     0.564|     1.341|   0.180|
|Adjusted   |hispanicNo                                        |       1.496|     0.398|     1.012|   0.312|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.297|     0.180|     1.444|   0.149|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       792.655|     575| -392.834| 797.668| 823.805|  785.668|         570|
|Adjusted   |       792.655|     575| -386.589| 805.178| 874.875|  773.178|         560|


### PC-PTSD vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.572|   4| 572|  0.180|
|Adjusted   | 1.388|   4| 562|  0.237|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       1.059|     0.239|     0.239|   0.811|
|Unadjusted |comm_facebookOnce_a_week                          |       1.102|     0.400|     0.242|   0.809|
|Unadjusted |comm_facebookA_few_times_a_week                   |       0.944|     0.303|    -0.189|   0.850|
|Unadjusted |comm_facebookOnce_a_day                           |       0.766|     0.315|    -0.845|   0.398|
|Unadjusted |comm_facebookSeveral_times_a_day                  |       0.626|     0.271|    -1.731|   0.084|
|Adjusted   |(Intercept)                                       |       0.648|     0.514|    -0.846|   0.397|
|Adjusted   |comm_facebookOnce_a_week                          |       1.051|     0.407|     0.122|   0.903|
|Adjusted   |comm_facebookA_few_times_a_week                   |       0.925|     0.311|    -0.251|   0.802|
|Adjusted   |comm_facebookOnce_a_day                           |       0.738|     0.329|    -0.923|   0.356|
|Adjusted   |comm_facebookSeveral_times_a_day                  |       0.624|     0.281|    -1.681|   0.093|
|Adjusted   |age                                               |       0.999|     0.008|    -0.094|   0.925|
|Adjusted   |genderFemale                                      |       1.072|     0.220|     0.316|   0.752|
|Adjusted   |genderA gender not listed here                    | 3055727.706|   623.741|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.565|     0.783|     0.572|   0.567|
|Adjusted   |raceAsian                                         |       1.291|     0.722|     0.354|   0.723|
|Adjusted   |raceBlack or African American                     |       1.710|     0.787|     0.682|   0.495|
|Adjusted   |raceMultiple races                                |       1.740|     0.299|     1.852|   0.064|
|Adjusted   |raceOther                                         |       2.013|     0.559|     1.253|   0.210|
|Adjusted   |hispanicNo                                        |       1.407|     0.397|     0.859|   0.390|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.314|     0.180|     1.513|   0.130|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       794.252|     576| -393.962| 797.924| 819.713|  787.924|         572|
|Adjusted   |       794.252|     576| -387.906| 805.812| 871.179|  775.812|         562|


### PC-PTSD vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.460|   4| 572|  0.213|
|Adjusted   | 1.692|   4| 562|  0.150|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.683|     0.142|    -2.694|   0.007|
|Unadjusted |sm_emot_supportRarely                             |       1.596|     0.204|     2.292|   0.022|
|Unadjusted |sm_emot_supportSometimes                          |       1.074|     0.227|     0.314|   0.754|
|Unadjusted |sm_emot_supportUsually                            |       1.183|     0.326|     0.515|   0.606|
|Unadjusted |sm_emot_supportAlways                             |       1.098|     0.777|     0.121|   0.904|
|Adjusted   |(Intercept)                                       |       0.483|     0.485|    -1.499|   0.134|
|Adjusted   |sm_emot_supportRarely                             |       1.662|     0.211|     2.414|   0.016|
|Adjusted   |sm_emot_supportSometimes                          |       1.052|     0.233|     0.216|   0.829|
|Adjusted   |sm_emot_supportUsually                            |       1.152|     0.339|     0.416|   0.677|
|Adjusted   |sm_emot_supportAlways                             |       1.183|     0.788|     0.213|   0.832|
|Adjusted   |age                                               |       0.996|     0.007|    -0.588|   0.556|
|Adjusted   |genderFemale                                      |       0.993|     0.223|    -0.033|   0.973|
|Adjusted   |genderA gender not listed here                    | 2870317.408|   617.846|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       2.015|     0.778|     0.901|   0.367|
|Adjusted   |raceAsian                                         |       1.379|     0.726|     0.443|   0.658|
|Adjusted   |raceBlack or African American                     |       2.120|     0.783|     0.959|   0.337|
|Adjusted   |raceMultiple races                                |       1.647|     0.300|     1.663|   0.096|
|Adjusted   |raceOther                                         |       2.329|     0.558|     1.514|   0.130|
|Adjusted   |hispanicNo                                        |       1.374|     0.399|     0.796|   0.426|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.348|     0.179|     1.668|   0.095|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       794.252|     576| -394.195| 798.390| 820.179|  788.390|         572|
|Adjusted   |       794.252|     576| -387.296| 804.592| 869.960|  774.592|         562|


### PC-PTSD vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.577|   4| 571|  0.179|
|Adjusted   | 1.767|   4| 561|  0.134|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.872|     0.166|    -0.827|   0.408|
|Unadjusted |sm_med_infoRarely                                 |       0.733|     0.226|    -1.373|   0.170|
|Unadjusted |sm_med_infoSometimes                              |       1.082|     0.226|     0.349|   0.727|
|Unadjusted |sm_med_infoUsually                                |       1.262|     0.302|     0.770|   0.441|
|Unadjusted |sm_med_infoAlways                                 |       0.529|     0.521|    -1.221|   0.222|
|Adjusted   |(Intercept)                                       |       0.593|     0.491|    -1.064|   0.288|
|Adjusted   |sm_med_infoRarely                                 |       0.721|     0.231|    -1.412|   0.158|
|Adjusted   |sm_med_infoSometimes                              |       1.094|     0.235|     0.385|   0.700|
|Adjusted   |sm_med_infoUsually                                |       1.327|     0.313|     0.905|   0.365|
|Adjusted   |sm_med_infoAlways                                 |       0.524|     0.535|    -1.208|   0.227|
|Adjusted   |age                                               |       0.995|     0.008|    -0.599|   0.549|
|Adjusted   |genderFemale                                      |       1.047|     0.222|     0.207|   0.836|
|Adjusted   |genderA gender not listed here                    | 2818941.062|   605.880|     0.025|   0.980|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.662|     0.779|     0.652|   0.515|
|Adjusted   |raceAsian                                         |       1.547|     0.725|     0.602|   0.547|
|Adjusted   |raceBlack or African American                     |       1.851|     0.781|     0.788|   0.431|
|Adjusted   |raceMultiple races                                |       1.783|     0.300|     1.927|   0.054|
|Adjusted   |raceOther                                         |       2.044|     0.560|     1.276|   0.202|
|Adjusted   |hispanicNo                                        |       1.437|     0.400|     0.906|   0.365|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.334|     0.180|     1.602|   0.109|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       792.655|     575| -393.113| 796.226| 818.007|  786.226|         571|
|Adjusted   |       792.655|     575| -386.333| 802.666| 868.008|  772.666|         561|


### PC-PTSD vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.114|   4| 572|  0.078|
|Adjusted   | 2.174|   4| 562|  0.071|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.758|     0.135|    -2.060|   0.039|
|Unadjusted |sm_med_adviceRarely                               |       1.000|     0.204|    -0.002|   0.999|
|Unadjusted |sm_med_adviceSometimes                            |       1.280|     0.221|     1.115|   0.265|
|Unadjusted |sm_med_adviceUsually                              |       2.074|     0.367|     1.985|   0.047|
|Unadjusted |sm_med_adviceAlways                               |       0.264|     0.786|    -1.694|   0.090|
|Adjusted   |(Intercept)                                       |       0.516|     0.484|    -1.365|   0.172|
|Adjusted   |sm_med_adviceRarely                               |       1.032|     0.208|     0.150|   0.881|
|Adjusted   |sm_med_adviceSometimes                            |       1.393|     0.230|     1.441|   0.150|
|Adjusted   |sm_med_adviceUsually                              |       2.073|     0.374|     1.947|   0.051|
|Adjusted   |sm_med_adviceAlways                               |       0.274|     0.802|    -1.614|   0.107|
|Adjusted   |age                                               |       0.995|     0.008|    -0.686|   0.493|
|Adjusted   |genderFemale                                      |       1.090|     0.221|     0.388|   0.698|
|Adjusted   |genderA gender not listed here                    | 2484381.112|   608.617|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.601|     0.782|     0.602|   0.547|
|Adjusted   |raceAsian                                         |       1.567|     0.737|     0.609|   0.542|
|Adjusted   |raceBlack or African American                     |       1.918|     0.781|     0.833|   0.405|
|Adjusted   |raceMultiple races                                |       1.663|     0.300|     1.696|   0.090|
|Adjusted   |raceOther                                         |       1.995|     0.561|     1.232|   0.218|
|Adjusted   |hispanicNo                                        |       1.424|     0.402|     0.879|   0.379|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.359|     0.180|     1.708|   0.088|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       794.252|     576| -392.320| 794.641| 816.430|  784.641|         572|
|Adjusted   |       794.252|     576| -385.815| 801.629| 866.997|  771.629|         562|


### PC-PTSD vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.147|   4| 572|  0.074|
|Adjusted   | 2.376|   4| 562|  0.051|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.718|     0.124|    -2.675|   0.007|
|Unadjusted |sm_med_questionsRarely                            |       1.070|     0.199|     0.342|   0.733|
|Unadjusted |sm_med_questionsSometimes                         |       1.311|     0.236|     1.146|   0.252|
|Unadjusted |sm_med_questionsUsually                           |       3.064|     0.401|     2.793|   0.005|
|Unadjusted |sm_med_questionsAlways                            |       1.393|     0.644|     0.514|   0.607|
|Adjusted   |(Intercept)                                       |       0.526|     0.484|    -1.329|   0.184|
|Adjusted   |sm_med_questionsRarely                            |       1.052|     0.204|     0.247|   0.805|
|Adjusted   |sm_med_questionsSometimes                         |       1.399|     0.245|     1.369|   0.171|
|Adjusted   |sm_med_questionsUsually                           |       3.236|     0.406|     2.890|   0.004|
|Adjusted   |sm_med_questionsAlways                            |       1.172|     0.662|     0.240|   0.810|
|Adjusted   |age                                               |       0.994|     0.008|    -0.848|   0.397|
|Adjusted   |genderFemale                                      |       1.002|     0.221|     0.010|   0.992|
|Adjusted   |genderA gender not listed here                    | 2872416.257|   618.604|     0.024|   0.981|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.604|     0.788|     0.600|   0.549|
|Adjusted   |raceAsian                                         |       1.305|     0.734|     0.363|   0.717|
|Adjusted   |raceBlack or African American                     |       1.927|     0.781|     0.840|   0.401|
|Adjusted   |raceMultiple races                                |       1.743|     0.300|     1.852|   0.064|
|Adjusted   |raceOther                                         |       2.270|     0.558|     1.469|   0.142|
|Adjusted   |hispanicNo                                        |       1.449|     0.401|     0.924|   0.355|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.330|     0.180|     1.583|   0.113|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       794.252|     576| -392.522| 795.043| 816.832|  785.043|         572|
|Adjusted   |       794.252|     576| -385.605| 801.210| 866.578|  771.210|         562|


### PC-PTSD vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 4.971|   4| 571|  0.001|
|Adjusted   | 4.671|   4| 561|  0.001|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.668|     0.116|    -3.458|   0.001|
|Unadjusted |sm_share_symptRarely                              |       1.071|     0.202|     0.339|   0.734|
|Unadjusted |sm_share_symptSometimes                           |       2.085|     0.256|     2.869|   0.004|
|Unadjusted |sm_share_symptUsually                             |       4.915|     0.447|     3.561|   0.000|
|Unadjusted |sm_share_symptAlways                              |       1.870|     0.681|     0.919|   0.358|
|Adjusted   |(Intercept)                                       |       0.434|     0.494|    -1.688|   0.091|
|Adjusted   |sm_share_symptRarely                              |       1.033|     0.206|     0.156|   0.876|
|Adjusted   |sm_share_symptSometimes                           |       2.007|     0.262|     2.655|   0.008|
|Adjusted   |sm_share_symptUsually                             |       4.923|     0.453|     3.518|   0.000|
|Adjusted   |sm_share_symptAlways                              |       1.690|     0.694|     0.756|   0.450|
|Adjusted   |age                                               |       0.996|     0.007|    -0.532|   0.595|
|Adjusted   |genderFemale                                      |       0.976|     0.224|    -0.107|   0.915|
|Adjusted   |genderA gender not listed here                    | 1571557.914|   540.192|     0.026|   0.979|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.652|     0.782|     0.642|   0.521|
|Adjusted   |raceAsian                                         |       1.014|     0.746|     0.019|   0.985|
|Adjusted   |raceBlack or African American                     |       1.572|     0.818|     0.553|   0.580|
|Adjusted   |raceMultiple races                                |       1.693|     0.302|     1.741|   0.082|
|Adjusted   |raceOther                                         |       2.050|     0.563|     1.275|   0.202|
|Adjusted   |hispanicNo                                        |       1.538|     0.411|     1.049|   0.294|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.353|     0.182|     1.666|   0.096|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       793.052|     575| -385.446| 780.893| 802.674|  770.893|         571|
|Adjusted   |       793.052|     575| -379.779| 789.558| 854.899|  759.558|         561|


### PC-PTSD vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.748|   4| 571|  0.005|
|Adjusted   | 3.345|   4| 561|  0.010|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.679|     0.122|    -3.165|   0.002|
|Unadjusted |sm_share_healthRarely                             |       1.203|     0.188|     0.982|   0.326|
|Unadjusted |sm_share_healthSometimes                          |       1.557|     0.266|     1.667|   0.095|
|Unadjusted |sm_share_healthUsually                            |       9.330|     0.633|     3.527|   0.000|
|Unadjusted |sm_share_healthAlways                             |       0.589|     0.846|    -0.625|   0.532|
|Adjusted   |(Intercept)                                       |       0.458|     0.488|    -1.600|   0.110|
|Adjusted   |sm_share_healthRarely                             |       1.182|     0.192|     0.871|   0.384|
|Adjusted   |sm_share_healthSometimes                          |       1.466|     0.272|     1.406|   0.160|
|Adjusted   |sm_share_healthUsually                            |       8.612|     0.640|     3.366|   0.001|
|Adjusted   |sm_share_healthAlways                             |       0.554|     0.869|    -0.680|   0.497|
|Adjusted   |age                                               |       0.997|     0.007|    -0.386|   0.699|
|Adjusted   |genderFemale                                      |       1.038|     0.223|     0.168|   0.867|
|Adjusted   |genderA gender not listed here                    | 1231115.557|   531.428|     0.026|   0.979|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.754|     0.779|     0.721|   0.471|
|Adjusted   |raceAsian                                         |       1.074|     0.747|     0.096|   0.924|
|Adjusted   |raceBlack or African American                     |       1.662|     0.829|     0.613|   0.540|
|Adjusted   |raceMultiple races                                |       1.573|     0.305|     1.487|   0.137|
|Adjusted   |raceOther                                         |       2.049|     0.559|     1.283|   0.200|
|Adjusted   |hispanicNo                                        |       1.406|     0.405|     0.842|   0.400|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.347|     0.181|     1.652|   0.099|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       792.655|     575| -385.961| 781.921| 803.702|  771.921|         571|
|Adjusted   |       792.655|     575| -380.952| 791.904| 857.246|  761.904|         561|


### PC-PTSD vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 6.082|   4| 570|      0|
|Adjusted   | 5.796|   4| 560|      0|

\newline


|model      |term                                              |   oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|-----------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |       0.691|     0.092|    -4.034|   0.000|
|Unadjusted |sm_share_suicideRarely                            |       2.976|     0.302|     3.615|   0.000|
|Unadjusted |sm_share_suicideSometimes                         |       5.791|     0.652|     2.694|   0.007|
|Unadjusted |sm_share_suicideUsually                           |      11.582|     1.065|     2.301|   0.021|
|Unadjusted |sm_share_suicideAlways                            |       1.448|     1.004|     0.368|   0.713|
|Adjusted   |(Intercept)                                       |       0.418|     0.504|    -1.731|   0.083|
|Adjusted   |sm_share_suicideRarely                            |       2.968|     0.306|     3.559|   0.000|
|Adjusted   |sm_share_suicideSometimes                         |       5.250|     0.665|     2.493|   0.013|
|Adjusted   |sm_share_suicideUsually                           |      12.279|     1.078|     2.326|   0.020|
|Adjusted   |sm_share_suicideAlways                            |       1.463|     1.012|     0.376|   0.707|
|Adjusted   |age                                               |       0.998|     0.007|    -0.289|   0.772|
|Adjusted   |genderFemale                                      |       1.059|     0.224|     0.255|   0.799|
|Adjusted   |genderA gender not listed here                    | 1589887.100|   547.398|     0.026|   0.979|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |       1.485|     0.792|     0.499|   0.618|
|Adjusted   |raceAsian                                         |       1.004|     0.778|     0.006|   0.995|
|Adjusted   |raceBlack or African American                     |       1.566|     0.821|     0.546|   0.585|
|Adjusted   |raceMultiple races                                |       1.699|     0.304|     1.743|   0.081|
|Adjusted   |raceOther                                         |       2.527|     0.558|     1.660|   0.097|
|Adjusted   |hispanicNo                                        |       1.523|     0.429|     0.980|   0.327|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |       1.263|     0.183|     1.275|   0.202|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        791.85|     574| -380.941| 771.882| 793.654|  761.882|         570|
|Adjusted   |        791.85|     574| -375.569| 781.138| 846.453|  751.138|         560|


### PHQ-2 vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.496|   5| 571|  0.779|
|Adjusted   | 0.531|   5| 561|  0.753|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.111|     1.054|    -2.084|   0.037|
|Unadjusted |fb_freqEvery_few_weeks                            |     0.000|   441.373|    -0.028|   0.978|
|Unadjusted |fb_freqOnce_a_week                                |     4.500|     1.364|     1.103|   0.270|
|Unadjusted |fb_freqA_few_times_a_week                         |     3.667|     1.113|     1.167|   0.243|
|Unadjusted |fb_freqOnce_a_day                                 |     4.404|     1.084|     1.367|   0.172|
|Unadjusted |fb_freqSeveral_times_a_day                        |     3.358|     1.059|     1.143|   0.253|
|Adjusted   |(Intercept)                                       |     0.121|     1.194|    -1.765|   0.078|
|Adjusted   |fb_freqEvery_few_weeks                            |     0.000|   437.784|    -0.028|   0.978|
|Adjusted   |fb_freqOnce_a_week                                |     4.389|     1.393|     1.062|   0.288|
|Adjusted   |fb_freqA_few_times_a_week                         |     3.793|     1.119|     1.191|   0.234|
|Adjusted   |fb_freqOnce_a_day                                 |     4.427|     1.091|     1.364|   0.173|
|Adjusted   |fb_freqSeveral_times_a_day                        |     3.251|     1.062|     1.110|   0.267|
|Adjusted   |age                                               |     0.980|     0.009|    -2.351|   0.019|
|Adjusted   |genderFemale                                      |     0.919|     0.248|    -0.339|   0.734|
|Adjusted   |genderA gender not listed here                    |     2.252|     1.427|     0.569|   0.570|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.451|     1.101|    -0.723|   0.470|
|Adjusted   |raceAsian                                         |     0.940|     0.830|    -0.074|   0.941|
|Adjusted   |raceBlack or African American                     |     1.158|     0.862|     0.171|   0.865|
|Adjusted   |raceMultiple races                                |     1.275|     0.320|     0.758|   0.449|
|Adjusted   |raceOther                                         |     2.788|     0.559|     1.834|   0.067|
|Adjusted   |hispanicNo                                        |     1.971|     0.470|     1.443|   0.149|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.153|     0.199|     0.718|   0.473|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       679.376|     576| -336.901| 685.802| 711.949|  673.802|         571|
|Adjusted   |       679.376|     576| -330.439| 692.878| 762.604|  660.878|         561|


### PHQ-2 vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.487|   4| 573|  0.745|
|Adjusted   | 0.293|   4| 563|  0.882|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.489|     0.254|    -2.808|   0.005|
|Unadjusted |comm_facebookOnce_a_week                          |     1.022|     0.424|     0.051|   0.960|
|Unadjusted |comm_facebookA_few_times_a_week                   |     0.713|     0.331|    -1.022|   0.307|
|Unadjusted |comm_facebookOnce_a_day                           |     0.759|     0.343|    -0.804|   0.421|
|Unadjusted |comm_facebookSeveral_times_a_day                  |     0.735|     0.291|    -1.057|   0.291|
|Adjusted   |(Intercept)                                       |     0.419|     0.592|    -1.469|   0.142|
|Adjusted   |comm_facebookOnce_a_week                          |     1.051|     0.434|     0.114|   0.909|
|Adjusted   |comm_facebookA_few_times_a_week                   |     0.745|     0.341|    -0.863|   0.388|
|Adjusted   |comm_facebookOnce_a_day                           |     0.839|     0.358|    -0.490|   0.624|
|Adjusted   |comm_facebookSeveral_times_a_day                  |     0.822|     0.302|    -0.650|   0.516|
|Adjusted   |age                                               |     0.984|     0.009|    -1.894|   0.058|
|Adjusted   |genderFemale                                      |     0.919|     0.248|    -0.339|   0.735|
|Adjusted   |genderA gender not listed here                    |     2.280|     1.431|     0.576|   0.565|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.422|     1.094|    -0.788|   0.431|
|Adjusted   |raceAsian                                         |     0.991|     0.834|    -0.011|   0.991|
|Adjusted   |raceBlack or African American                     |     1.151|     0.864|     0.163|   0.871|
|Adjusted   |raceMultiple races                                |     1.340|     0.318|     0.919|   0.358|
|Adjusted   |raceOther                                         |     2.827|     0.558|     1.863|   0.063|
|Adjusted   |hispanicNo                                        |     1.878|     0.470|     1.342|   0.180|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.242|     0.198|     1.093|   0.275|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       681.949|     577| -340.020| 690.040| 711.838|  680.040|         573|
|Adjusted   |       681.949|     577| -334.118| 698.236| 763.629|  668.236|         563|


### PHQ-2 vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.083|   4| 573|  0.364|
|Adjusted   | 1.285|   4| 563|  0.274|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.325|     0.161|    -6.976|   0.000|
|Unadjusted |sm_emot_supportRarely                             |     1.259|     0.228|     1.011|   0.312|
|Unadjusted |sm_emot_supportSometimes                          |     1.319|     0.250|     1.108|   0.268|
|Unadjusted |sm_emot_supportUsually                            |     1.055|     0.371|     0.145|   0.884|
|Unadjusted |sm_emot_supportAlways                             |     4.105|     0.781|     1.809|   0.070|
|Adjusted   |(Intercept)                                       |     0.304|     0.576|    -2.070|   0.038|
|Adjusted   |sm_emot_supportRarely                             |     1.328|     0.236|     1.203|   0.229|
|Adjusted   |sm_emot_supportSometimes                          |     1.371|     0.257|     1.225|   0.221|
|Adjusted   |sm_emot_supportUsually                            |     1.081|     0.385|     0.202|   0.840|
|Adjusted   |sm_emot_supportAlways                             |     4.744|     0.799|     1.948|   0.051|
|Adjusted   |age                                               |     0.982|     0.009|    -2.081|   0.037|
|Adjusted   |genderFemale                                      |     0.824|     0.254|    -0.763|   0.445|
|Adjusted   |genderA gender not listed here                    |     2.172|     1.433|     0.541|   0.588|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.509|     1.092|    -0.619|   0.536|
|Adjusted   |raceAsian                                         |     1.063|     0.839|     0.073|   0.942|
|Adjusted   |raceBlack or African American                     |     1.321|     0.869|     0.321|   0.749|
|Adjusted   |raceMultiple races                                |     1.296|     0.320|     0.810|   0.418|
|Adjusted   |raceOther                                         |     3.129|     0.561|     2.035|   0.042|
|Adjusted   |hispanicNo                                        |     1.934|     0.479|     1.376|   0.169|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.254|     0.197|     1.146|   0.252|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       681.949|     577| -338.802| 687.603| 709.401|  677.603|         573|
|Adjusted   |       681.949|     577| -332.113| 694.227| 759.620|  664.227|         563|


### PHQ-2 vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.327|   4| 572|  0.055|
|Adjusted   | 2.843|   4| 562|  0.024|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.374|     0.185|    -5.309|   0.000|
|Unadjusted |sm_med_infoRarely                                 |     0.731|     0.260|    -1.201|   0.230|
|Unadjusted |sm_med_infoSometimes                              |     1.235|     0.248|     0.850|   0.395|
|Unadjusted |sm_med_infoUsually                                |     1.646|     0.319|     1.563|   0.118|
|Unadjusted |sm_med_infoAlways                                 |     0.502|     0.656|    -1.052|   0.293|
|Adjusted   |(Intercept)                                       |     0.399|     0.577|    -1.594|   0.111|
|Adjusted   |sm_med_infoRarely                                 |     0.780|     0.266|    -0.931|   0.352|
|Adjusted   |sm_med_infoSometimes                              |     1.383|     0.259|     1.251|   0.211|
|Adjusted   |sm_med_infoUsually                                |     2.020|     0.334|     2.107|   0.035|
|Adjusted   |sm_med_infoAlways                                 |     0.591|     0.673|    -0.782|   0.434|
|Adjusted   |age                                               |     0.978|     0.009|    -2.452|   0.014|
|Adjusted   |genderFemale                                      |     0.881|     0.254|    -0.501|   0.616|
|Adjusted   |genderA gender not listed here                    |     2.304|     1.470|     0.568|   0.570|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.472|     1.094|    -0.686|   0.492|
|Adjusted   |raceAsian                                         |     1.105|     0.855|     0.117|   0.907|
|Adjusted   |raceBlack or African American                     |     1.342|     0.863|     0.341|   0.733|
|Adjusted   |raceMultiple races                                |     1.402|     0.322|     1.047|   0.295|
|Adjusted   |raceOther                                         |     2.855|     0.563|     1.862|   0.063|
|Adjusted   |hispanicNo                                        |     1.877|     0.476|     1.324|   0.186|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.211|     0.200|     0.957|   0.339|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       679.376|     576| -334.901| 679.803| 701.592|  669.803|         572|
|Adjusted   |       679.376|     576| -327.664| 685.329| 750.696|  655.329|         562|


### PHQ-2 vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.087|   4| 573|  0.081|
|Adjusted   | 2.461|   4| 563|  0.044|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.337|     0.153|    -7.096|   0.000|
|Unadjusted |sm_med_adviceRarely                               |     0.973|     0.233|    -0.116|   0.907|
|Unadjusted |sm_med_adviceSometimes                            |     1.415|     0.242|     1.434|   0.152|
|Unadjusted |sm_med_adviceUsually                              |     2.372|     0.369|     2.342|   0.019|
|Unadjusted |sm_med_adviceAlways                               |     0.593|     0.790|    -0.662|   0.508|
|Adjusted   |(Intercept)                                       |     0.359|     0.566|    -1.808|   0.071|
|Adjusted   |sm_med_adviceRarely                               |     1.046|     0.239|     0.188|   0.851|
|Adjusted   |sm_med_adviceSometimes                            |     1.672|     0.253|     2.033|   0.042|
|Adjusted   |sm_med_adviceUsually                              |     2.560|     0.380|     2.472|   0.013|
|Adjusted   |sm_med_adviceAlways                               |     0.738|     0.811|    -0.375|   0.707|
|Adjusted   |age                                               |     0.979|     0.009|    -2.463|   0.014|
|Adjusted   |genderFemale                                      |     0.943|     0.250|    -0.234|   0.815|
|Adjusted   |genderA gender not listed here                    |     2.037|     1.465|     0.486|   0.627|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.439|     1.097|    -0.751|   0.452|
|Adjusted   |raceAsian                                         |     1.048|     0.851|     0.055|   0.956|
|Adjusted   |raceBlack or African American                     |     1.403|     0.859|     0.395|   0.693|
|Adjusted   |raceMultiple races                                |     1.318|     0.322|     0.858|   0.391|
|Adjusted   |raceOther                                         |     2.859|     0.566|     1.857|   0.063|
|Adjusted   |hispanicNo                                        |     1.863|     0.475|     1.310|   0.190|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.230|     0.198|     1.044|   0.297|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       681.949|     577| -336.856| 683.713| 705.511|  673.713|         573|
|Adjusted   |       681.949|     577| -329.835| 689.669| 755.063|  659.669|         563|


### PHQ-2 vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 2.793|   4| 573|  0.026|
|Adjusted   | 3.712|   4| 563|  0.005|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.312|     0.143|    -8.130|   0.000|
|Unadjusted |sm_med_questionsRarely                            |     1.137|     0.226|     0.565|   0.572|
|Unadjusted |sm_med_questionsSometimes                         |     1.602|     0.257|     1.834|   0.067|
|Unadjusted |sm_med_questionsUsually                           |     3.203|     0.381|     3.052|   0.002|
|Unadjusted |sm_med_questionsAlways                            |     1.373|     0.705|     0.450|   0.653|
|Adjusted   |(Intercept)                                       |     0.359|     0.570|    -1.794|   0.073|
|Adjusted   |sm_med_questionsRarely                            |     1.144|     0.232|     0.578|   0.563|
|Adjusted   |sm_med_questionsSometimes                         |     1.886|     0.269|     2.355|   0.019|
|Adjusted   |sm_med_questionsUsually                           |     3.805|     0.393|     3.399|   0.001|
|Adjusted   |sm_med_questionsAlways                            |     1.246|     0.727|     0.303|   0.762|
|Adjusted   |age                                               |     0.977|     0.009|    -2.598|   0.009|
|Adjusted   |genderFemale                                      |     0.854|     0.252|    -0.626|   0.531|
|Adjusted   |genderA gender not listed here                    |     2.533|     1.437|     0.647|   0.518|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.430|     1.105|    -0.764|   0.445|
|Adjusted   |raceAsian                                         |     0.942|     0.866|    -0.068|   0.945|
|Adjusted   |raceBlack or African American                     |     1.311|     0.860|     0.315|   0.753|
|Adjusted   |raceMultiple races                                |     1.380|     0.324|     0.996|   0.319|
|Adjusted   |raceOther                                         |     3.277|     0.563|     2.108|   0.035|
|Adjusted   |hispanicNo                                        |     1.897|     0.478|     1.339|   0.181|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.206|     0.200|     0.936|   0.349|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       681.949|     577| -335.503| 681.005| 702.803|  671.005|         573|
|Adjusted   |       681.949|     577| -327.356| 684.712| 750.106|  654.712|         563|


### PHQ-2 vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 6.011|   4| 572|      0|
|Adjusted   | 6.139|   4| 562|      0|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.278|     0.138|    -9.269|   0.000|
|Unadjusted |sm_share_symptRarely                              |     1.341|     0.229|     1.279|   0.201|
|Unadjusted |sm_share_symptSometimes                           |     2.323|     0.269|     3.138|   0.002|
|Unadjusted |sm_share_symptUsually                             |     5.396|     0.397|     4.241|   0.000|
|Unadjusted |sm_share_symptAlways                              |     1.799|     0.720|     0.815|   0.415|
|Adjusted   |(Intercept)                                       |     0.266|     0.587|    -2.253|   0.024|
|Adjusted   |sm_share_symptRarely                              |     1.306|     0.234|     1.140|   0.254|
|Adjusted   |sm_share_symptSometimes                           |     2.370|     0.278|     3.101|   0.002|
|Adjusted   |sm_share_symptUsually                             |     5.798|     0.407|     4.322|   0.000|
|Adjusted   |sm_share_symptAlways                              |     1.776|     0.740|     0.776|   0.438|
|Adjusted   |age                                               |     0.981|     0.009|    -2.151|   0.031|
|Adjusted   |genderFemale                                      |     0.821|     0.255|    -0.776|   0.438|
|Adjusted   |genderA gender not listed here                    |     1.214|     1.647|     0.118|   0.906|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.476|     1.096|    -0.678|   0.498|
|Adjusted   |raceAsian                                         |     0.656|     0.870|    -0.485|   0.627|
|Adjusted   |raceBlack or African American                     |     0.940|     0.930|    -0.067|   0.947|
|Adjusted   |raceMultiple races                                |     1.298|     0.326|     0.800|   0.424|
|Adjusted   |raceOther                                         |     2.877|     0.573|     1.845|   0.065|
|Adjusted   |hispanicNo                                        |     2.066|     0.492|     1.474|   0.140|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.232|     0.202|     1.034|   0.301|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |         681.3|     576| -328.454| 666.909| 688.698|  656.909|         572|
|Adjusted   |         681.3|     576| -321.912| 673.825| 739.193|  643.825|         562|


### PHQ-2 vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.728|   4| 572|  0.005|
|Adjusted   | 3.378|   4| 562|  0.010|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.311|     0.141|    -8.279|   0.000|
|Unadjusted |sm_share_healthRarely                             |     1.299|     0.211|     1.238|   0.216|
|Unadjusted |sm_share_healthSometimes                          |     1.413|     0.292|     1.184|   0.236|
|Unadjusted |sm_share_healthUsually                            |     5.621|     0.465|     3.712|   0.000|
|Unadjusted |sm_share_healthAlways                             |     0.535|     1.089|    -0.574|   0.566|
|Adjusted   |(Intercept)                                       |     0.296|     0.573|    -2.121|   0.034|
|Adjusted   |sm_share_healthRarely                             |     1.319|     0.215|     1.287|   0.198|
|Adjusted   |sm_share_healthSometimes                          |     1.405|     0.302|     1.127|   0.260|
|Adjusted   |sm_share_healthUsually                            |     5.337|     0.476|     3.516|   0.000|
|Adjusted   |sm_share_healthAlways                             |     0.562|     1.111|    -0.518|   0.604|
|Adjusted   |age                                               |     0.984|     0.009|    -1.918|   0.055|
|Adjusted   |genderFemale                                      |     0.885|     0.252|    -0.485|   0.628|
|Adjusted   |genderA gender not listed here                    |     1.030|     1.579|     0.019|   0.985|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.505|     1.092|    -0.625|   0.532|
|Adjusted   |raceAsian                                         |     0.770|     0.866|    -0.302|   0.762|
|Adjusted   |raceBlack or African American                     |     1.082|     0.930|     0.084|   0.933|
|Adjusted   |raceMultiple races                                |     1.303|     0.326|     0.812|   0.417|
|Adjusted   |raceOther                                         |     2.943|     0.560|     1.928|   0.054|
|Adjusted   |hispanicNo                                        |     1.869|     0.481|     1.301|   0.193|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.210|     0.199|     0.960|   0.337|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |         681.3|     576| -332.820| 675.641| 697.430|  665.641|         572|
|Adjusted   |         681.3|     576| -327.314| 684.628| 749.996|  654.628|         562|


### PHQ-2 vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 7.572|   4| 571|      0|
|Adjusted   | 7.714|   4| 561|      0|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.308|     0.106|   -11.101|   0.000|
|Unadjusted |sm_share_suicideRarely                            |     3.134|     0.290|     3.941|   0.000|
|Unadjusted |sm_share_suicideSometimes                         |     4.875|     0.538|     2.946|   0.003|
|Unadjusted |sm_share_suicideUsually                           |    11.375|     0.809|     3.006|   0.003|
|Unadjusted |sm_share_suicideAlways                            |     1.083|     1.160|     0.069|   0.945|
|Adjusted   |(Intercept)                                       |     0.244|     0.616|    -2.293|   0.022|
|Adjusted   |sm_share_suicideRarely                            |     3.246|     0.298|     3.953|   0.000|
|Adjusted   |sm_share_suicideSometimes                         |     4.786|     0.558|     2.807|   0.005|
|Adjusted   |sm_share_suicideUsually                           |    15.317|     0.857|     3.185|   0.001|
|Adjusted   |sm_share_suicideAlways                            |     1.021|     1.167|     0.018|   0.985|
|Adjusted   |age                                               |     0.983|     0.009|    -1.969|   0.049|
|Adjusted   |genderFemale                                      |     0.927|     0.256|    -0.296|   0.767|
|Adjusted   |genderA gender not listed here                    |     1.278|     1.601|     0.153|   0.878|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.382|     1.106|    -0.870|   0.384|
|Adjusted   |raceAsian                                         |     0.619|     0.929|    -0.517|   0.605|
|Adjusted   |raceBlack or African American                     |     0.955|     0.937|    -0.049|   0.961|
|Adjusted   |raceMultiple races                                |     1.320|     0.330|     0.841|   0.401|
|Adjusted   |raceOther                                         |     3.910|     0.566|     2.410|   0.016|
|Adjusted   |hispanicNo                                        |     2.371|     0.531|     1.624|   0.104|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.117|     0.205|     0.538|   0.590|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        680.65|     575| -324.204| 658.408| 680.189|  648.408|         571|
|Adjusted   |        680.65|     575| -317.538| 665.075| 730.417|  635.075|         561|


### AUDIT-C vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.246|   5| 569|  0.286|
|Adjusted   | 1.490|   5| 560|  0.191|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.111|     1.054|    -2.085|   0.037|
|Unadjusted |fb_freqEvery_few_weeks                            |     3.000|     1.563|     0.703|   0.482|
|Unadjusted |fb_freqOnce_a_week                                |     1.800|     1.520|     0.387|   0.699|
|Unadjusted |fb_freqA_few_times_a_week                         |     5.040|     1.106|     1.463|   0.143|
|Unadjusted |fb_freqOnce_a_day                                 |     7.579|     1.081|     1.874|   0.061|
|Unadjusted |fb_freqSeveral_times_a_day                        |     6.866|     1.058|     1.820|   0.069|
|Adjusted   |(Intercept)                                       |     0.335|     1.170|    -0.934|   0.350|
|Adjusted   |fb_freqEvery_few_weeks                            |     4.179|     1.587|     0.901|   0.367|
|Adjusted   |fb_freqOnce_a_week                                |     0.760|     1.733|    -0.159|   0.874|
|Adjusted   |fb_freqA_few_times_a_week                         |     5.972|     1.118|     1.598|   0.110|
|Adjusted   |fb_freqOnce_a_day                                 |     9.125|     1.093|     2.023|   0.043|
|Adjusted   |fb_freqSeveral_times_a_day                        |     7.040|     1.066|     1.831|   0.067|
|Adjusted   |age                                               |     0.966|     0.008|    -4.200|   0.000|
|Adjusted   |genderFemale                                      |     0.701|     0.234|    -1.522|   0.128|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |    13.968|     1.228|     2.147|   0.032|
|Adjusted   |raceAsian                                         |     0.158|     1.097|    -1.682|   0.093|
|Adjusted   |raceBlack or African American                     |     1.181|     0.820|     0.203|   0.839|
|Adjusted   |raceMultiple races                                |     0.945|     0.308|    -0.185|   0.853|
|Adjusted   |raceOther                                         |     0.333|     0.681|    -1.615|   0.106|
|Adjusted   |hispanicNo                                        |     1.086|     0.403|     0.204|   0.839|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.716|     0.187|     2.896|   0.004|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       782.657|     574| -387.022| 786.044| 812.170|  774.044|         569|
|Adjusted   |       782.657|     574| -362.241| 754.482| 819.797|  724.482|         560|


### AUDIT-C vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.110|   4| 571|  0.351|
|Adjusted   | 1.457|   4| 562|  0.214|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.892|     0.239|    -0.478|   0.633|
|Unadjusted |comm_facebookOnce_a_week                          |     0.561|     0.416|    -1.393|   0.164|
|Unadjusted |comm_facebookA_few_times_a_week                   |     0.808|     0.304|    -0.701|   0.483|
|Unadjusted |comm_facebookOnce_a_day                           |     0.607|     0.323|    -1.550|   0.121|
|Unadjusted |comm_facebookSeveral_times_a_day                  |     0.900|     0.270|    -0.389|   0.697|
|Adjusted   |(Intercept)                                       |     2.265|     0.536|     1.525|   0.127|
|Adjusted   |comm_facebookOnce_a_week                          |     0.523|     0.438|    -1.481|   0.139|
|Adjusted   |comm_facebookA_few_times_a_week                   |     0.882|     0.323|    -0.389|   0.697|
|Adjusted   |comm_facebookOnce_a_day                           |     0.753|     0.344|    -0.826|   0.409|
|Adjusted   |comm_facebookSeveral_times_a_day                  |     1.139|     0.288|     0.452|   0.651|
|Adjusted   |age                                               |     0.966|     0.008|    -4.152|   0.000|
|Adjusted   |genderFemale                                      |     0.717|     0.234|    -1.420|   0.156|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     8.639|     1.095|     1.970|   0.049|
|Adjusted   |raceAsian                                         |     0.171|     1.093|    -1.617|   0.106|
|Adjusted   |raceBlack or African American                     |     1.360|     0.805|     0.382|   0.702|
|Adjusted   |raceMultiple races                                |     0.993|     0.307|    -0.022|   0.983|
|Adjusted   |raceOther                                         |     0.314|     0.685|    -1.691|   0.091|
|Adjusted   |hispanicNo                                        |     1.117|     0.409|     0.271|   0.786|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.835|     0.187|     3.239|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       783.748|     575| -389.612| 789.223| 811.004|  779.223|         571|
|Adjusted   |       783.748|     575| -364.885| 757.770| 818.755|  729.770|         562|


### AUDIT-C vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.930|   4| 571|  0.446|
|Adjusted   | 1.461|   4| 562|  0.213|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.664|     0.142|    -2.892|   0.004|
|Unadjusted |sm_emot_supportRarely                             |     1.267|     0.204|     1.160|   0.246|
|Unadjusted |sm_emot_supportSometimes                          |     1.119|     0.227|     0.496|   0.620|
|Unadjusted |sm_emot_supportUsually                            |     0.729|     0.345|    -0.917|   0.359|
|Unadjusted |sm_emot_supportAlways                             |     2.008|     0.777|     0.897|   0.369|
|Adjusted   |(Intercept)                                       |     2.071|     0.503|     1.448|   0.148|
|Adjusted   |sm_emot_supportRarely                             |     1.512|     0.219|     1.888|   0.059|
|Adjusted   |sm_emot_supportSometimes                          |     1.288|     0.242|     1.047|   0.295|
|Adjusted   |sm_emot_supportUsually                            |     0.815|     0.364|    -0.562|   0.574|
|Adjusted   |sm_emot_supportAlways                             |     2.363|     0.807|     1.066|   0.286|
|Adjusted   |age                                               |     0.965|     0.008|    -4.358|   0.000|
|Adjusted   |genderFemale                                      |     0.692|     0.239|    -1.544|   0.123|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     9.876|     1.096|     2.089|   0.037|
|Adjusted   |raceAsian                                         |     0.187|     1.105|    -1.520|   0.129|
|Adjusted   |raceBlack or African American                     |     1.451|     0.813|     0.458|   0.647|
|Adjusted   |raceMultiple races                                |     0.951|     0.308|    -0.165|   0.869|
|Adjusted   |raceOther                                         |     0.332|     0.685|    -1.609|   0.108|
|Adjusted   |hispanicNo                                        |     1.034|     0.408|     0.081|   0.935|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.742|     0.185|     3.000|   0.003|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       783.748|     575| -389.976| 789.953| 811.733|  779.953|         571|
|Adjusted   |       783.748|     575| -364.919| 757.839| 818.824|  729.839|         562|


### AUDIT-C vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.737|   4| 570|  0.567|
|Adjusted   | 0.147|   4| 561|  0.964|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.873|     0.165|    -0.821|   0.411|
|Unadjusted |sm_med_infoRarely                                 |     0.811|     0.225|    -0.929|   0.353|
|Unadjusted |sm_med_infoSometimes                              |     0.810|     0.227|    -0.931|   0.352|
|Unadjusted |sm_med_infoUsually                                |     0.658|     0.309|    -1.352|   0.176|
|Unadjusted |sm_med_infoAlways                                 |     0.528|     0.520|    -1.226|   0.220|
|Adjusted   |(Intercept)                                       |     2.271|     0.504|     1.626|   0.104|
|Adjusted   |sm_med_infoRarely                                 |     0.971|     0.237|    -0.123|   0.902|
|Adjusted   |sm_med_infoSometimes                              |     1.080|     0.243|     0.316|   0.752|
|Adjusted   |sm_med_infoUsually                                |     0.920|     0.330|    -0.252|   0.801|
|Adjusted   |sm_med_infoAlways                                 |     0.771|     0.550|    -0.472|   0.637|
|Adjusted   |age                                               |     0.967|     0.008|    -4.116|   0.000|
|Adjusted   |genderFemale                                      |     0.753|     0.236|    -1.205|   0.228|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     8.884|     1.096|     1.994|   0.046|
|Adjusted   |raceAsian                                         |     0.184|     1.097|    -1.545|   0.122|
|Adjusted   |raceBlack or African American                     |     1.206|     0.803|     0.233|   0.816|
|Adjusted   |raceMultiple races                                |     1.012|     0.305|     0.041|   0.968|
|Adjusted   |raceOther                                         |     0.311|     0.680|    -1.716|   0.086|
|Adjusted   |hispanicNo                                        |     1.069|     0.403|     0.165|   0.869|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.705|     0.185|     2.888|   0.004|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|    BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|------:|--------:|-----------:|
|Unadjusted |       782.011|     574| -389.509| 789.018| 810.79|  779.018|         570|
|Adjusted   |       782.011|     574| -366.864| 761.729| 822.69|  733.729|         561|


### AUDIT-C vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.307|   4| 571|  0.266|
|Adjusted   | 0.885|   4| 562|  0.472|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.868|     0.133|    -1.063|   0.288|
|Unadjusted |sm_med_adviceRarely                               |     0.687|     0.206|    -1.823|   0.068|
|Unadjusted |sm_med_adviceSometimes                            |     0.788|     0.224|    -1.061|   0.289|
|Unadjusted |sm_med_adviceUsually                              |     1.031|     0.360|     0.085|   0.932|
|Unadjusted |sm_med_adviceAlways                               |     0.384|     0.680|    -1.407|   0.159|
|Adjusted   |(Intercept)                                       |     2.386|     0.500|     1.741|   0.082|
|Adjusted   |sm_med_adviceRarely                               |     0.732|     0.216|    -1.443|   0.149|
|Adjusted   |sm_med_adviceSometimes                            |     0.958|     0.238|    -0.181|   0.856|
|Adjusted   |sm_med_adviceUsually                              |     1.227|     0.383|     0.535|   0.592|
|Adjusted   |sm_med_adviceAlways                               |     0.540|     0.710|    -0.867|   0.386|
|Adjusted   |age                                               |     0.967|     0.008|    -4.046|   0.000|
|Adjusted   |genderFemale                                      |     0.769|     0.234|    -1.123|   0.261|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     7.999|     1.096|     1.897|   0.058|
|Adjusted   |raceAsian                                         |     0.181|     1.096|    -1.561|   0.119|
|Adjusted   |raceBlack or African American                     |     1.255|     0.806|     0.282|   0.778|
|Adjusted   |raceMultiple races                                |     0.975|     0.307|    -0.083|   0.934|
|Adjusted   |raceOther                                         |     0.291|     0.681|    -1.813|   0.070|
|Adjusted   |hispanicNo                                        |     1.077|     0.408|     0.182|   0.856|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.761|     0.185|     3.059|   0.002|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       783.748|     575| -389.173| 788.346| 810.127|  778.346|         571|
|Adjusted   |       783.748|     575| -366.092| 760.184| 821.170|  732.184|         562|


### AUDIT-C vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.894|   4| 571|  0.467|
|Adjusted   | 0.510|   4| 562|  0.729|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.793|     0.123|    -1.886|   0.059|
|Unadjusted |sm_med_questionsRarely                            |     0.887|     0.199|    -0.598|   0.550|
|Unadjusted |sm_med_questionsSometimes                         |     0.700|     0.244|    -1.460|   0.144|
|Unadjusted |sm_med_questionsUsually                           |     1.261|     0.374|     0.619|   0.536|
|Unadjusted |sm_med_questionsAlways                            |     0.540|     0.701|    -0.879|   0.380|
|Adjusted   |(Intercept)                                       |     2.202|     0.497|     1.589|   0.112|
|Adjusted   |sm_med_questionsRarely                            |     0.966|     0.209|    -0.165|   0.869|
|Adjusted   |sm_med_questionsSometimes                         |     0.849|     0.259|    -0.630|   0.529|
|Adjusted   |sm_med_questionsUsually                           |     1.485|     0.397|     0.997|   0.319|
|Adjusted   |sm_med_questionsAlways                            |     0.640|     0.737|    -0.606|   0.544|
|Adjusted   |age                                               |     0.967|     0.008|    -4.107|   0.000|
|Adjusted   |genderFemale                                      |     0.747|     0.235|    -1.239|   0.215|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     8.369|     1.101|     1.930|   0.054|
|Adjusted   |raceAsian                                         |     0.175|     1.096|    -1.592|   0.111|
|Adjusted   |raceBlack or African American                     |     1.278|     0.807|     0.304|   0.761|
|Adjusted   |raceMultiple races                                |     0.992|     0.306|    -0.025|   0.980|
|Adjusted   |raceOther                                         |     0.331|     0.680|    -1.626|   0.104|
|Adjusted   |hispanicNo                                        |     1.092|     0.405|     0.218|   0.828|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.750|     0.185|     3.028|   0.002|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       783.748|     575| -390.053| 790.105| 811.886|  780.105|         571|
|Adjusted   |       783.748|     575| -366.864| 761.727| 822.713|  733.727|         562|


### AUDIT-C vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.594|   4| 570|  0.174|
|Adjusted   | 1.720|   4| 561|  0.144|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.706|     0.116|    -3.010|   0.003|
|Unadjusted |sm_share_symptRarely                              |     1.326|     0.200|     1.414|   0.158|
|Unadjusted |sm_share_symptSometimes                           |     0.915|     0.258|    -0.343|   0.732|
|Unadjusted |sm_share_symptUsually                             |     0.451|     0.449|    -1.773|   0.076|
|Unadjusted |sm_share_symptAlways                              |     1.134|     0.681|     0.185|   0.854|
|Adjusted   |(Intercept)                                       |     2.279|     0.501|     1.645|   0.100|
|Adjusted   |sm_share_symptRarely                              |     1.462|     0.212|     1.794|   0.073|
|Adjusted   |sm_share_symptSometimes                           |     1.021|     0.276|     0.074|   0.941|
|Adjusted   |sm_share_symptUsually                             |     0.483|     0.463|    -1.573|   0.116|
|Adjusted   |sm_share_symptAlways                              |     0.911|     0.724|    -0.129|   0.898|
|Adjusted   |age                                               |     0.967|     0.008|    -4.233|   0.000|
|Adjusted   |genderFemale                                      |     0.706|     0.235|    -1.481|   0.139|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     9.377|     1.098|     2.039|   0.041|
|Adjusted   |raceAsian                                         |     0.168|     1.111|    -1.604|   0.109|
|Adjusted   |raceBlack or African American                     |     1.335|     0.796|     0.363|   0.717|
|Adjusted   |raceMultiple races                                |     0.953|     0.308|    -0.157|   0.875|
|Adjusted   |raceOther                                         |     0.292|     0.689|    -1.785|   0.074|
|Adjusted   |hispanicNo                                        |     1.009|     0.407|     0.021|   0.983|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.717|     0.186|     2.912|   0.004|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       782.657|     574| -387.906| 785.811| 807.583|  775.811|         570|
|Adjusted   |       782.657|     574| -363.728| 755.455| 816.417|  727.455|         561|


### AUDIT-C vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.882|   4| 570|  0.474|
|Adjusted   | 0.857|   4| 561|  0.490|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.738|     0.121|    -2.509|   0.012|
|Unadjusted |sm_share_healthRarely                             |     1.072|     0.188|     0.372|   0.710|
|Unadjusted |sm_share_healthSometimes                          |     0.766|     0.274|    -0.972|   0.331|
|Unadjusted |sm_share_healthUsually                            |     1.233|     0.453|     0.461|   0.645|
|Unadjusted |sm_share_healthAlways                             |     0.226|     1.087|    -1.368|   0.171|
|Adjusted   |(Intercept)                                       |     2.100|     0.497|     1.492|   0.136|
|Adjusted   |sm_share_healthRarely                             |     1.192|     0.198|     0.885|   0.376|
|Adjusted   |sm_share_healthSometimes                          |     0.864|     0.292|    -0.501|   0.616|
|Adjusted   |sm_share_healthUsually                            |     1.145|     0.475|     0.285|   0.775|
|Adjusted   |sm_share_healthAlways                             |     0.210|     1.144|    -1.363|   0.173|
|Adjusted   |age                                               |     0.967|     0.008|    -4.187|   0.000|
|Adjusted   |genderFemale                                      |     0.742|     0.235|    -1.271|   0.204|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     9.621|     1.102|     2.055|   0.040|
|Adjusted   |raceAsian                                         |     0.173|     1.098|    -1.600|   0.110|
|Adjusted   |raceBlack or African American                     |     1.615|     0.819|     0.585|   0.559|
|Adjusted   |raceMultiple races                                |     0.998|     0.309|    -0.005|   0.996|
|Adjusted   |raceOther                                         |     0.339|     0.680|    -1.592|   0.111|
|Adjusted   |hispanicNo                                        |     1.104|     0.405|     0.245|   0.807|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.734|     0.184|     2.986|   0.003|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       782.657|     574| -389.209| 788.419| 810.191|  778.419|         570|
|Adjusted   |       782.657|     574| -365.513| 759.026| 819.987|  731.026|         561|


### AUDIT-C vs Share thoughts about suicide or hurting yourself in some way


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.769|   4| 569|  0.546|
|Adjusted   | 0.342|   4| 560|  0.850|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.697|     0.092|    -3.946|   0.000|
|Unadjusted |sm_share_suicideRarely                            |     1.601|     0.285|     1.651|   0.099|
|Unadjusted |sm_share_suicideSometimes                         |     1.436|     0.542|     0.667|   0.505|
|Unadjusted |sm_share_suicideUsually                           |     1.149|     0.677|     0.205|   0.838|
|Unadjusted |sm_share_suicideAlways                            |     0.000|   441.372|    -0.032|   0.974|
|Adjusted   |(Intercept)                                       |     2.255|     0.502|     1.621|   0.105|
|Adjusted   |sm_share_suicideRarely                            |     1.315|     0.301|     0.909|   0.364|
|Adjusted   |sm_share_suicideSometimes                         |     1.554|     0.573|     0.768|   0.442|
|Adjusted   |sm_share_suicideUsually                           |     1.144|     0.728|     0.185|   0.853|
|Adjusted   |sm_share_suicideAlways                            |     0.000|   433.811|    -0.033|   0.974|
|Adjusted   |age                                               |     0.967|     0.008|    -4.174|   0.000|
|Adjusted   |genderFemale                                      |     0.757|     0.234|    -1.192|   0.233|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     8.126|     1.095|     1.914|   0.056|
|Adjusted   |raceAsian                                         |     0.156|     1.116|    -1.665|   0.096|
|Adjusted   |raceBlack or African American                     |     1.120|     0.824|     0.138|   0.890|
|Adjusted   |raceMultiple races                                |     0.974|     0.307|    -0.087|   0.931|
|Adjusted   |raceOther                                         |     0.319|     0.680|    -1.680|   0.093|
|Adjusted   |hispanicNo                                        |     1.031|     0.414|     0.074|   0.941|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.727|     0.186|     2.939|   0.003|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       781.563|     573| -387.044| 784.088| 805.851|  774.088|         569|
|Adjusted   |       781.563|     573| -363.805| 755.610| 816.547|  727.610|         560|


### DSI-SS vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.640|   5| 571|  0.669|
|Adjusted   | 0.758|   5| 561|  0.581|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.250|     0.791|    -1.754|   0.080|
|Unadjusted |fb_freqEvery_few_weeks                            |     4.000|     1.275|     1.087|   0.277|
|Unadjusted |fb_freqOnce_a_week                                |     0.800|     1.351|    -0.165|   0.869|
|Unadjusted |fb_freqA_few_times_a_week                         |     0.727|     0.907|    -0.351|   0.725|
|Unadjusted |fb_freqOnce_a_day                                 |     1.385|     0.837|     0.389|   0.697|
|Unadjusted |fb_freqSeveral_times_a_day                        |     1.164|     0.799|     0.190|   0.849|
|Adjusted   |(Intercept)                                       |     0.538|     0.980|    -0.634|   0.526|
|Adjusted   |fb_freqEvery_few_weeks                            |     5.190|     1.292|     1.275|   0.202|
|Adjusted   |fb_freqOnce_a_week                                |     0.797|     1.403|    -0.162|   0.871|
|Adjusted   |fb_freqA_few_times_a_week                         |     0.671|     0.920|    -0.435|   0.664|
|Adjusted   |fb_freqOnce_a_day                                 |     1.213|     0.850|     0.227|   0.820|
|Adjusted   |fb_freqSeveral_times_a_day                        |     1.037|     0.807|     0.045|   0.964|
|Adjusted   |age                                               |     0.974|     0.010|    -2.698|   0.007|
|Adjusted   |genderFemale                                      |     0.861|     0.269|    -0.556|   0.578|
|Adjusted   |genderA gender not listed here                    |     2.833|     1.445|     0.720|   0.471|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   543.963|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.204|     0.841|     0.220|   0.826|
|Adjusted   |raceBlack or African American                     |     1.807|     0.883|     0.670|   0.503|
|Adjusted   |raceMultiple races                                |     1.934|     0.323|     2.044|   0.041|
|Adjusted   |raceOther                                         |     1.387|     0.625|     0.523|   0.601|
|Adjusted   |hispanicNo                                        |     1.166|     0.449|     0.341|   0.733|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.516|     0.212|     1.965|   0.049|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       615.704|     576| -306.231| 624.463| 650.610|  612.463|         571|
|Adjusted   |       615.704|     576| -294.193| 620.387| 690.112|  588.387|         561|


### DSI-SS vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.596|   4| 573|  0.666|
|Adjusted   | 0.307|   4| 563|  0.874|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.373|     0.269|    -3.674|   0.000|
|Unadjusted |comm_facebookOnce_a_week                          |     0.805|     0.465|    -0.465|   0.642|
|Unadjusted |comm_facebookA_few_times_a_week                   |     0.926|     0.342|    -0.226|   0.821|
|Unadjusted |comm_facebookOnce_a_day                           |     0.671|     0.372|    -1.074|   0.283|
|Unadjusted |comm_facebookSeveral_times_a_day                  |     0.697|     0.310|    -1.163|   0.245|
|Adjusted   |(Intercept)                                       |     0.638|     0.604|    -0.745|   0.456|
|Adjusted   |comm_facebookOnce_a_week                          |     0.794|     0.478|    -0.483|   0.629|
|Adjusted   |comm_facebookA_few_times_a_week                   |     0.947|     0.356|    -0.154|   0.877|
|Adjusted   |comm_facebookOnce_a_day                           |     0.729|     0.389|    -0.811|   0.417|
|Adjusted   |comm_facebookSeveral_times_a_day                  |     0.775|     0.324|    -0.786|   0.432|
|Adjusted   |age                                               |     0.976|     0.010|    -2.529|   0.011|
|Adjusted   |genderFemale                                      |     0.890|     0.269|    -0.433|   0.665|
|Adjusted   |genderA gender not listed here                    |     3.165|     1.453|     0.793|   0.428|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   540.332|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.190|     0.844|     0.206|   0.837|
|Adjusted   |raceBlack or African American                     |     1.695|     0.873|     0.604|   0.546|
|Adjusted   |raceMultiple races                                |     1.918|     0.320|     2.038|   0.042|
|Adjusted   |raceOther                                         |     1.333|     0.623|     0.462|   0.644|
|Adjusted   |hispanicNo                                        |     1.158|     0.449|     0.327|   0.743|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.505|     0.212|     1.931|   0.053|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       616.214|     577| -306.928| 623.857| 645.655|  613.857|         573|
|Adjusted   |       616.214|     577| -295.582| 621.165| 686.558|  591.165|         563|


### DSI-SS vs Get emotional support from others


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.552|   4| 573|  0.698|
|Adjusted   | 0.653|   4| 563|  0.625|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.259|     0.171|    -7.894|   0.000|
|Unadjusted |sm_emot_supportRarely                             |     1.353|     0.240|     1.260|   0.208|
|Unadjusted |sm_emot_supportSometimes                          |     1.012|     0.276|     0.043|   0.966|
|Unadjusted |sm_emot_supportUsually                            |     1.180|     0.385|     0.429|   0.668|
|Unadjusted |sm_emot_supportAlways                             |     0.643|     1.094|    -0.403|   0.687|
|Adjusted   |(Intercept)                                       |     0.552|     0.573|    -1.035|   0.301|
|Adjusted   |sm_emot_supportRarely                             |     1.420|     0.250|     1.405|   0.160|
|Adjusted   |sm_emot_supportSometimes                          |     1.034|     0.286|     0.118|   0.906|
|Adjusted   |sm_emot_supportUsually                            |     1.127|     0.405|     0.295|   0.768|
|Adjusted   |sm_emot_supportAlways                             |     0.629|     1.111|    -0.417|   0.676|
|Adjusted   |age                                               |     0.973|     0.010|    -2.855|   0.004|
|Adjusted   |genderFemale                                      |     0.858|     0.273|    -0.563|   0.573|
|Adjusted   |genderA gender not listed here                    |     2.954|     1.463|     0.740|   0.459|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   544.159|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.232|     0.850|     0.246|   0.806|
|Adjusted   |raceBlack or African American                     |     1.866|     0.874|     0.714|   0.475|
|Adjusted   |raceMultiple races                                |     1.849|     0.321|     1.916|   0.055|
|Adjusted   |raceOther                                         |     1.467|     0.624|     0.615|   0.539|
|Adjusted   |hispanicNo                                        |     1.101|     0.450|     0.214|   0.831|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.490|     0.210|     1.900|   0.057|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       616.214|     577| -306.996| 623.992| 645.790|  613.992|         573|
|Adjusted   |       616.214|     577| -294.876| 619.752| 685.146|  589.752|         563|


### DSI-SS vs Get information about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.562|   4| 572|  0.690|
|Adjusted   | 0.630|   4| 562|  0.642|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.287|     0.197|    -6.322|   0.000|
|Unadjusted |sm_med_infoRarely                                 |     1.153|     0.263|     0.541|   0.589|
|Unadjusted |sm_med_infoSometimes                              |     0.936|     0.272|    -0.242|   0.809|
|Unadjusted |sm_med_infoUsually                                |     1.089|     0.356|     0.240|   0.811|
|Unadjusted |sm_med_infoAlways                                 |     0.410|     0.773|    -1.153|   0.249|
|Adjusted   |(Intercept)                                       |     0.492|     0.581|    -1.222|   0.222|
|Adjusted   |sm_med_infoRarely                                 |     1.237|     0.272|     0.782|   0.434|
|Adjusted   |sm_med_infoSometimes                              |     1.072|     0.286|     0.244|   0.808|
|Adjusted   |sm_med_infoUsually                                |     1.378|     0.373|     0.860|   0.390|
|Adjusted   |sm_med_infoAlways                                 |     0.455|     0.797|    -0.989|   0.323|
|Adjusted   |age                                               |     0.973|     0.010|    -2.710|   0.007|
|Adjusted   |genderFemale                                      |     0.865|     0.272|    -0.535|   0.593|
|Adjusted   |genderA gender not listed here                    |     2.684|     1.441|     0.685|   0.493|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   543.646|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.306|     0.844|     0.316|   0.752|
|Adjusted   |raceBlack or African American                     |     1.730|     0.870|     0.629|   0.529|
|Adjusted   |raceMultiple races                                |     1.873|     0.321|     1.953|   0.051|
|Adjusted   |raceOther                                         |     1.373|     0.622|     0.510|   0.610|
|Adjusted   |hispanicNo                                        |     1.219|     0.452|     0.438|   0.661|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.545|     0.211|     2.066|   0.039|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       615.704|     576| -306.534| 623.068| 644.858|  613.068|         572|
|Adjusted   |       615.704|     576| -294.504| 619.008| 684.375|  589.008|         562|


### DSI-SS vs Get advice about health or medical topics


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.524|   4| 573|  0.718|
|Adjusted   | 0.510|   4| 563|  0.728|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.290|     0.159|    -7.789|   0.000|
|Unadjusted |sm_med_adviceRarely                               |     1.064|     0.239|     0.259|   0.796|
|Unadjusted |sm_med_adviceSometimes                            |     0.913|     0.269|    -0.337|   0.736|
|Unadjusted |sm_med_adviceUsually                              |     1.327|     0.405|     0.700|   0.484|
|Unadjusted |sm_med_adviceAlways                               |     0.314|     1.056|    -1.098|   0.272|
|Adjusted   |(Intercept)                                       |     0.546|     0.570|    -1.062|   0.288|
|Adjusted   |sm_med_adviceRarely                               |     1.150|     0.247|     0.567|   0.571|
|Adjusted   |sm_med_adviceSometimes                            |     1.088|     0.280|     0.301|   0.764|
|Adjusted   |sm_med_adviceUsually                              |     1.503|     0.420|     0.971|   0.331|
|Adjusted   |sm_med_adviceAlways                               |     0.380|     1.082|    -0.894|   0.371|
|Adjusted   |age                                               |     0.973|     0.010|    -2.762|   0.006|
|Adjusted   |genderFemale                                      |     0.898|     0.270|    -0.398|   0.691|
|Adjusted   |genderA gender not listed here                    |     2.913|     1.453|     0.736|   0.462|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   543.737|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.378|     0.850|     0.377|   0.706|
|Adjusted   |raceBlack or African American                     |     1.709|     0.865|     0.620|   0.535|
|Adjusted   |raceMultiple races                                |     1.855|     0.320|     1.930|   0.054|
|Adjusted   |raceOther                                         |     1.335|     0.624|     0.463|   0.643|
|Adjusted   |hispanicNo                                        |     1.145|     0.452|     0.301|   0.764|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.501|     0.210|     1.938|   0.053|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       616.214|     577| -306.831| 623.663| 645.461|  613.663|         573|
|Adjusted   |       616.214|     577| -295.036| 620.072| 685.466|  590.072|         563|


### DSI-SS vs Ask questions about health or medical issues


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.677|   4| 573|  0.608|
|Adjusted   | 1.267|   4| 563|  0.282|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.286|     0.146|    -8.558|   0.000|
|Unadjusted |sm_med_questionsRarely                            |     0.921|     0.240|    -0.343|   0.732|
|Unadjusted |sm_med_questionsSometimes                         |     1.135|     0.277|     0.458|   0.647|
|Unadjusted |sm_med_questionsUsually                           |     1.591|     0.409|     1.137|   0.256|
|Unadjusted |sm_med_questionsAlways                            |     0.389|     1.064|    -0.888|   0.375|
|Adjusted   |(Intercept)                                       |     0.559|     0.570|    -1.018|   0.309|
|Adjusted   |sm_med_questionsRarely                            |     0.903|     0.247|    -0.412|   0.680|
|Adjusted   |sm_med_questionsSometimes                         |     1.368|     0.291|     1.076|   0.282|
|Adjusted   |sm_med_questionsUsually                           |     1.876|     0.426|     1.476|   0.140|
|Adjusted   |sm_med_questionsAlways                            |     0.335|     1.085|    -1.008|   0.313|
|Adjusted   |age                                               |     0.971|     0.010|    -2.950|   0.003|
|Adjusted   |genderFemale                                      |     0.890|     0.271|    -0.429|   0.668|
|Adjusted   |genderA gender not listed here                    |     3.081|     1.442|     0.781|   0.435|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   543.519|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     1.417|     0.854|     0.408|   0.683|
|Adjusted   |raceBlack or African American                     |     1.760|     0.862|     0.656|   0.512|
|Adjusted   |raceMultiple races                                |     1.926|     0.323|     2.029|   0.042|
|Adjusted   |raceOther                                         |     1.519|     0.627|     0.667|   0.505|
|Adjusted   |hispanicNo                                        |     1.214|     0.452|     0.428|   0.668|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.522|     0.211|     1.988|   0.047|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       616.214|     577| -306.671| 623.343| 645.140|  613.343|         573|
|Adjusted   |       616.214|     577| -293.538| 617.075| 682.469|  587.075|         563|


### DSI-SS vs Share symptoms such as mood swings, depression, anxiety, or sleep problems


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.905|   4| 572|  0.004|
|Adjusted   | 3.713|   4| 562|  0.005|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.202|     0.152|   -10.508|   0.000|
|Unadjusted |sm_share_symptRarely                              |     1.922|     0.237|     2.756|   0.006|
|Unadjusted |sm_share_symptSometimes                           |     2.030|     0.291|     2.436|   0.015|
|Unadjusted |sm_share_symptUsually                             |     3.295|     0.403|     2.962|   0.003|
|Unadjusted |sm_share_symptAlways                              |     0.618|     1.071|    -0.449|   0.653|
|Adjusted   |(Intercept)                                       |     0.447|     0.587|    -1.373|   0.170|
|Adjusted   |sm_share_symptRarely                              |     1.841|     0.244|     2.496|   0.013|
|Adjusted   |sm_share_symptSometimes                           |     2.110|     0.304|     2.458|   0.014|
|Adjusted   |sm_share_symptUsually                             |     3.286|     0.420|     2.834|   0.005|
|Adjusted   |sm_share_symptAlways                              |     0.449|     1.104|    -0.724|   0.469|
|Adjusted   |age                                               |     0.973|     0.010|    -2.840|   0.005|
|Adjusted   |genderFemale                                      |     0.798|     0.274|    -0.823|   0.411|
|Adjusted   |genderA gender not listed here                    |     2.113|     1.599|     0.468|   0.640|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   544.919|    -0.026|   0.979|
|Adjusted   |raceAsian                                         |     0.878|     0.864|    -0.151|   0.880|
|Adjusted   |raceBlack or African American                     |     1.680|     0.910|     0.570|   0.569|
|Adjusted   |raceMultiple races                                |     1.755|     0.326|     1.725|   0.085|
|Adjusted   |raceOther                                         |     1.204|     0.639|     0.290|   0.771|
|Adjusted   |hispanicNo                                        |     1.128|     0.463|     0.260|   0.795|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.507|     0.213|     1.924|   0.054|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       615.704|     576| -299.948| 609.897| 631.686|  599.897|         572|
|Adjusted   |       615.704|     576| -288.363| 606.727| 672.094|  576.727|         562|


### DSI-SS vs Share information related to your health


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 3.202|   4| 572|  0.013|
|Adjusted   | 2.540|   4| 562|  0.039|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.224|     0.155|    -9.668|   0.000|
|Unadjusted |sm_share_healthRarely                             |     1.603|     0.224|     2.108|   0.035|
|Unadjusted |sm_share_healthSometimes                          |     1.277|     0.323|     0.758|   0.449|
|Unadjusted |sm_share_healthUsually                            |     4.471|     0.454|     3.301|   0.001|
|Unadjusted |sm_share_healthAlways                             |     0.000|   550.089|    -0.026|   0.980|
|Adjusted   |(Intercept)                                       |     0.445|     0.581|    -1.394|   0.163|
|Adjusted   |sm_share_healthRarely                             |     1.633|     0.230|     2.129|   0.033|
|Adjusted   |sm_share_healthSometimes                          |     1.336|     0.335|     0.863|   0.388|
|Adjusted   |sm_share_healthUsually                            |     3.785|     0.475|     2.802|   0.005|
|Adjusted   |sm_share_healthAlways                             |     0.000|   868.645|    -0.017|   0.986|
|Adjusted   |age                                               |     0.974|     0.010|    -2.732|   0.006|
|Adjusted   |genderFemale                                      |     0.848|     0.274|    -0.602|   0.547|
|Adjusted   |genderA gender not listed here                    |     1.460|     1.543|     0.245|   0.806|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   900.539|    -0.017|   0.987|
|Adjusted   |raceAsian                                         |     1.052|     0.860|     0.058|   0.953|
|Adjusted   |raceBlack or African American                     |     2.041|     0.955|     0.747|   0.455|
|Adjusted   |raceMultiple races                                |     1.821|     0.327|     1.834|   0.067|
|Adjusted   |raceOther                                         |     1.442|     0.625|     0.586|   0.558|
|Adjusted   |hispanicNo                                        |     1.164|     0.461|     0.329|   0.743|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.479|     0.212|     1.850|   0.064|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       615.704|     576| -299.782| 609.565| 631.354|  599.565|         572|
|Adjusted   |       615.704|     576| -288.978| 607.957| 673.324|  577.957|         562|


### DSI-SS vs Share thoughts about suicide or hurting yourself in some way


|model      |      F| df1| df2| pValue|
|:----------|------:|---:|---:|------:|
|Unadjusted | 10.570|   4| 571|      0|
|Adjusted   | 10.024|   4| 561|      0|

\newline


|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.217|     0.118|   -12.979|   0.000|
|Unadjusted |sm_share_suicideRarely                            |     5.133|     0.295|     5.553|   0.000|
|Unadjusted |sm_share_suicideSometimes                         |     5.260|     0.531|     3.128|   0.002|
|Unadjusted |sm_share_suicideUsually                           |     5.753|     0.681|     2.569|   0.010|
|Unadjusted |sm_share_suicideAlways                            |     0.000|   727.699|    -0.019|   0.985|
|Adjusted   |(Intercept)                                       |     0.438|     0.609|    -1.358|   0.174|
|Adjusted   |sm_share_suicideRarely                            |     5.608|     0.310|     5.555|   0.000|
|Adjusted   |sm_share_suicideSometimes                         |     4.856|     0.566|     2.793|   0.005|
|Adjusted   |sm_share_suicideUsually                           |     5.348|     0.723|     2.319|   0.020|
|Adjusted   |sm_share_suicideAlways                            |     0.000|  1192.309|    -0.013|   0.990|
|Adjusted   |age                                               |     0.973|     0.010|    -2.703|   0.007|
|Adjusted   |genderFemale                                      |     0.947|     0.280|    -0.196|   0.845|
|Adjusted   |genderA gender not listed here                    |     1.753|     1.657|     0.339|   0.735|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.000|   846.912|    -0.018|   0.985|
|Adjusted   |raceAsian                                         |     0.961|     0.930|    -0.043|   0.966|
|Adjusted   |raceBlack or African American                     |     1.201|     0.984|     0.186|   0.852|
|Adjusted   |raceMultiple races                                |     1.991|     0.333|     2.068|   0.039|
|Adjusted   |raceOther                                         |     1.889|     0.626|     1.017|   0.309|
|Adjusted   |hispanicNo                                        |     1.198|     0.492|     0.366|   0.714|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     1.312|     0.222|     1.224|   0.221|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       615.193|     575| -285.859| 581.718| 603.498|  571.718|         571|
|Adjusted   |       615.193|     575| -274.864| 579.728| 645.070|  549.728|         561|


## F-tests


|depvar    |indepvar         |model      |      F| df1| df2| pValue|indSig |
|:---------|:----------------|:----------|------:|---:|---:|------:|:------|
|indPTSD   |fb_freq          |Unadjusted |  1.373|   5| 570|  0.233|.      |
|indPTSD   |fb_freq          |Adjusted   |  1.302|   5| 560|  0.262|.      |
|indPTSD   |comm_facebook    |Unadjusted |  1.572|   4| 572|  0.180|.      |
|indPTSD   |comm_facebook    |Adjusted   |  1.388|   4| 562|  0.237|.      |
|indPTSD   |sm_emot_support  |Unadjusted |  1.460|   4| 572|  0.213|.      |
|indPTSD   |sm_emot_support  |Adjusted   |  1.692|   4| 562|  0.150|.      |
|indPTSD   |sm_med_info      |Unadjusted |  1.577|   4| 571|  0.179|.      |
|indPTSD   |sm_med_info      |Adjusted   |  1.767|   4| 561|  0.134|.      |
|indPTSD   |sm_med_advice    |Unadjusted |  2.114|   4| 572|  0.078|.      |
|indPTSD   |sm_med_advice    |Adjusted   |  2.174|   4| 562|  0.071|.      |
|indPTSD   |sm_med_questions |Unadjusted |  2.147|   4| 572|  0.074|.      |
|indPTSD   |sm_med_questions |Adjusted   |  2.376|   4| 562|  0.051|.      |
|indPTSD   |sm_share_sympt   |Unadjusted |  4.971|   4| 571|  0.001|***    |
|indPTSD   |sm_share_sympt   |Adjusted   |  4.671|   4| 561|  0.001|**     |
|indPTSD   |sm_share_health  |Unadjusted |  3.748|   4| 571|  0.005|**     |
|indPTSD   |sm_share_health  |Adjusted   |  3.345|   4| 561|  0.010|*      |
|indPTSD   |sm_share_suicide |Unadjusted |  6.082|   4| 570|  0.000|***    |
|indPTSD   |sm_share_suicide |Adjusted   |  5.796|   4| 560|  0.000|***    |
|indPHQ    |fb_freq          |Unadjusted |  0.496|   5| 571|  0.779|.      |
|indPHQ    |fb_freq          |Adjusted   |  0.531|   5| 561|  0.753|.      |
|indPHQ    |comm_facebook    |Unadjusted |  0.487|   4| 573|  0.745|.      |
|indPHQ    |comm_facebook    |Adjusted   |  0.293|   4| 563|  0.882|.      |
|indPHQ    |sm_emot_support  |Unadjusted |  1.083|   4| 573|  0.364|.      |
|indPHQ    |sm_emot_support  |Adjusted   |  1.285|   4| 563|  0.274|.      |
|indPHQ    |sm_med_info      |Unadjusted |  2.327|   4| 572|  0.055|.      |
|indPHQ    |sm_med_info      |Adjusted   |  2.843|   4| 562|  0.024|*      |
|indPHQ    |sm_med_advice    |Unadjusted |  2.087|   4| 573|  0.081|.      |
|indPHQ    |sm_med_advice    |Adjusted   |  2.461|   4| 563|  0.044|*      |
|indPHQ    |sm_med_questions |Unadjusted |  2.793|   4| 573|  0.026|*      |
|indPHQ    |sm_med_questions |Adjusted   |  3.712|   4| 563|  0.005|**     |
|indPHQ    |sm_share_sympt   |Unadjusted |  6.011|   4| 572|  0.000|***    |
|indPHQ    |sm_share_sympt   |Adjusted   |  6.139|   4| 562|  0.000|***    |
|indPHQ    |sm_share_health  |Unadjusted |  3.728|   4| 572|  0.005|**     |
|indPHQ    |sm_share_health  |Adjusted   |  3.378|   4| 562|  0.010|**     |
|indPHQ    |sm_share_suicide |Unadjusted |  7.572|   4| 571|  0.000|***    |
|indPHQ    |sm_share_suicide |Adjusted   |  7.714|   4| 561|  0.000|***    |
|indAuditC |fb_freq          |Unadjusted |  1.246|   5| 569|  0.286|.      |
|indAuditC |fb_freq          |Adjusted   |  1.490|   5| 560|  0.191|.      |
|indAuditC |comm_facebook    |Unadjusted |  1.110|   4| 571|  0.351|.      |
|indAuditC |comm_facebook    |Adjusted   |  1.457|   4| 562|  0.214|.      |
|indAuditC |sm_emot_support  |Unadjusted |  0.930|   4| 571|  0.446|.      |
|indAuditC |sm_emot_support  |Adjusted   |  1.461|   4| 562|  0.213|.      |
|indAuditC |sm_med_info      |Unadjusted |  0.737|   4| 570|  0.567|.      |
|indAuditC |sm_med_info      |Adjusted   |  0.147|   4| 561|  0.964|.      |
|indAuditC |sm_med_advice    |Unadjusted |  1.307|   4| 571|  0.266|.      |
|indAuditC |sm_med_advice    |Adjusted   |  0.885|   4| 562|  0.472|.      |
|indAuditC |sm_med_questions |Unadjusted |  0.894|   4| 571|  0.467|.      |
|indAuditC |sm_med_questions |Adjusted   |  0.510|   4| 562|  0.729|.      |
|indAuditC |sm_share_sympt   |Unadjusted |  1.594|   4| 570|  0.174|.      |
|indAuditC |sm_share_sympt   |Adjusted   |  1.720|   4| 561|  0.144|.      |
|indAuditC |sm_share_health  |Unadjusted |  0.882|   4| 570|  0.474|.      |
|indAuditC |sm_share_health  |Adjusted   |  0.857|   4| 561|  0.490|.      |
|indAuditC |sm_share_suicide |Unadjusted |  0.769|   4| 569|  0.546|.      |
|indAuditC |sm_share_suicide |Adjusted   |  0.342|   4| 560|  0.850|.      |
|indDSISS  |fb_freq          |Unadjusted |  0.640|   5| 571|  0.669|.      |
|indDSISS  |fb_freq          |Adjusted   |  0.758|   5| 561|  0.581|.      |
|indDSISS  |comm_facebook    |Unadjusted |  0.596|   4| 573|  0.666|.      |
|indDSISS  |comm_facebook    |Adjusted   |  0.307|   4| 563|  0.874|.      |
|indDSISS  |sm_emot_support  |Unadjusted |  0.552|   4| 573|  0.698|.      |
|indDSISS  |sm_emot_support  |Adjusted   |  0.653|   4| 563|  0.625|.      |
|indDSISS  |sm_med_info      |Unadjusted |  0.562|   4| 572|  0.690|.      |
|indDSISS  |sm_med_info      |Adjusted   |  0.630|   4| 562|  0.642|.      |
|indDSISS  |sm_med_advice    |Unadjusted |  0.524|   4| 573|  0.718|.      |
|indDSISS  |sm_med_advice    |Adjusted   |  0.510|   4| 563|  0.728|.      |
|indDSISS  |sm_med_questions |Unadjusted |  0.677|   4| 573|  0.608|.      |
|indDSISS  |sm_med_questions |Adjusted   |  1.267|   4| 563|  0.282|.      |
|indDSISS  |sm_share_sympt   |Unadjusted |  3.905|   4| 572|  0.004|**     |
|indDSISS  |sm_share_sympt   |Adjusted   |  3.713|   4| 562|  0.005|**     |
|indDSISS  |sm_share_health  |Unadjusted |  3.202|   4| 572|  0.013|*      |
|indDSISS  |sm_share_health  |Adjusted   |  2.540|   4| 562|  0.039|*      |
|indDSISS  |sm_share_suicide |Unadjusted | 10.570|   4| 571|  0.000|***    |
|indDSISS  |sm_share_suicide |Adjusted   | 10.024|   4| 561|  0.000|***    |


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



Set modeling covariates.


```
## [1] "age"      "gender"   "race"     "hispanic" "marital2"
```

### Never enrolled in VA



**PC-PTSD**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.345|     0.226|    -4.709|   0.000|
|Unadjusted |fmssSubscore                                      |     0.927|     0.058|    -1.290|   0.197|
|Unadjusted |indNotPTSDTRUE                                    |     2.625|     0.288|     3.355|   0.001|
|Unadjusted |fmssSubscore:indNotPTSDTRUE                       |     1.011|     0.073|     0.155|   0.877|
|Adjusted   |(Intercept)                                       |     1.187|     0.540|     0.317|   0.751|
|Adjusted   |fmssSubscore                                      |     0.933|     0.059|    -1.170|   0.242|
|Adjusted   |age                                               |     0.986|     0.008|    -1.813|   0.070|
|Adjusted   |genderFemale                                      |     0.743|     0.251|    -1.181|   0.238|
|Adjusted   |genderA gender not listed here                    |     3.181|     1.426|     0.812|   0.417|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     1.035|     0.873|     0.039|   0.969|
|Adjusted   |raceAsian                                         |     1.132|     0.780|     0.159|   0.874|
|Adjusted   |raceBlack or African American                     |     0.394|     1.101|    -0.846|   0.398|
|Adjusted   |raceMultiple races                                |     0.666|     0.349|    -1.166|   0.244|
|Adjusted   |raceOther                                         |     1.028|     0.617|     0.044|   0.965|
|Adjusted   |hispanicNo                                        |     0.552|     0.411|    -1.445|   0.148|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.921|     0.197|    -0.417|   0.677|
|Adjusted   |indNotPTSDTRUE                                    |     2.674|     0.293|     3.356|   0.001|
|Adjusted   |fmssSubscore:indNotPTSDTRUE                       |     1.007|     0.074|     0.090|   0.928|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       726.641|     572| -346.909| 701.819| 719.222|  693.819|         569|
|Adjusted   |       726.641|     572| -341.584| 711.168| 772.081|  683.168|         559|

**PHQ-2**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.485|     0.265|    -2.727|   0.006|
|Unadjusted |fmssSubscore                                      |     0.856|     0.074|    -2.109|   0.035|
|Unadjusted |indNotPHQTRUE                                     |     1.353|     0.310|     0.976|   0.329|
|Unadjusted |fmssSubscore:indNotPHQTRUE                        |     1.123|     0.083|     1.394|   0.163|
|Adjusted   |(Intercept)                                       |     1.777|     0.555|     1.036|   0.300|
|Adjusted   |fmssSubscore                                      |     0.864|     0.075|    -1.950|   0.051|
|Adjusted   |age                                               |     0.984|     0.008|    -2.043|   0.041|
|Adjusted   |genderFemale                                      |     0.732|     0.248|    -1.256|   0.209|
|Adjusted   |genderA gender not listed here                    |     2.125|     1.449|     0.520|   0.603|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.845|     0.864|    -0.195|   0.846|
|Adjusted   |raceAsian                                         |     1.083|     0.751|     0.106|   0.916|
|Adjusted   |raceBlack or African American                     |     0.340|     1.105|    -0.975|   0.329|
|Adjusted   |raceMultiple races                                |     0.632|     0.342|    -1.340|   0.180|
|Adjusted   |raceOther                                         |     0.992|     0.597|    -0.013|   0.989|
|Adjusted   |hispanicNo                                        |     0.563|     0.401|    -1.434|   0.152|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.859|     0.194|    -0.787|   0.431|
|Adjusted   |indNotPHQTRUE                                     |     1.434|     0.316|     1.140|   0.254|
|Adjusted   |fmssSubscore:indNotPHQTRUE                        |     1.115|     0.085|     1.290|   0.197|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       728.856|     573| -356.950| 721.900| 739.311|  713.900|         570|
|Adjusted   |       728.856|     573| -350.762| 729.524| 790.460|  701.524|         560|

**AUDIT-C**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.793|     0.209|    -1.107|   0.268|
|Unadjusted |fmssSubscore                                      |     0.894|     0.056|    -2.008|   0.045|
|Unadjusted |indNotAuditCTRUE                                  |     0.613|     0.277|    -1.765|   0.078|
|Unadjusted |fmssSubscore:indNotAuditCTRUE                     |     1.083|     0.071|     1.124|   0.261|
|Adjusted   |(Intercept)                                       |     2.753|     0.519|     1.953|   0.051|
|Adjusted   |fmssSubscore                                      |     0.909|     0.056|    -1.684|   0.092|
|Adjusted   |age                                               |     0.987|     0.008|    -1.629|   0.103|
|Adjusted   |genderFemale                                      |     0.779|     0.247|    -1.010|   0.312|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.856|     0.859|    -0.182|   0.856|
|Adjusted   |raceAsian                                         |     1.189|     0.752|     0.231|   0.818|
|Adjusted   |raceBlack or African American                     |     0.347|     1.099|    -0.962|   0.336|
|Adjusted   |raceMultiple races                                |     0.612|     0.341|    -1.440|   0.150|
|Adjusted   |raceOther                                         |     0.940|     0.589|    -0.105|   0.917|
|Adjusted   |hispanicNo                                        |     0.530|     0.398|    -1.594|   0.111|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.784|     0.196|    -1.241|   0.215|
|Adjusted   |indNotAuditCTRUE                                  |     0.662|     0.288|    -1.432|   0.152|
|Adjusted   |fmssSubscore:indNotAuditCTRUE                     |     1.063|     0.071|     0.862|   0.389|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       724.419|     571| -358.757| 725.514| 742.910|  717.514|         568|
|Adjusted   |       724.419|     571| -353.257| 732.515| 789.054|  706.515|         559|

**DSI-SS**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.369|     0.297|    -3.350|   0.001|
|Unadjusted |fmssSubscore                                      |     1.068|     0.075|     0.881|   0.378|
|Unadjusted |indNotDSISSTRUE                                   |     1.871|     0.335|     1.872|   0.061|
|Unadjusted |fmssSubscore:indNotDSISSTRUE                      |     0.849|     0.084|    -1.948|   0.051|
|Adjusted   |(Intercept)                                       |     1.368|     0.567|     0.553|   0.580|
|Adjusted   |fmssSubscore                                      |     1.072|     0.076|     0.913|   0.361|
|Adjusted   |age                                               |     0.986|     0.008|    -1.808|   0.071|
|Adjusted   |genderFemale                                      |     0.742|     0.247|    -1.208|   0.227|
|Adjusted   |genderA gender not listed here                    |     1.688|     1.421|     0.368|   0.713|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     0.903|     0.856|    -0.120|   0.905|
|Adjusted   |raceAsian                                         |     1.107|     0.748|     0.135|   0.892|
|Adjusted   |raceBlack or African American                     |     0.332|     1.106|    -0.998|   0.318|
|Adjusted   |raceMultiple races                                |     0.603|     0.342|    -1.477|   0.140|
|Adjusted   |raceOther                                         |     0.873|     0.592|    -0.229|   0.819|
|Adjusted   |hispanicNo                                        |     0.513|     0.398|    -1.675|   0.094|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.907|     0.195|    -0.501|   0.617|
|Adjusted   |indNotDSISSTRUE                                   |     1.929|     0.344|     1.908|   0.056|
|Adjusted   |fmssSubscore:indNotDSISSTRUE                      |     0.850|     0.085|    -1.896|   0.058|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       728.856|     573| -360.533| 729.065| 746.476|  721.065|         570|
|Adjusted   |       728.856|     573| -354.571| 737.142| 798.079|  709.142|         560|


### Did not use VA health services in prior 12 months



**PC-PTSD**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.750|     0.195|    -1.475|   0.140|
|Unadjusted |fmssSubscore                                      |     0.963|     0.047|    -0.789|   0.430|
|Unadjusted |indNotPTSDTRUE                                    |     3.674|     0.276|     4.712|   0.000|
|Unadjusted |fmssSubscore:indNotPTSDTRUE                       |     0.954|     0.065|    -0.712|   0.476|
|Adjusted   |(Intercept)                                       |     3.465|     0.543|     2.289|   0.022|
|Adjusted   |fmssSubscore                                      |     0.977|     0.048|    -0.492|   0.623|
|Adjusted   |age                                               |     0.985|     0.008|    -2.003|   0.045|
|Adjusted   |genderFemale                                      |     0.538|     0.233|    -2.665|   0.008|
|Adjusted   |genderA gender not listed here                    |     1.203|     1.423|     0.130|   0.897|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     1.530|     0.823|     0.517|   0.605|
|Adjusted   |raceAsian                                         |     1.466|     0.820|     0.467|   0.641|
|Adjusted   |raceBlack or African American                     |     0.777|     0.802|    -0.315|   0.753|
|Adjusted   |raceMultiple races                                |     0.581|     0.317|    -1.711|   0.087|
|Adjusted   |raceOther                                         |     1.105|     0.597|     0.168|   0.867|
|Adjusted   |hispanicNo                                        |     0.477|     0.439|    -1.684|   0.092|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.775|     0.189|    -1.350|   0.177|
|Adjusted   |indNotPTSDTRUE                                    |     3.730|     0.285|     4.626|   0.000|
|Adjusted   |fmssSubscore:indNotPTSDTRUE                       |     0.951|     0.067|    -0.742|   0.458|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       787.069|     571| -369.382| 746.763| 764.160|  738.763|         568|
|Adjusted   |       787.069|     571| -359.473| 746.946| 807.834|  718.946|         558|

**PHQ-2**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.838|     0.243|    -0.729|   0.466|
|Unadjusted |fmssSubscore                                      |     0.896|     0.061|    -1.801|   0.072|
|Unadjusted |indNotPHQTRUE                                     |     2.216|     0.292|     2.729|   0.006|
|Unadjusted |fmssSubscore:indNotPHQTRUE                        |     1.071|     0.072|     0.959|   0.338|
|Adjusted   |(Intercept)                                       |     3.947|     0.561|     2.449|   0.014|
|Adjusted   |fmssSubscore                                      |     0.913|     0.062|    -1.455|   0.146|
|Adjusted   |age                                               |     0.982|     0.008|    -2.406|   0.016|
|Adjusted   |genderFemale                                      |     0.529|     0.230|    -2.775|   0.006|
|Adjusted   |genderA gender not listed here                    |     0.811|     1.490|    -0.141|   0.888|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     1.126|     0.831|     0.143|   0.886|
|Adjusted   |raceAsian                                         |     1.280|     0.765|     0.323|   0.747|
|Adjusted   |raceBlack or African American                     |     0.663|     0.815|    -0.503|   0.615|
|Adjusted   |raceMultiple races                                |     0.548|     0.310|    -1.941|   0.052|
|Adjusted   |raceOther                                         |     1.097|     0.590|     0.158|   0.875|
|Adjusted   |hispanicNo                                        |     0.523|     0.432|    -1.500|   0.134|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.729|     0.187|    -1.693|   0.091|
|Adjusted   |indNotPHQTRUE                                     |     2.419|     0.301|     2.932|   0.003|
|Adjusted   |fmssSubscore:indNotPHQTRUE                        |     1.061|     0.074|     0.804|   0.422|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       788.261|     572| -377.901| 763.803| 781.206|  755.803|         569|
|Adjusted   |       788.261|     572| -366.261| 760.521| 821.434|  732.521|         559|

**AUDIT-C**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     1.843|     0.212|     2.889|   0.004|
|Unadjusted |fmssSubscore                                      |     0.918|     0.053|    -1.620|   0.105|
|Unadjusted |indNotAuditCTRUE                                  |     0.692|     0.271|    -1.360|   0.174|
|Unadjusted |fmssSubscore:indNotAuditCTRUE                     |     1.046|     0.066|     0.681|   0.496|
|Adjusted   |(Intercept)                                       |     7.930|     0.530|     3.908|   0.000|
|Adjusted   |fmssSubscore                                      |     0.941|     0.054|    -1.109|   0.268|
|Adjusted   |age                                               |     0.987|     0.008|    -1.735|   0.083|
|Adjusted   |genderFemale                                      |     0.572|     0.225|    -2.490|   0.013|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     1.200|     0.794|     0.230|   0.818|
|Adjusted   |raceAsian                                         |     1.371|     0.761|     0.414|   0.679|
|Adjusted   |raceBlack or African American                     |     0.650|     0.793|    -0.543|   0.587|
|Adjusted   |raceMultiple races                                |     0.528|     0.303|    -2.105|   0.035|
|Adjusted   |raceOther                                         |     0.928|     0.567|    -0.131|   0.896|
|Adjusted   |hispanicNo                                        |     0.476|     0.421|    -1.762|   0.078|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.670|     0.185|    -2.167|   0.030|
|Adjusted   |indNotAuditCTRUE                                  |     0.746|     0.285|    -1.028|   0.304|
|Adjusted   |fmssSubscore:indNotAuditCTRUE                     |     1.027|     0.068|     0.390|   0.697|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       785.467|     570| -389.900| 787.799| 805.189|  779.799|         567|
|Adjusted   |       785.467|     570| -378.768| 783.536| 840.052|  757.536|         558|

**DSI-SS**




|model      |term                                              | oddsratio| std.error| statistic| p.value|
|:----------|:-------------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                       |     0.965|     0.270|    -0.133|   0.894|
|Unadjusted |fmssSubscore                                      |     0.934|     0.072|    -0.959|   0.337|
|Unadjusted |indNotDSISSTRUE                                   |     1.801|     0.311|     1.895|   0.058|
|Unadjusted |fmssSubscore:indNotDSISSTRUE                      |     1.006|     0.080|     0.075|   0.940|
|Adjusted   |(Intercept)                                       |     5.107|     0.569|     2.865|   0.004|
|Adjusted   |fmssSubscore                                      |     0.932|     0.074|    -0.960|   0.337|
|Adjusted   |age                                               |     0.983|     0.008|    -2.311|   0.021|
|Adjusted   |genderFemale                                      |     0.538|     0.226|    -2.742|   0.006|
|Adjusted   |genderA gender not listed here                    |     0.762|     1.450|    -0.188|   0.851|
|Adjusted   |raceAmerican Indian/Alaska Native/Native Hawaiian |     1.125|     0.790|     0.149|   0.881|
|Adjusted   |raceAsian                                         |     1.296|     0.760|     0.341|   0.733|
|Adjusted   |raceBlack or African American                     |     0.681|     0.803|    -0.479|   0.632|
|Adjusted   |raceMultiple races                                |     0.560|     0.307|    -1.888|   0.059|
|Adjusted   |raceOther                                         |     0.920|     0.571|    -0.147|   0.883|
|Adjusted   |hispanicNo                                        |     0.478|     0.424|    -1.745|   0.081|
|Adjusted   |marital2Single/Divorced/Widowed/Separated         |     0.735|     0.185|    -1.663|   0.096|
|Adjusted   |indNotDSISSTRUE                                   |     1.769|     0.324|     1.763|   0.078|
|Adjusted   |fmssSubscore:indNotDSISSTRUE                      |     1.025|     0.083|     0.296|   0.768|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        787.84|     572| -387.732| 783.464| 800.868|  775.464|         569|
|Adjusted   |        787.84|     572| -376.098| 780.195| 841.107|  752.195|         559|
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



|gender                   |fb_freq                       |  n  |  N  | freq  |
|:------------------------|:-----------------------------|:---:|:---:|:-----:|
|Male                     |Less_than_several_times_a_day | 108 | 472 | 0.229 |
|Male                     |Several_times_a_day           | 364 | 472 | 0.771 |
|Female                   |Less_than_several_times_a_day | 25  | 111 | 0.225 |
|Female                   |Several_times_a_day           | 86  | 111 | 0.775 |
|A gender not listed here |Several_times_a_day           |  2  |  2  | 1.000 |

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



|marital2                          |fb_freq                       |  n  |  N  | freq  |
|:---------------------------------|:-----------------------------|:---:|:---:|:-----:|
|Married or living as married      |Less_than_several_times_a_day | 79  | 362 | 0.218 |
|Married or living as married      |Several_times_a_day           | 283 | 362 | 0.782 |
|Single/Divorced/Widowed/Separated |Less_than_several_times_a_day | 53  | 222 | 0.239 |
|Single/Divorced/Widowed/Separated |Several_times_a_day           | 169 | 222 | 0.761 |

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  dfTemp$marital2 and dfTemp$fb_freq
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
