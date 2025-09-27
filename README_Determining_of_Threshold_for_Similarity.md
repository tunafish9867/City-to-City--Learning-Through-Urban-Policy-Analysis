# Determining of Threshold for Similarity — README

This notebook helps you **determine an optimal similarity threshold** for text (or embedding) comparisons so you can decide when two records should be considered a “match.” It’s useful for deduplication, record linkage, or clustering pipelines.

---

## 1) What this notebook does
- Loads labeled or pseudo‑labeled pairs (match vs non‑match) **or** unlabeled similarity scores.
- Computes similarity (e.g., cosine on embeddings) **or** ingests precomputed scores.
- Explores candidate thresholds and evaluates tradeoffs (precision/recall/F1, accuracy, ROC/PR where applicable).
- Recommends a threshold based on your optimization goal (maximize F1 by default).

---

## 2) Inputs & assumptions
You can work in two modes:

**A. With labels**  
A CSV/Parquet with columns like:
- `score` — similarity score in [0, 1] (or distance later inverted to similarity)
- `label` — 1 for match, 0 for non‑match

**B. Without labels**  
A CSV/Parquet with `score` only; you’ll rely on distributional heuristics (e.g., knee/elbow).

> Tip: If you start with raw text pairs, the notebook can compute embeddings and similarity (requires an embeddings model).

---

## 3) Environment setup

Install dependencies (adjust to your stack):
```bash
pip install pandas numpy scikit-learn matplotlib
# (optional) for embeddings or NLP:
pip install sentence-transformers
```

If you plan to use OpenAI/other LLMs for embeddings:
```bash
export OPENAI_API_KEY=...  # or use a .env file
```

---

## 4) How to run

1. Open the notebook: `Determining_of_Threshold_for_Similarity.ipynb`  
   *(Or the commented version: `Determining_of_Threshold_for_Similarity__COMMENTED.ipynb`)*
2. Set **paths** to your data file(s).
3. Choose mode: labeled or unlabeled.
4. Execute cells top‑to‑bottom.
5. Review:
   - Metrics table by candidate thresholds
   - Curves (PR/ROC) if labels exist
   - Suggested threshold and rationale

---

## 5) Key cells & outputs

- **Data load & prep**: Reads your file, coerces types, sanity checks ranges.
- **Scoring (optional)**: If you provide text, computes embeddings and cosine similarity.
- **Threshold sweep**: Iterates over candidate thresholds (e.g., 0.1 → 0.9).
- **Metrics**: Precision, recall, F1, accuracy; optionally ROC‑AUC, PR‑AUC.
- **Visuals**: Score distribution histograms; PR/ROC curves (labeled mode).
- **Recommendation**: Prints optimal threshold under your criterion (default = F1).

Artifacts saved (configurable):
- `threshold_report.csv` — metrics per threshold
- `score_histogram.png`, `pr_curve.png`, `roc_curve.png`

---

## 6) Customization

- **Objective**: Change the target metric (`F1`, `precision@k`, balanced accuracy).
- **Class weights**: If your positives are rare, adjust class weights when training auxiliary models.
- **Multiple segments**: Compute thresholds per segment (e.g., doc type) if distributions differ.
- **Guardrails**: Set a minimum precision or recall and pick the best threshold that satisfies it.

---

## 7) Troubleshooting

- **All scores look high/low**: Confirm you’re using *similarity* not *distance* (or invert distance).
- **Unstable threshold**: Ensure enough labeled pairs; stratify or bootstrap.
- **Overfitting to one split**: Use cross‑validation or separate validation files.
- **API limits (embeddings)**: Batch requests and cache intermediate vectors.

---

## 8) Related files

- Commented notebook: `Determining_of_Threshold_for_Similarity__COMMENTED.ipynb`
- (Optional) Exports: `threshold_report.csv`, plots under `./figures/`

---

## 9) License & authorship

Provide your preferred license text. Include contact or owner (e.g., *Remote Lender / Research Team*).

