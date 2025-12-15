# 🧪 Project Questions & Regulatory Focus

This project addresses **key regulatory and scientific questions** related to **reference scaling** and **narrow therapeutic index drugs (NTIDs)** in bioequivalence (BE) studies, using replicated crossover designs and real clinical datasets from *PharmaDatasets.jl*.

---

## 🔬 Core Project Questions

### 1️⃣ When is Standard Bioequivalence Insufficient?

- Under what conditions does the traditional **80–125% TOST framework** fail?
- How does **within-subject variability of the reference product (CVᵣ)** affect BE conclusions?
- When should regulators consider **alternative BE approaches**?

📌 **Addressed by**  
Task 1 (variability assessment) and Task 2 (standard ABE analysis)

---

### 2️⃣ What Defines a Highly Variable Drug (HVD)?

- What is the regulatory definition of a **highly variable drug**?
- Why is **CVᵣ ≥ 30%** used as the decision threshold?
- Should reference scaling always be applied once a drug is classified as HVD?

📌 **Addressed by**  
Task 1 (CVᵣ estimation, HVD classification, RS eligibility)

---

### 3️⃣ How Does FDA Reference-Scaled Average Bioequivalence (RSABE) Work?

- How does RSABE adjust BE criteria based on reference variability?
- What is the role of **Howe’s approximation** in FDA RSABE?
- Why does RSABE primarily target **Cmax**, not AUC?

📌 **Addressed by**  
Task 3 (FDA HVD / RSABE analysis)

---

### 4️⃣ Why Are NTID Drugs Treated Differently?

- Why do NTID drugs require **tighter BE limits**?
- What clinical risks motivate stricter regulatory control?
- How do **EMA NTI criteria (90–111%)** differ from FDA approaches?

📌 **Addressed by**  
Task 4 (EMA Narrow Therapeutic Index criteria)

---

### 5️⃣ Can RSABE Be Applied to NTID Drugs?

- Is reference scaling acceptable for NTIDs?
- What **additional constraints** does FDA impose for NTID RSABE?
- How do **dual criteria** (RSABE statistic + variability ratio cap) protect patient safety?

📌 **Addressed by**  
Task 5 (FDA NTID RSABE analysis)

---

## 📊 Dataset-Specific Questions

For each dataset (**PJ2017_4_3**, **PJ2017_4_4**, **CL2009_9_4_1**), the project evaluates:

- Does **standard ABE** succeed or fail?
- Is the drug **highly variable**?
- Is **reference scaling justified**?
- Does the product pass under **FDA RSABE**?
- Does it meet **EMA and FDA NTID requirements**?

These comparisons illustrate how **regulatory conclusions depend on both variability and therapeutic context**, not solely on point estimates.

---

## 🧠 Broader Regulatory & Scientific Questions

- How do **FDA and EMA philosophies differ** in bioequivalence evaluation?
- Why does **passing RSABE not guarantee approval** for NTID drugs?
- How should BE results be interpreted when **statistical equivalence may not imply clinical equivalence**?

---

## 🎯 Learning Outcomes

By answering these questions, this project demonstrates:

- Correct application of **replicated crossover bioequivalence methods**
- Regulatory decision-making for **highly variable and NTID drugs**
- Practical use of **Pumas.jl** and **Bioequivalence.jl**
- Integration of **statistics, pharmacokinetics, and regulatory science**

---
