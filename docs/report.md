---
title: "Psychiatric Symptoms of Veterans Surveyed Through Facebook Ads"
date: "2017-08-24 10:16:18"
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



Inclusion criteria

* Respondents who consented
* Eligible, ineligible, or missing eligibility indicator

**Number included: n = 1329**

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



Check.

![plot of chunk histogramFMSS](../figures/histogramFMSS-1.png)


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
|ptsd      |FALSE   | 0.9  | 0.9 |  0  |  2  | 255 | 47.9% |
|ptsd      |TRUE    | 4.2  | 0.8 |  3  |  5  | 277 | 52.1% |

\newline


|yvariable |indPHQ | mean | sd  | min | max |  n  | freq  |
|:---------|:------|:----:|:---:|:---:|:---:|:---:|:-----:|
|phq       |FALSE  | 0.9  | 0.9 |  0  |  2  | 448 | 72.3% |
|phq       |TRUE   | 4.5  | 1.2 |  3  |  6  | 172 | 27.7% |

\newline


|yvariable |indAuditC | mean | sd  | min | max |  n  | freq  |
|:---------|:---------|:----:|:---:|:---:|:---:|:---:|:-----:|
|auditc    |FALSE     | 1.8  | 0.8 |  1  |  3  | 246 | 49.0% |
|auditc    |TRUE      | 5.8  | 2.1 |  3  | 12  | 256 | 51.0% |

\newline


|yvariable |indDSISS | mean | sd  | min | max |  n  | freq  |
|:---------|:--------|:----:|:---:|:---:|:---:|:---:|:-----:|
|dsiss     |FALSE    | 0.1  | 0.3 |  0  |  1  | 482 | 78.2% |
|dsiss     |TRUE     | 3.9  | 1.6 |  2  |  9  | 134 | 21.8% |


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


|smOther |sm_used_other                                                                       |    n|
|:-------|:-----------------------------------------------------------------------------------|----:|
|FALSE   |                                                                                    | 1289|
|FALSE   |aol                                                                                 |    1|
|FALSE   |e-mail                                                                              |    1|
|FALSE   |google; bing                                                                        |    1|
|FALSE   |I use Wikipedia to read about illnesses I don't have; it's a curiosity/hobby thing. |    1|
|FALSE   |just in person                                                                      |    1|
|FALSE   |Just plain internet search                                                          |    1|
|FALSE   |TV/phone conversations, veterans group meetings                                     |    1|
|FALSE   |Web MD,                                                                             |    1|
|FALSE   |webmd                                                                               |    1|
|TRUE    |4chan                                                                               |    2|
|TRUE    |Gmail Hangouts; Reddit.com                                                          |    1|
|TRUE    |Google+                                                                             |    2|
|TRUE    |I used LiveJournal for the majority of my service as well as my deployment to Iraq  |    1|
|TRUE    |light fighter                                                                       |    1|
|TRUE    |Linked In                                                                           |    1|
|TRUE    |LinkedIn, Snapchat                                                                  |    1|
|TRUE    |LiveJournal                                                                         |    1|
|TRUE    |MIL.MIL                                                                             |    1|
|TRUE    |Ravelry Forums                                                                      |    1|
|TRUE    |reddit                                                                              |    4|
|TRUE    |Reddit                                                                              |    5|
|TRUE    |Reddit, 4Chan                                                                       |    1|
|TRUE    |Snao Chat                                                                           |    1|
|TRUE    |snapchat                                                                            |    3|
|TRUE    |Snapchat                                                                            |    1|
|TRUE    |SnapChat                                                                            |    1|
|TRUE    |vetsprevail,patients like me                                                        |    1|
|TRUE    |webmd, mayoclinic,wikipedia, va                                                     |    1|
|TRUE    |www.coping-with-epilepsy.com                                                        |    1|

\newline


| countSocialMediaExclFB|    n|
|----------------------:|----:|
|                      0| 1059|
|                      1|  154|
|                      2|   80|
|                      3|   22|
|                      4|   12|
|                      5|    2|

