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
        'tenure': request.form.get('tenure'),
        'monthly_charges': request.form.get('monthly_charges'),
        'total_charges': request.form.get('total_charges'),
        'gender': request.form.get('gender'),
        'contract': request.form.get('contract'),
        'PaymentMethod': request.form.get('PaymentMethod'),
    }
    return render_template('additional.html', home_page_data=home_page_data)

# Route for the prediction page
@app.route('/predict', methods=['POST'])
def predict(): 
    try:
        # Get the home page data from the form
        home_page_data = {
            'tenure': request.form.get('tenure'),
            'monthly_charges': request.form.get('monthly_charges'),
            'total_charges': request.form.get('total_charges'),
            'gender': request.form.get('gender'),
            'contract': request.form.get('contract'),
            'PaymentMethod': request.form.get('PaymentMethod'),
        }

        additional_data = {
            'senior_citizen': request.form.get('senior_citizen'),
            'partner': request.form.get('partner'),
            'dependents': request.form.get('dependents'),
            'phone_service': request.form.get('phone_service'),
            'multiple_lines': request.form.get('multiple_lines'),
            'internet_service': request.form.get('internet_service'),
            'online_security': request.form.get('online_security'),
            'online_backup': request.form.get('online_backup'),
            'device_protection': request.form.get('device_protection'),
            'tech_support': request.form.get('tech_support'),
            'streaming_tv': request.form.get('streaming_tv'),
            'streaming_movies': request.form.get('streaming_movies'),
            'paperless_billing': request.form.get('paperless_billing'),
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

        # One-hot encode categorical variables and convert to numerical format
        categorical_features = input_df.select_dtypes(include=['object', 'category']).columns.tolist()
        multiclass_features = []

        for features in categorical_features:
            if input_df[features].nunique() > 2:
                multiclass_features.append(features)

        input_df = pd.get_dummies(input_df, columns=multiclass_features, drop_first=True)

        for feature in categorical_features:
            input_df[feature] = pd.to_numeric(input_df[feature], errors='coerce')
        
        # Ensure all columns are present in the model's expected format
        input_df = input_df.reindex(columns=model.feature_names_in_, fill_value=0)
        
        # Make prediction
        prediction = model.predict(input_df)
        
        # Return the result
        return prediction
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)