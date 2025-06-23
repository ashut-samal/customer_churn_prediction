from flask import Flask, request, jsonify, render_template
import pickle
import joblib
import numpy as np
import pandas as pd

app = Flask(__name__)

# Load the pre-trained model
model = joblib.load("churn_model.joblib")

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict(): 
    try:
        # Get the input data from the form
        input_data = request.form.to_dict()
        
        # Convert input data to a DataFrame
        input_df = pd.DataFrame([input_data])
        
        # Convert categorical variables to numeric if necessary
        for col in input_df.select_dtypes(include=['object']).columns:
            input_df[col] = pd.to_numeric(input_df[col], errors='coerce')
        
        # Ensure all columns are present in the model's expected format
        input_df = input_df.reindex(columns=model.feature_names_in_, fill_value=0)
        
        # Make prediction
        prediction = model.predict(input_df)
        
        # Return the result
        return jsonify({'prediction': int(prediction[0])})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)