\newline


|comm_inperson                 |   n|
|:-----------------------------|---:|
|Several times a day           | 202|
|Once a day                    |  74|
|A few times a week            | 135|
|Once a week                   |  80|
|Every few weeks or less often | 209|
|NA                            | 629|

\newline


|indSuicideConsideredEver |indSuicideConsidered12mo |indSuicideAttempt | countSuicideAttempts|   n|
|:------------------------|:------------------------|:-----------------|--------------------:|---:|
|NA                       |NA                       |NA                |                  NaN| 713|
|FALSE                    |FALSE                    |FALSE             |                    0| 350|
|TRUE                     |FALSE                    |FALSE             |                    0| 144|
|TRUE                     |FALSE                    |TRUE              |                    1|  34|
|TRUE                     |TRUE                     |FALSE             |                    0|  29|
|TRUE                     |FALSE                    |TRUE              |                    2|  19|
|TRUE                     |TRUE                     |TRUE              |                    1|  11|
|TRUE                     |FALSE                    |TRUE              |                    3|   9|
|TRUE                     |TRUE                     |TRUE              |                    3|   8|
|TRUE                     |TRUE                     |TRUE              |                    2|   7|
|TRUE                     |FALSE                    |TRUE              |                    4|   2|
|TRUE                     |FALSE                    |TRUE              |                    5|   2|
|TRUE                     |TRUE                     |TRUE              |                    5|   1|
# Research Question 1

Is perceived social support received from Facebook (FMSS) associated with lower rates of 

* Positive screens for psychiatric disorders
  * PC-PTSD
  * PHQ-2
  * AUDIT-C
* Positive screen for suicidality?
  * DSI-SS


## Unadjusted comparisons


|yvariable |indPTSD | mean | sd  | min | max |  n  | freq  |
|:---------|:-------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE   | 29.4 | 6.6 | 14  | 47  | 245 | 47.4% |
|fmss      |TRUE    | 28.4 | 6.8 | 16  | 48  | 272 | 52.6% |

\newline


|yvariable |indPHQ | mean | sd  | min | max |  n  | freq  |
|:---------|:------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE  | 29.5 | 6.4 | 16  | 48  | 436 | 72.3% |
|fmss      |TRUE   | 28.0 | 6.8 | 14  | 44  | 167 | 27.7% |

\newline


|yvariable |indAuditC | mean | sd  | min | max |  n  | freq  |
|:---------|:---------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE     | 29.7 | 6.6 | 14  | 48  | 241 | 49.4% |
|fmss      |TRUE      | 29.1 | 6.4 | 16  | 47  | 247 | 50.6% |

\newline


|yvariable |indDSISS | mean | sd  | min | max |  n  | freq  |
|:---------|:--------|:----:|:---:|:---:|:---:|:---:|:-----:|
|fmss      |FALSE    | 29.5 | 6.6 | 16  | 48  | 469 | 78.3% |
|fmss      |TRUE     | 27.6 | 6.4 | 14  | 44  | 130 | 21.7% |

\newline

![plot of chunk plot2GroupsRQ1](../figures/plot2GroupsRQ1-1.png)


## Adjusted comparisons



Filter subjects with missing covariates.




### PC-PTSD


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     2.092|     0.395|     1.870|   0.062|
|Unadjusted |fmss                                       |     0.978|     0.013|    -1.664|   0.096|
|Adjusted   |(Intercept)                                |     0.743|     0.464|    -0.642|   0.521|
|Adjusted   |fmss                                       |     0.981|     0.015|    -1.307|   0.191|
|Adjusted   |countSocialMediaExclFB                     |     1.027|     0.097|     0.270|   0.787|
|Adjusted   |comm_inpersonOnce a day                    |     1.419|     0.348|     1.006|   0.315|
|Adjusted   |comm_inpersonA few times a week            |     1.321|     0.274|     1.015|   0.310|
|Adjusted   |comm_inpersonOnce a week                   |     1.918|     0.333|     1.956|   0.050|
|Adjusted   |comm_inpersonEvery few weeks or less often |     2.770|     0.251|     4.060|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE               |     2.085|     0.211|     3.484|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.675|     0.175|     2.952|   0.003|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       704.395|     508| -350.803| 705.606| 714.071|  701.606|         507|
|Adjusted   |       704.395|     508| -318.709| 655.418| 693.510|  637.418|         500|


