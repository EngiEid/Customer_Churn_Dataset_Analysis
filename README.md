# 📊 Customer Churn Analysis
**Team Name:** Stayzen

## 📌 Project Overview
Customer churn is a critical challenge for subscription-based businesses.  
This project aims to analyze customer behavior, identify churn patterns, and predict customers who are likely to churn using machine learning.

We combined **data analysis**, **interactive dashboards**, and a **predictive ML model**, then deployed the solution through a **Streamlit web application**.

---

## 🗂 Dataset Description
The dataset consists of customer demographic, behavioral, and financial attributes.

| Column | Description |
|------|------------|
| CustomerID | Unique identifier for each customer |
| Age | Age of the customer |
| Gender | Gender of the customer |
| Tenure | Duration (in months) the customer has used the service |
| Usage Frequency | Number of times the service was used in the last month |
| Support Calls | Number of support calls in the last month |
| Payment Delay | Number of delayed payment days |
| Subscription Type | Type of subscription plan |
| Contract Length | Contract duration |
| Total Spend | Total amount spent by the customer |
| Last Interaction | Days since last customer interaction |
| Churn | Target variable (1 = churned, 0 = retained) |

---

## 📊 Tableau Dashboards
We designed **three interactive Tableau dashboard pages** to analyze churn from multiple perspectives:

### 1️⃣ Overview & Demographics
- Total customers and churn rate
- Churn vs retention
- Churn distribution across genders
- Churn trends across age groups

### 2️⃣ Customer Behavior
- Churn by contract type
- Impact of support calls
- Churn vs last interaction
- Churn across customer tenure

### 3️⃣ Revenue Insights
- Revenue churn rate
- Impact of payment delay
- Usage frequency vs churn
- Total spend and subscription type analysis

📌 These dashboards help identify high-risk customer segments and key churn drivers.

---

## 🤖 Machine Learning Model
We built a **customer churn prediction model using XGBoost**.

### Model Details:
- Problem Type: Binary Classification
- Algorithm: XGBoost
- Target Variable: Churn
- Data preprocessing and feature scaling applied
- Model evaluated using accuracy and classification metrics

🎯 **Objective:** Predict customers likely to churn and support proactive retention strategies.

---

## 🌐 Web Application
A **Streamlit web application** was developed to:
- Display churn insights interactively
- Allow users to explore customer data
- Predict churn probability using the trained XGBoost model

---

## 🛠 Tech Stack
- **Python**
- **Pandas & NumPy** – Data preprocessing
- **Tableau** – Data visualization & dashboards
- **XGBoost** – Machine learning model
- **Scikit-learn** – Model evaluation & preprocessing
- **Streamlit** – Web application
- **Git & GitHub** – Version control

---

## 🚀 How to Run the Project

```bash
# Clone the repository
git clone https://github.com/your-username/customer-churn-analysis.git

# Navigate to project directory
cd customer-churn-analysis

# Install dependencies
pip install -r requirements.txt

# Run Streamlit app
streamlit run app.py
