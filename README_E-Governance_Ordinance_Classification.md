# Classifying Ordinances & Computing an E‑Governance Index — README

This notebook builds an **E‑Governance Index** for Philippine cities by classifying local ordinances (topic/content) and aggregating them into a composite score that complements CMCI, enabling **city‑to‑city (C2C) learning**.

---

## 1) What this notebook does
- **Ingests ordinance texts/metadata** (city, date, category).
- **Cleans & preprocesses** text (normalize, tokenize, optional lemmatize).
- **Represents** documents (e.g., TF‑IDF or transformer embeddings).
- **Classifies** ordinances into e‑governance‑relevant themes (supervised or topic modeling).
- Computes **per‑city indicators** (coverage, recency, diversity, responsiveness).
- Aggregates into an **E‑Governance Index** with transparent weights.
- Produces **tables & charts** for comparison and C2C insights.

---

## 2) Inputs & folder structure

Expected files (examples; adjust names in the notebook):
```
data/
  ordinances.csv          # id, city, date, title, body, tags(optional)
  city_metadata.csv       # city_id, region, population (optional)
models/                   # saved vectorizers / classifiers (optional)
outputs/                  # generated reports and figures
```

Minimum required columns in `ordinances.csv`:
- `id` — unique id
- `city` — city name or code
- `date` — ISO 8601 preferred (YYYY-MM-DD)
- `body` — full text of ordinance (can also use `title` when body is short)

---

## 3) Environment setup

```bash
pip install pandas numpy scikit-learn matplotlib
# For NLP:
pip install nltk
# (optional) for transformer embeddings / zero-shot:
pip install sentence-transformers torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118  # or cpu wheels
```

If using external APIs (OpenAI, etc.) for embeddings or labeling, set keys:
```bash
export OPENAI_API_KEY=...  # optional
```

---

## 4) Method overview

1. **Text prep** — lowercase, strip punctuation, stopwords, optional lemmatization.
2. **Vectorization** — TF‑IDF (baseline) or embeddings (semantic).
3. **Classification**  
   - *Supervised*: Logistic Regression/Linear SVM with cross‑validation, or
   - *Unsupervised topics*: LDA/NMF; map topics → governance themes.
4. **Indicators** (examples; adapt as needed)  
   - *Coverage*: proportion of governance themes present per city.  
   - *Recency*: weighted count by freshness of ordinances.  
   - *Diversity*: entropy or unique-theme count.  
   - *Responsiveness*: volume normalized by population or time.  
5. **Index aggregation** — normalize indicators (0–1), apply weights, sum to composite.
6. **Validation** — sensitivity analysis (weights), holdout evaluation, expert review.

---

## 5) How to run

1. Open `Copy_of_Classifying_Ordinance_and_Computing_E_Governance_Index_1.ipynb`  
   *(Or the commented version: `...__COMMENTED.ipynb`)*
2. Update data paths in the “Load data” cell.
3. Choose **representation** (TF‑IDF vs embeddings) and **classifier** or **topic model**.
4. Execute cells top‑to‑bottom.
5. Inspect outputs under `outputs/`:
   - `city_indicators.csv`, `ego_index.csv`
   - Charts: bar charts, heatmaps comparing cities/themes

---

## 6) Configuration knobs

- **Theme schema**: edit the label set or topic → theme mapping.
- **Weights**: adjust indicator weights for the composite index; run sensitivity checks.
- **Time windows**: compute recency using rolling windows (e.g., last 2–3 years).
- **Normalization**: per‑capita or per‑ordinance scaling to compare fairly across cities.
- **Zero‑shot augmentation**: optionally use LLMs to score governance alignment for low‑data themes.

---

## 7) Quality checks & troubleshooting

- **Class imbalance**: use stratified splits or class weights.
- **Noisy OCR**: pre‑clean with regex rules; consider spell‑correction.
- **Short texts**: include titles; use embeddings to capture semantics.
- **Date gaps**: verify parsing (`pd.to_datetime(errors="coerce")`) and handle missing.
- **Model drift**: re‑fit vectorizers/classifiers when adding new cities/years.

---

## 8) Related files

- Commented notebook: `Copy_of_Classifying_Ordinance_and_Computing_E_Governance_Index_1__COMMENTED.ipynb`
- Exports (examples): `outputs/city_indicators.csv`, `outputs/ego_index.csv`, figures in `outputs/figures/`

---

## 9) Governance & reproducibility

- Keep a **data dictionary** for each indicator and weight.  
- Save **model artifacts** (`.pkl`) with version tags.  
- Log run configs (random seeds, date ranges) for reproducibility.

---

## 10) License & authorship

Provide your preferred license text. Include contact or owner (e.g., *Urban Competitiveness Research — Remote Lender*).