### PHQ-2


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     1.147|     0.416|     0.330|   0.741|
|Unadjusted |fmss                                       |     0.963|     0.014|    -2.672|   0.008|
|Adjusted   |(Intercept)                                |     0.330|     0.489|    -2.268|   0.023|
|Adjusted   |fmss                                       |     0.970|     0.015|    -2.005|   0.045|
|Adjusted   |countSocialMediaExclFB                     |     0.972|     0.103|    -0.278|   0.781|
|Adjusted   |comm_inpersonOnce a day                    |     0.999|     0.410|    -0.003|   0.998|
|Adjusted   |comm_inpersonA few times a week            |     0.985|     0.314|    -0.048|   0.961|
|Adjusted   |comm_inpersonOnce a week                   |     2.073|     0.329|     2.216|   0.027|
|Adjusted   |comm_inpersonEvery few weeks or less often |     2.642|     0.259|     3.752|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE               |     2.969|     0.218|     4.998|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.232|     0.123|     1.699|   0.089|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |        703.22|     595| -347.957| 699.914| 708.694|  695.914|         594|
|Adjusted   |        703.22|     595| -312.064| 642.127| 681.639|  624.127|         587|


### AUDIT-C


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     1.535|     0.421|     1.018|   0.309|
|Unadjusted |fmss                                       |     0.987|     0.014|    -0.962|   0.336|
|Adjusted   |(Intercept)                                |     0.897|     0.472|    -0.231|   0.818|
|Adjusted   |fmss                                       |     0.990|     0.014|    -0.701|   0.484|
|Adjusted   |countSocialMediaExclFB                     |     1.061|     0.095|     0.616|   0.538|
|Adjusted   |comm_inpersonOnce a day                    |     1.268|     0.338|     0.704|   0.482|
|Adjusted   |comm_inpersonA few times a week            |     1.150|     0.263|     0.532|   0.595|
|Adjusted   |comm_inpersonOnce a week                   |     1.828|     0.327|     1.846|   0.065|
|Adjusted   |comm_inpersonEvery few weeks or less often |     1.656|     0.247|     2.041|   0.041|
|Adjusted   |indSuicideConsideredEverTRUE               |     1.481|     0.210|     1.876|   0.061|
|Adjusted   |countSuicideAttempts                       |     0.876|     0.131|    -1.009|   0.313|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       670.834|     483| -334.953| 673.906| 682.270|  669.906|         482|
|Adjusted   |       670.834|     483| -329.692| 677.384| 715.023|  659.384|         475|


### DSI-SS


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     1.025|     0.450|     0.056|   0.956|
|Unadjusted |fmss                                       |     0.955|     0.016|    -2.933|   0.003|
|Adjusted   |(Intercept)                                |     0.250|     0.547|    -2.533|   0.011|
|Adjusted   |fmss                                       |     0.958|     0.017|    -2.544|   0.011|
|Adjusted   |countSocialMediaExclFB                     |     1.056|     0.109|     0.501|   0.616|
|Adjusted   |comm_inpersonOnce a day                    |     0.950|     0.463|    -0.111|   0.911|
|Adjusted   |comm_inpersonA few times a week            |     1.097|     0.333|     0.277|   0.782|
|Adjusted   |comm_inpersonOnce a week                   |     1.432|     0.358|     1.004|   0.315|
|Adjusted   |comm_inpersonEvery few weeks or less often |     1.572|     0.290|     1.557|   0.119|
|Adjusted   |indSuicideConsideredEverTRUE               |     5.764|     0.254|     6.898|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.258|     0.121|     1.893|   0.058|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       622.664|     595| -306.892| 617.784| 626.565|  613.784|         594|
|Adjusted   |       622.664|     595| -262.037| 542.074| 581.586|  524.074|         587|
# Research Question 2

