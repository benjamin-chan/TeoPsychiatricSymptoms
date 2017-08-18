---
title: "Psychiatric Symptoms of Veterans Surveyed Through Facebook Ads"
date: "2017-08-18 10:24:59"
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

### Psychiatric symptoms

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

![plot of chunk plot2Groups](../figures/plot2Groups-1.png)


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
