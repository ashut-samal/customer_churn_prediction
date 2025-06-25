# Customer Churn Prediction Project

## Project Overview
This project analyzes the [**Telco Customer Churn**](https://www.kaggle.com/datasets/blastchar/telco-customer-churn/data) dataset and predicts if a customer will churn or not. It involves:
- Creating database schema and analyzing data using **MySQL**.
- Visualizing key insights using **Power BI**.
- Model building, evaluation, and deployment using **Python**, **Flask**, and **scikit‑learn**.

---

## 1. SQL Data Exploration
- Created the schema for all attributes in the dataset in **MySQL**.
- Analyzed data using SQL to find customer churn percentage by:
  - **Demographics** (gender, senior citizen status, dependents).
  - **Tenure**.
  - **Contract Type**.
  - Services (phone, internet).
  - **Billing** (paperless, payment method).
- Created new features:
  - **Autopay Status** (derived from payment method).
  - **Tenure Buckets**.
  - Grouped **Monthly Charges** and **Total Charges**.

> 📁 **Location**: `SQL Data Exploration`

---

## 2. Power BI Visualizations
- Exported key result tables to Power BI.
- Created a **dashboard** visualizing:
  - Churn percentages across demographics.
  - Impact of service features (internet, phone).
  - Contract and billing information.
- Created interactive visual reports for stakeholders.

> 📁 **Location**: `Power BI Visualizations`

---

## 3. Preprocessing & Model Training
- Loaded the dataset into a Jupyter Notebook using **Pandas**.
- Performed statistical analyses:
  - Checked for **outliers** using:
    - **IQR test**
    - **Percentile method**
  - No significant outliers detected.
- Created visualizations:
  - **Correlation heatmap** for numerical features.
  - Churn percentages across service features.
- Created new features:
  - Assigned **structural missing values** (`tenure_group = 0–12` when `tenure = 0`).
  - Created **First Month User** feature.
- Transformed data:
  - Mapped binary fields (`Yes`/`No`, `Male`/`Female`) to `1`/`0`.
  - One‑hot encoded multi‑category fields.
- Split data:
  - **Training** (80%) / **Testing** (20%)
- Model:
  - Trained a **Logistic Regression** model.
  - Tuned **max_iter** for better convergence.
  - Achieved:
    - **Accuracy**: ~80%
    - **ROC AUC Score**: ~0.84
  - Adjusted prediction threshold to **40%** for higher **Recall** (~78%).

> 📁 **Location**: `Preprocessing & Training`

---

## 4. Flask Model Deployment
- Created a **Flask** application with three pages:
  1. **Home Page** — Collects basic customer information.
  2. **Additional Features Page** — Collects service and demographic information.
  3. **Results Page** — Displays:
     - Final churn prediction.
     - Probability of churn.
- Created additional columns (`AutoPay Status`, `tenure_group`, `First Month User`) for prediction.
- Kept prediction threshold at **40%**.
- Created a clean, user‑friendly layout using custom **CSS**.

> 📁 **Location**: `Flask Model Deployment`

---

## Technologies Used
- **MySQL** — Database schema & exploration.
- **Power BI** — Dashboard and visual analytics.
- **Python** — Model building & preprocessing.
- **Flask** — Model deployment.
- **Pandas, NumPy, scikit‑learn** — Data analysis & modeling.
- **Seaborn, Matplotlib** — Visualization.
- **HTML/CSS** — User interface.

---

## Results & Insights
- Created new features yielding significant improvements in prediction quality.
- Developed an interpretable model achieving:
  - **80% accuracy**, **0.84 ROC AUC**.
  - **Better recall (~78%)** at a **40% threshold**.
- Created an end‑to‑end workflow:
  - From data exploration and engineering ➔ Model deployment.

---

## Get Started
### Prerequisites
- **Python 3.9+**
- Install required packages:
    ```bash
    pip install -r requirements.txt
    ```

### Run the Flask App
```bash
python app.py