Are certains features of social media use are associated with positive screens for psychiatric disorders or a positive screen for suicidality?

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
  
  
## Association between frequency of Facebook use and active use of Facebook

Correlation (Spearman) between frequency of Facebook use and active use of Facebook is
0.446


## Unadjusted comparisons



![plot of chunk plotRQ2](../figures/plotRQ2-1.png)![plot of chunk plotRQ2](../figures/plotRQ2-2.png)![plot of chunk plotRQ2](../figures/plotRQ2-3.png)![plot of chunk plotRQ2](../figures/plotRQ2-4.png)![plot of chunk plotRQ2](../figures/plotRQ2-5.png)![plot of chunk plotRQ2](../figures/plotRQ2-6.png)![plot of chunk plotRQ2](../figures/plotRQ2-7.png)![plot of chunk plotRQ2](../figures/plotRQ2-8.png)![plot of chunk plotRQ2](../figures/plotRQ2-9.png)


## Adjusted comparisons



Filter subjects with missing covariates.



Relabel factors; replace spaces with underscores.



Define linear function for general hypothesis testing.




### PC-PTSD vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.204|   5| 516|  0.306|
|Adjusted   | 1.215|   5| 509|  0.301|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     0.429|     0.690|    -1.228|   0.220|
|Unadjusted |fb_freqEvery_few_weeks                     |     4.667|     1.406|     1.096|   0.273|
|Unadjusted |fb_freqOnce_a_week                         |     1.167|     1.107|     0.139|   0.889|
|Unadjusted |fb_freqA_few_times_a_week                  |     3.667|     0.770|     1.687|   0.092|
|Unadjusted |fb_freqOnce_a_day                          |     3.417|     0.732|     1.678|   0.093|
|Unadjusted |fb_freqSeveral_times_a_day                 |     2.357|     0.697|     1.230|   0.219|
|Adjusted   |(Intercept)                                |     0.204|     0.732|    -2.170|   0.030|
|Adjusted   |fb_freqEvery_few_weeks                     |     3.570|     1.488|     0.855|   0.392|
|Adjusted   |fb_freqOnce_a_week                         |     0.845|     1.130|    -0.149|   0.881|
|Adjusted   |fb_freqA_few_times_a_week                  |     3.662|     0.791|     1.641|   0.101|
|Adjusted   |fb_freqOnce_a_day                          |     2.870|     0.754|     1.399|   0.162|
|Adjusted   |fb_freqSeveral_times_a_day                 |     2.040|     0.714|     0.998|   0.318|
|Adjusted   |countSocialMediaExclFB                     |     1.031|     0.095|     0.326|   0.744|
|Adjusted   |comm_inpersonOnce a day                    |     1.216|     0.341|     0.572|   0.568|
|Adjusted   |comm_inpersonA few times a week            |     1.210|     0.272|     0.699|   0.485|
|Adjusted   |comm_inpersonOnce a week                   |     1.855|     0.326|     1.895|   0.058|
|Adjusted   |comm_inpersonEvery few weeks or less often |     2.674|     0.249|     3.956|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE               |     2.002|     0.208|     3.333|   0.001|
|Adjusted   |countSuicideAttempts                       |     1.706|     0.179|     2.988|   0.003|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       723.025|     521| -358.357| 728.714| 754.260|  716.714|         516|
|Adjusted   |       723.025|     521| -326.258| 678.516| 733.866|  652.516|         509|


