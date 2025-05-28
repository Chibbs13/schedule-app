from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
import os
from openai import OpenAI
from datetime import datetime, timedelta
import json

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

def parse_duration(duration_str):
    """Parse duration string (e.g., '2 hours', '30 minutes') into minutes."""
    parts = duration_str.lower().split()
    if len(parts) != 2:
        return 0
    
    number = float(parts[0])
    unit = parts[1]
    
    if 'hour' in unit:
        return int(number * 60)
    elif 'minute' in unit:
        return int(number)
    return 0

def generate_schedule(tasks_input):
    """Generate a schedule using OpenAI API."""
    prompt = f"""Given the following tasks, create a schedule for today starting from now. 
    For each task, provide a start time and end time in 24-hour format.
    Tasks: {tasks_input}
    
    Return the response in the following JSON format:
    {{
        "tasks": [
            {{
                "name": "Task name",
                "duration": duration_in_minutes,
                "startTime": "YYYY-MM-DDTHH:MM:SS",
                "endTime": "YYYY-MM-DDTHH:MM:SS"
            }}
        ]
    }}
    """
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful scheduling assistant."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
        )
        
        # Extract and parse the JSON response
        content = response.choices[0].message.content
        # Find the JSON part in the response
        start_idx = content.find('{')
        end_idx = content.rfind('}') + 1
        if start_idx == -1 or end_idx == 0:
            raise ValueError("No valid JSON found in response")
        
        json_str = content[start_idx:end_idx]
        # Parse the JSON string into a Python dictionary
        return json.loads(json_str)
        
    except Exception as e:
        print(f"Error generating schedule: {str(e)}")
        raise

@app.route('/api/generate-schedule', methods=['POST'])
def generate_schedule_endpoint():
    try:
        data = request.get_json()
        if not data or 'tasks' not in data:
            return jsonify({'error': 'No tasks provided'}), 400
        
        tasks_input = data['tasks']
        schedule = generate_schedule(tasks_input)
        return jsonify(schedule)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000) 