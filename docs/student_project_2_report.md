# Student Project 2 — Visualizations & Summary

- Generated: **2025-12-14T22:53:59.575**
- Outputs folder: `figures_project2/`

## What’s included
- **Figure A (CVᵣ + thresholds):** supports RSABE eligibility discussion
- **Figure B (Forest plot 90% CI):** pass/fail visualization for Standard ABE
- **Figure C (Paired subject plot):** within-subject agreement and crossover intuition


---

## Dataset: PJ2017_4_3
- Path: `bioequivalence/RTTR_TRRT/PJ2017_4_3`
- Rows: **68**; Subjects: **17**
- Endpoints available: **[:AUC, :Cmax]**

### Standard ABE summary — AUC
- GMR (T/R %): **103.6**
- 90% CI (%): **[99.31, 108.2]**
- Conclusion (80–125%): **Pass**
- CVᵣ (%): **8.02**
- RSABE eligibility (rule-of-thumb): **Not eligible**

### Standard ABE summary — Cmax
- GMR (T/R %): **91.23**
- 90% CI (%): **[83.18, 100.1]**
- Conclusion (80–125%): **Pass**
- CVᵣ (%): **21.17**
- RSABE eligibility (rule-of-thumb): **Not eligible**

### Figures
![](figures_project2/PJ2017_4_3_cvr_thresholds.png)
![](figures_project2/PJ2017_4_3_forest_ci.png)
![](figures_project2/PJ2017_4_3_paired_AUC.png)
![](figures_project2/PJ2017_4_3_paired_Cmax.png)

### Interpretation (what to say in your write-up)
- The **forest plot** is the clearest evidence for BE pass/fail under **Standard ABE** (CI within 80–125%).
- The **CVᵣ plot** justifies whether **reference scaling** could be considered (typically when CVᵣ ≥ 30%).
- The **paired subject plot** supports the crossover logic: points near the identity line imply strong within-subject agreement.

---

## Dataset: PJ2017_4_4
- Path: `bioequivalence/RTRT_TRTR/PJ2017_4_4`
- Rows: **216**; Subjects: **54**
- Endpoints available: **[:AUC, :Cmax]**

### Standard ABE summary — AUC
- GMR (T/R %): **110.6**
- 90% CI (%): **[102.9, 118.9]**
- Conclusion (80–125%): **Pass**
- CVᵣ (%): **35.4**
- RSABE eligibility (rule-of-thumb): **Eligible (HVD)**

### Standard ABE summary — Cmax
- GMR (T/R %): **151.0**
- 90% CI (%): **[132.2, 172.4]**
- Conclusion (80–125%): **Fail**
- CVᵣ (%): **60.26**
- RSABE eligibility (rule-of-thumb): **Eligible (HVD)**

### Figures
![](figures_project2/PJ2017_4_4_cvr_thresholds.png)
![](figures_project2/PJ2017_4_4_forest_ci.png)
![](figures_project2/PJ2017_4_4_paired_AUC.png)
![](figures_project2/PJ2017_4_4_paired_Cmax.png)

### Interpretation (what to say in your write-up)
- The **forest plot** is the clearest evidence for BE pass/fail under **Standard ABE** (CI within 80–125%).
- The **CVᵣ plot** justifies whether **reference scaling** could be considered (typically when CVᵣ ≥ 30%).
- The **paired subject plot** supports the crossover logic: points near the identity line imply strong within-subject agreement.

---

## Dataset: CL2009_9_4_1
- Path: `bioequivalence/RTTR_TRRT/CL2009_9_4_1`
- Rows: **40**; Subjects: **10**
- Endpoints available: **[:AUC]**

### Standard ABE summary — AUC
- GMR (T/R %): **116.7**
- 90% CI (%): **[98.19, 138.8]**
- Conclusion (80–125%): **Fail**
- CVᵣ (%): **39.62**
- RSABE eligibility (rule-of-thumb): **Eligible (HVD)**

### Figures
![](figures_project2/CL2009_9_4_1_cvr_thresholds.png)
![](figures_project2/CL2009_9_4_1_forest_ci.png)
![](figures_project2/CL2009_9_4_1_paired_AUC.png)

### Interpretation (what to say in your write-up)
- The **forest plot** is the clearest evidence for BE pass/fail under **Standard ABE** (CI within 80–125%).
- The **CVᵣ plot** justifies whether **reference scaling** could be considered (typically when CVᵣ ≥ 30%).
- The **paired subject plot** supports the crossover logic: points near the identity line imply strong within-subject agreement.

---

## Captions you can reuse
**CVᵣ plot:** Reference within-subject variability (CVᵣ) by endpoint with regulatory thresholds (30% HVD; 50% cap).
**Forest plot:** 90% confidence intervals for Test/Reference ratios with 80–125% BE limits.
**Paired plot:** Subject-level Test vs Reference values (identity line indicates perfect within-subject agreement).