### PC-PTSD vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.859|   4| 519|  0.116|
|Adjusted   | 1.592|   4| 512|  0.175|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     1.407|     0.252|     1.358|   0.175|
|Unadjusted |comm_facebookOnce_a_week                   |     0.933|     0.416|    -0.168|   0.867|
|Unadjusted |comm_facebookA_few_times_a_week            |     0.963|     0.319|    -0.118|   0.906|
|Unadjusted |comm_facebookOnce_a_day                    |     0.903|     0.334|    -0.307|   0.759|
|Unadjusted |comm_facebookSeveral_times_a_day           |     0.587|     0.284|    -1.872|   0.061|
|Adjusted   |(Intercept)                                |     0.568|     0.332|    -1.702|   0.089|
|Adjusted   |comm_facebookOnce_a_week                   |     0.944|     0.446|    -0.128|   0.898|
|Adjusted   |comm_facebookA_few_times_a_week            |     0.994|     0.340|    -0.019|   0.985|
|Adjusted   |comm_facebookOnce_a_day                    |     1.067|     0.358|     0.182|   0.855|
|Adjusted   |comm_facebookSeveral_times_a_day           |     0.621|     0.310|    -1.533|   0.125|
|Adjusted   |countSocialMediaExclFB                     |     1.060|     0.096|     0.608|   0.543|
|Adjusted   |comm_inpersonOnce a day                    |     1.142|     0.345|     0.385|   0.700|
|Adjusted   |comm_inpersonA few times a week            |     1.146|     0.274|     0.499|   0.617|
|Adjusted   |comm_inpersonOnce a week                   |     1.645|     0.329|     1.511|   0.131|
|Adjusted   |comm_inpersonEvery few weeks or less often |     2.397|     0.253|     3.460|   0.001|
|Adjusted   |indSuicideConsideredEverTRUE               |     1.983|     0.209|     3.276|   0.001|
|Adjusted   |countSuicideAttempts                       |     1.792|     0.180|     3.246|   0.001|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       725.655|     523| -359.081| 728.163| 749.470|  718.163|         519|
|Adjusted   |       725.655|     523| -327.005| 678.009| 729.147|  654.009|         512|


### PHQ-2 vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.497|   5| 605|  0.778|
|Adjusted   | 0.415|   5| 598|  0.838|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     0.111|     1.054|    -2.084|   0.037|
|Unadjusted |fb_freqEvery_few_weeks                     |     0.000|   441.373|    -0.028|   0.978|
|Unadjusted |fb_freqOnce_a_week                         |     4.500|     1.364|     1.103|   0.270|
|Unadjusted |fb_freqA_few_times_a_week                  |     3.724|     1.109|     1.186|   0.236|
|Unadjusted |fb_freqOnce_a_day                          |     4.327|     1.082|     1.354|   0.176|
|Unadjusted |fb_freqSeveral_times_a_day                 |     3.339|     1.059|     1.138|   0.255|
|Adjusted   |(Intercept)                                |     0.045|     1.097|    -2.827|   0.005|
|Adjusted   |fb_freqEvery_few_weeks                     |     0.000|   652.539|    -0.021|   0.983|
|Adjusted   |fb_freqOnce_a_week                         |     3.416|     1.391|     0.883|   0.377|
|Adjusted   |fb_freqA_few_times_a_week                  |     3.811|     1.135|     1.179|   0.238|
|Adjusted   |fb_freqOnce_a_day                          |     3.841|     1.106|     1.217|   0.224|
|Adjusted   |fb_freqSeveral_times_a_day                 |     3.042|     1.080|     1.030|   0.303|
|Adjusted   |countSocialMediaExclFB                     |     0.914|     0.103|    -0.879|   0.379|
|Adjusted   |comm_inpersonOnce a day                    |     1.106|     0.395|     0.255|   0.798|
|Adjusted   |comm_inpersonA few times a week            |     0.912|     0.318|    -0.291|   0.771|
|Adjusted   |comm_inpersonOnce a week                   |     2.296|     0.324|     2.570|   0.010|
|Adjusted   |comm_inpersonEvery few weeks or less often |     2.762|     0.255|     3.983|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE               |     2.992|     0.215|     5.087|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.212|     0.125|     1.541|   0.123|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       718.694|     610| -356.562| 725.124| 751.614|  713.124|         605|
|Adjusted   |       718.694|     610| -317.866| 661.732| 719.128|  635.732|         598|


