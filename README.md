# 🌆 City-to-City Learning Through Urban Policy Analysis

This repository contains the code, data, models, and outputs from the project **“City-to-City (C2C) Learning Through Urban Policy Analysis – A Text Mining Approach.”**
The project applies **text mining, structural topic modeling (STM), and similarity-based classification** to analyze city ordinances across Philippine municipalities, with the goal of developing an **E-Governance Index** that complements the CMCI framework and supports **city-to-city (C2C) learning**.

👉 Explore the interactive results here:
[**City Ordinances Shiny App**](https://city-ordinances.shinyapps.io/city-ordinances/)

---

## 📂 Repository Structure

* **Classifying_Ordinance_and_Computing_E_Governance_Index.ipynb**
  Python notebook for **text mining and classification** of ordinances into e-governance components.
  *(Part of Text Mining: Developing the E-Governance Index)*

* **Determining_of_Threshold_for_Similarity.ipynb**
  Python notebook for computing the **optimal similarity threshold** for classifying ordinances.
  *(Part of Text Mining: Developing the E-Governance Index)*

* **Most Representative Documents per Topic.xlsx**
  Output file containing the **top ordinances for each STM topic**.
  *(Part of Text Mining: Structural Topic Modeling – STM)*

* **STM Models Created.R**
  R script generating the **STM models** used for topic extraction and analysis.
  *(Part of Text Mining: Structural Topic Modeling – STM)*

* **Shiny Dashboard from STM results.R**
  R script powering the **Shiny dashboard** that visualizes STM outputs and governance relationships.

* **Data_Ordinances_EGOVIndex_CMCI Score.xlsx**
  Dataset combining ordinance classifications, e-governance index scores, and CMCI results.

---

## 🧪 Methods

1. **Text Mining – E-Governance Index Development**

   * Preprocessed ordinances and computed TF-IDF scores.
   * Classified ordinances into e-governance categories using **Word2Vec similarity**.
   * Determined objective **similarity thresholds** to improve classification reliability.
   * Computed an **E-Governance Index**, mapped to UN EGDI dimensions.

2. **Structural Topic Modeling (STM)**

   * Applied STM to uncover ordinance themes.
   * Related topic prevalence to **CMCI scores, the E-Governance Index, and city origin**.
   * Identified **most representative ordinances** per topic.

3. **Visualization – Shiny Dashboard**

   * Developed an interactive dashboard for exploring ordinance topics, similarity classifications, and city competitiveness indicators.

---

## 🚀 Quick Start

This project runs in two environments:

* **Python (Jupyter Notebooks)** for text mining, similarity thresholding, and E-Governance Index computation.
* **R (RStudio)** for Structural Topic Modeling (STM) and Shiny dashboard visualization.

Use the included `.xlsx` files (e.g., `Data_Ordinances_EGOVIndex_CMCI Score.xlsx`) as inputs — no need to upload your own.

---

### 1️⃣ Python Environment (Jupyter)

**Install dependencies**:

```bash
pip install pandas numpy scikit-learn matplotlib nltk openpyxl
# optional: for embeddings / semantic similarity
pip install sentence-transformers
```

**Run notebooks in order**:

1. `Classifying_Ordinance_and_Computing_E_Governance_Index.ipynb`
   → Preprocess ordinances, classify into e-governance categories, and compute the index.

2. `Determining_of_Threshold_for_Similarity.ipynb`
   → Determine objective similarity thresholds for ordinance classification.

**Outputs**:

* Processed classification files (`.csv`, `.xlsx`)
* Threshold metrics and plots (`.png`)

---

### 2️⃣ R Environment (RStudio)

**Install required R packages**:

```r
install.packages(c("stm", "tidyverse", "ggplot2", "shiny", "readxl"))
```

**Run scripts in order**:

1. `STM Models Created.R`
   → Generates STM topic models from ordinance texts.

2. `Shiny Dashboard from STM results.R`
   → Launches the Shiny dashboard using the STM outputs.

**Outputs**:

* Topic models (`.RData`)
* Representative ordinance lists (`Most Representative Documents per Topic.xlsx`)
* Interactive dashboard (local or deployed to shinyapps.io)

---

### 3️⃣ Visualization

Explore results interactively via the Shiny app:
👉 [City Ordinances Shiny App](https://city-ordinances.shinyapps.io/city-ordinances/)

---

## 📊 Key Outputs

* **E-Governance Index** for 22 Philippine cities, aligned with UN EGDI components.
* **STM topic models** linking ordinance themes to urban competitiveness.
* **Representative ordinances** for each topic, aiding interpretability.
* **Interactive Shiny app** for policy exploration and benchmarking.

---

## 🌍 Impact

This project demonstrates how **text mining of ordinances** can:

* Enhance **city-to-city learning (C2C)**,
* Support **data-driven governance**, and
* Contribute to achieving **SDG 16: Peace, Justice, and Strong Institutions**.

