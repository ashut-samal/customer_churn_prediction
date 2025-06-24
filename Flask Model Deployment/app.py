from flask import Flask, request, jsonify, render_template
import joblib
import numpy as np
import pandas as pd

app = Flask(__name__)

# Load the pre-trained model
model = joblib.load("churn_model.joblib")

# Load the first page
@app.route('/')
def home():
    return render_template('home.html')

# Load the next page for additional information
@app.route('/next', methods=['POST'])
def next_page():
    home_page_data = {
        'tenure': int(request.form.get('tenure')),
        'MonthlyCharges': float(request.form.get('MonthlyCharges')),
        'TotalCharges': float(request.form.get('TotalCharges')),
        'gender': request.form.get('gender'),
        'Contract': request.form.get('Contract'),
        'PaymentMethod': request.form.get('PaymentMethod'),
    }

    return render_template('additional.html', home_page_data=home_page_data)

# Route for the prediction page
@app.route('/predict', methods=['POST'])
def predict(): 
    try:
        # Get the home page data from the form
        home_page_data = {
            'tenure': int(request.form.get('tenure')),
            'MonthlyCharges': float(request.form.get('MonthlyCharges')),
            'TotalCharges': float(request.form.get('TotalCharges')),
            'gender': request.form.get('gender'),
            'Contract': request.form.get('Contract'),
            'PaymentMethod': request.form.get('PaymentMethod'),
        }

        additional_data = {
            'SeniorCitizen': int(request.form.get('SeniorCitizen')),
            'Partner': int(request.form.get('Partner')),
            'Dependents': int(request.form.get('Dependents')),
            'PhoneService': request.form.get('PhoneService'),
            'MultipleLines': request.form.get('MultipleLines'),
            'InternetService': request.form.get('InternetService'),
            'OnlineSecurity': request.form.get('OnlineSecurity'),
            'OnlineBackup': request.form.get('OnlineBackup'),
            'DeviceProtection': request.form.get('DeviceProtection'),
            'TechSupport': request.form.get('TechSupport'),
            'StreamingTV': request.form.get('StreamingTV'),
            'StreamingMovies': request.form.get('StreamingMovies'),
            'PaperlessBilling': int(request.form.get('PaperlessBilling')),
        }

        combined_data = {**home_page_data, **additional_data}   
        
        # Convert input data to a DataFrame
        input_df = pd.DataFrame([combined_data])

        # Adding new features same as done in preprocessing
        # Adding a new feature 'AutoPay Status' based on 'PaymentMethod'
        input_df['AutoPay Status'] = input_df['PaymentMethod'].apply(
            lambda x: 1 if 'automatic' in x.lower() else 0
        )

        # Adding a new feture 'tenure group' based on 'tenure'
        input_df['tenure_group'] = pd.cut(
            input_df['tenure'],
            bins=[0, 12, 24, 36, 48, 60, 72],
            labels=['0-12', '13-24', '25-36', '37-48', '49-60', '60-72']
        )

        # Adding a new feature 'First Month User' based on the values of 'MonthlyCharges' and 'TotalCharges'
        input_df['First Month User'] = input_df.apply(
            lambda x: 1 if (x['MonthlyCharges'] == x['TotalCharges']) else 0,
            axis=1
        )

        # One-hot encode and align columns
        input_df = encode_and_align_columns(input_df)

        # Perform prediction
        prediction = model.predict(input_df)[0]
        prediction_prob = model.predict_proba(input_df)[0][1] * 100

        # Set the threshold for prediction
        threshold = 40.00
        prediction = 1 if prediction_prob >= threshold else 0

        result = {
            'prediction': 'Yes' if prediction == 1 else 'No',
            'probability': round(prediction_prob, 2),
        }

        # Return the result
        return render_template('result.html', result=result)

    except Exception as e:
        return jsonify({'error': str(e)})
    
@app.route('/check_features')
def check_features():
    return str(model.feature_names_in_)

def encode_and_align_columns(df: pd.DataFrame) -> pd.DataFrame:
    # One-hot encode multi-class categorical columns and align columns for prediction.
    # Identify categorical columns
    categorical_features = df.select_dtypes(include=['object', 'category']).columns.tolist()
    multiclass_columns = [col for col in categorical_features if df[col].nunique() > 2]

    # Perform one-hot encoding
    df = pd.get_dummies(df, columns=multiclass_columns, drop_first=True)

    # Coerce rest of the categorical columns to numeric
    for feature in categorical_features:
        if feature in df.columns:
            df[feature] = pd.to_numeric(df[feature], errors='coerce')

    # Align columns
    df = df.reindex(columns=model.feature_names_in_, fill_value=0)

    # Fill NaN values with 0
    df = df.fillna(0)
    return df

if __name__ == '__main__':
    app.run(debug=True)