### PHQ-2 vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.601|   4| 608|  0.662|
|Adjusted   | 0.477|   4| 601|  0.753|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     0.532|     0.248|    -2.550|   0.011|
|Unadjusted |comm_facebookOnce_a_week                   |     0.843|     0.416|    -0.412|   0.681|
|Unadjusted |comm_facebookA_few_times_a_week            |     0.661|     0.322|    -1.286|   0.198|
|Unadjusted |comm_facebookOnce_a_day                    |     0.702|     0.332|    -1.066|   0.287|
|Unadjusted |comm_facebookSeveral_times_a_day           |     0.673|     0.283|    -1.397|   0.163|
|Adjusted   |(Intercept)                                |     0.184|     0.353|    -4.797|   0.000|
|Adjusted   |comm_facebookOnce_a_week                   |     0.886|     0.453|    -0.267|   0.790|
|Adjusted   |comm_facebookA_few_times_a_week            |     0.639|     0.349|    -1.283|   0.200|
|Adjusted   |comm_facebookOnce_a_day                    |     0.804|     0.364|    -0.601|   0.548|
|Adjusted   |comm_facebookSeveral_times_a_day           |     0.733|     0.315|    -0.987|   0.324|
|Adjusted   |countSocialMediaExclFB                     |     0.929|     0.102|    -0.720|   0.471|
|Adjusted   |comm_inpersonOnce a day                    |     1.033|     0.396|     0.081|   0.936|
|Adjusted   |comm_inpersonA few times a week            |     0.966|     0.313|    -0.112|   0.911|
|Adjusted   |comm_inpersonOnce a week                   |     2.184|     0.326|     2.396|   0.017|
|Adjusted   |comm_inpersonEvery few weeks or less often |     2.581|     0.261|     3.639|   0.000|
|Adjusted   |indSuicideConsideredEverTRUE               |     3.113|     0.216|     5.258|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.230|     0.124|     1.668|   0.095|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       723.841|     612| -360.750| 731.499| 753.591|  721.499|         608|
|Adjusted   |       723.841|     612| -321.877| 667.754| 720.775|  643.754|         601|


### AUDIT-C vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.026|   5| 490|  0.402|
|Adjusted   | 1.082|   5| 483|  0.369|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     0.200|     1.095|    -1.469|   0.142|
|Unadjusted |fb_freqEvery_few_weeks                     |     1.667|     1.592|     0.321|   0.748|
|Unadjusted |fb_freqOnce_a_week                         |     2.500|     1.643|     0.558|   0.577|
|Unadjusted |fb_freqA_few_times_a_week                  |     3.684|     1.151|     1.133|   0.257|
|Unadjusted |fb_freqOnce_a_day                          |     5.645|     1.123|     1.541|   0.123|
|Unadjusted |fb_freqSeveral_times_a_day                 |     5.608|     1.100|     1.567|   0.117|
|Adjusted   |(Intercept)                                |     0.117|     1.123|    -1.914|   0.056|
|Adjusted   |fb_freqEvery_few_weeks                     |     1.777|     1.608|     0.358|   0.721|
|Adjusted   |fb_freqOnce_a_week                         |     1.954|     1.659|     0.404|   0.686|
|Adjusted   |fb_freqA_few_times_a_week                  |     4.133|     1.163|     1.221|   0.222|
|Adjusted   |fb_freqOnce_a_day                          |     6.018|     1.135|     1.582|   0.114|
|Adjusted   |fb_freqSeveral_times_a_day                 |     6.078|     1.112|     1.623|   0.105|
|Adjusted   |countSocialMediaExclFB                     |     1.054|     0.094|     0.555|   0.579|
|Adjusted   |comm_inpersonOnce a day                    |     1.259|     0.333|     0.690|   0.490|
|Adjusted   |comm_inpersonA few times a week            |     1.194|     0.263|     0.675|   0.500|
|Adjusted   |comm_inpersonOnce a week                   |     1.697|     0.319|     1.655|   0.098|
|Adjusted   |comm_inpersonEvery few weeks or less often |     1.748|     0.246|     2.267|   0.023|
|Adjusted   |indSuicideConsideredEverTRUE               |     1.553|     0.208|     2.114|   0.035|
|Adjusted   |countSuicideAttempts                       |     0.871|     0.133|    -1.040|   0.298|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       687.207|     495| -340.520| 693.040| 718.280|  681.040|         490|
|Adjusted   |       687.207|     495| -334.743| 695.486| 750.171|  669.486|         483|


### AUDIT-C vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 1.234|   4| 493|  0.296|
|Adjusted   | 1.329|   4| 486|  0.258|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     1.545|     0.274|     1.591|   0.112|
|Unadjusted |comm_facebookOnce_a_week                   |     0.462|     0.435|    -1.775|   0.076|
|Unadjusted |comm_facebookA_few_times_a_week            |     0.576|     0.337|    -1.635|   0.102|
|Unadjusted |comm_facebookOnce_a_day                    |     0.584|     0.355|    -1.514|   0.130|
|Unadjusted |comm_facebookSeveral_times_a_day           |     0.747|     0.305|    -0.959|   0.337|
|Adjusted   |(Intercept)                                |     0.959|     0.338|    -0.123|   0.902|
|Adjusted   |comm_facebookOnce_a_week                   |     0.487|     0.441|    -1.633|   0.102|
|Adjusted   |comm_facebookA_few_times_a_week            |     0.556|     0.346|    -1.697|   0.090|
|Adjusted   |comm_facebookOnce_a_day                    |     0.597|     0.366|    -1.408|   0.159|
|Adjusted   |comm_facebookSeveral_times_a_day           |     0.792|     0.316|    -0.739|   0.460|
|Adjusted   |countSocialMediaExclFB                     |     1.036|     0.095|     0.370|   0.711|
|Adjusted   |comm_inpersonOnce a day                    |     1.312|     0.336|     0.808|   0.419|
|Adjusted   |comm_inpersonA few times a week            |     1.178|     0.265|     0.619|   0.536|
|Adjusted   |comm_inpersonOnce a week                   |     1.722|     0.323|     1.681|   0.093|
|Adjusted   |comm_inpersonEvery few weeks or less often |     1.673|     0.251|     2.052|   0.040|
|Adjusted   |indSuicideConsideredEverTRUE               |     1.604|     0.210|     2.245|   0.025|
|Adjusted   |countSuicideAttempts                       |     0.857|     0.132|    -1.170|   0.242|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       690.085|     497| -342.542| 695.083| 716.136|  685.083|         493|
|Adjusted   |       690.085|     497| -336.800| 697.601| 748.128|  673.601|         486|


### DSI-SS vs Frequency of Facebook use


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.646|   5| 605|  0.665|
|Adjusted   | 0.784|   5| 598|  0.562|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     0.250|     0.791|    -1.754|   0.080|
|Unadjusted |fb_freqEvery_few_weeks                     |     4.000|     1.275|     1.087|   0.277|
|Unadjusted |fb_freqOnce_a_week                         |     0.800|     1.351|    -0.165|   0.869|
|Unadjusted |fb_freqA_few_times_a_week                  |     0.667|     0.905|    -0.448|   0.654|
|Unadjusted |fb_freqOnce_a_day                          |     1.220|     0.835|     0.238|   0.812|
|Unadjusted |fb_freqSeveral_times_a_day                 |     1.130|     0.798|     0.154|   0.878|
|Adjusted   |(Intercept)                                |     0.106|     0.877|    -2.555|   0.011|
|Adjusted   |fb_freqEvery_few_weeks                     |     5.075|     1.390|     1.169|   0.242|
|Adjusted   |fb_freqOnce_a_week                         |     0.484|     1.420|    -0.512|   0.609|
|Adjusted   |fb_freqA_few_times_a_week                  |     0.504|     0.965|    -0.710|   0.478|
|Adjusted   |fb_freqOnce_a_day                          |     0.781|     0.893|    -0.277|   0.782|
|Adjusted   |fb_freqSeveral_times_a_day                 |     0.751|     0.852|    -0.336|   0.737|
|Adjusted   |countSocialMediaExclFB                     |     0.999|     0.107|    -0.012|   0.990|
|Adjusted   |comm_inpersonOnce a day                    |     0.911|     0.444|    -0.209|   0.834|
|Adjusted   |comm_inpersonA few times a week            |     1.066|     0.328|     0.196|   0.844|
|Adjusted   |comm_inpersonOnce a week                   |     1.306|     0.353|     0.756|   0.450|
|Adjusted   |comm_inpersonEvery few weeks or less often |     1.505|     0.283|     1.444|   0.149|
|Adjusted   |indSuicideConsideredEverTRUE               |     5.840|     0.249|     7.091|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.259|     0.122|     1.878|   0.060|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       640.268|     610| -318.479| 648.959| 675.449|  636.959|         605|
|Adjusted   |       640.268|     610| -272.314| 570.627| 628.024|  544.627|         598|


### DSI-SS vs Active use of Facebook


|model      |     F| df1| df2| pValue|
|:----------|-----:|---:|---:|------:|
|Unadjusted | 0.714|   4| 608|  0.583|
|Adjusted   | 0.986|   4| 601|  0.414|

\newline


|model      |term                                       | oddsratio| std.error| statistic| p.value|
|:----------|:------------------------------------------|---------:|---------:|---------:|-------:|
|Unadjusted |(Intercept)                                |     0.385|     0.263|    -3.632|   0.000|
|Unadjusted |comm_facebookOnce_a_week                   |     0.709|     0.459|    -0.749|   0.454|
|Unadjusted |comm_facebookA_few_times_a_week            |     0.830|     0.336|    -0.555|   0.579|
|Unadjusted |comm_facebookOnce_a_day                    |     0.634|     0.363|    -1.256|   0.209|
|Unadjusted |comm_facebookSeveral_times_a_day           |     0.641|     0.304|    -1.463|   0.143|
|Adjusted   |(Intercept)                                |     0.136|     0.390|    -5.115|   0.000|
|Adjusted   |comm_facebookOnce_a_week                   |     0.671|     0.512|    -0.779|   0.436|
|Adjusted   |comm_facebookA_few_times_a_week            |     0.656|     0.377|    -1.118|   0.263|
|Adjusted   |comm_facebookOnce_a_day                    |     0.557|     0.406|    -1.444|   0.149|
|Adjusted   |comm_facebookSeveral_times_a_day           |     0.512|     0.348|    -1.923|   0.054|
|Adjusted   |countSocialMediaExclFB                     |     1.009|     0.107|     0.084|   0.933|
|Adjusted   |comm_inpersonOnce a day                    |     0.922|     0.440|    -0.184|   0.854|
|Adjusted   |comm_inpersonA few times a week            |     0.965|     0.329|    -0.108|   0.914|
|Adjusted   |comm_inpersonOnce a week                   |     1.201|     0.357|     0.513|   0.608|
|Adjusted   |comm_inpersonEvery few weeks or less often |     1.375|     0.288|     1.103|   0.270|
|Adjusted   |indSuicideConsideredEverTRUE               |     5.925|     0.250|     7.103|   0.000|
|Adjusted   |countSuicideAttempts                       |     1.258|     0.122|     1.886|   0.059|

\newline


|model      | null.deviance| df.null|   logLik|     AIC|     BIC| deviance| df.residual|
|:----------|-------------:|-------:|--------:|-------:|-------:|--------:|-----------:|
|Unadjusted |       641.248|     612| -319.228| 648.456| 670.547|  638.456|         608|
|Adjusted   |       641.248|     612| -273.282| 570.564| 623.584|  546.564|         601|
