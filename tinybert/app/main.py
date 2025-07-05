from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from transformers import AutoTokenizer, AutoModel
import torch
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Load environment variables
MODEL_NAME = os.getenv('MODEL_NAME', 'distilbert-base-uncased')
MODEL_CACHE_DIR = os.getenv('MODEL_CACHE_DIR', '/app/models')

# Global model and tokenizer
model = None
tokenizer = None

def load_model():
    global model, tokenizer
    try:
        logger.info(f"Loading model: {MODEL_NAME}")
        tokenizer = AutoTokenizer.from_pretrained(
            MODEL_NAME, 
            cache_dir=MODEL_CACHE_DIR
        )
        model = AutoModel.from_pretrained(
            MODEL_NAME, 
            cache_dir=MODEL_CACHE_DIR
        )
        logger.info("Model loaded successfully")
    except Exception as e:
        logger.error(f"Error loading model: {e}")
        raise

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'model': MODEL_NAME,
        'model_loaded': model is not None
    })

@app.route('/embed', methods=['POST'])
def embed_text():
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'No text provided'}), 400
        
        if model is None or tokenizer is None:
            return jsonify({'error': 'Model not loaded'}), 500
        
        # Tokenize and encode
        inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True)
        
        with torch.no_grad():
            outputs = model(**inputs)
            embeddings = outputs.last_hidden_state.mean(dim=1)
        
        return jsonify({
            'embeddings': embeddings.tolist(),
            'shape': list(embeddings.shape),
            'model': MODEL_NAME
        })
    
    except Exception as e:
        logger.error(f"Error in embed_text: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/similarity', methods=['POST'])
def compute_similarity():
    try:
        data = request.get_json()
        text1 = data.get('text1', '')
        text2 = data.get('text2', '')
        
        if not text1 or not text2:
            return jsonify({'error': 'Both text1 and text2 are required'}), 400
        
        if model is None or tokenizer is None:
            return jsonify({'error': 'Model not loaded'}), 500
        
        # Encode both texts
        inputs1 = tokenizer(text1, return_tensors='pt', truncation=True, padding=True)
        inputs2 = tokenizer(text2, return_tensors='pt', truncation=True, padding=True)
        
        with torch.no_grad():
            outputs1 = model(**inputs1)
            outputs2 = model(**inputs2)
            
            emb1 = outputs1.last_hidden_state.mean(dim=1)
            emb2 = outputs2.last_hidden_state.mean(dim=1)
            
            # Compute cosine similarity
            similarity = torch.cosine_similarity(emb1, emb2)
        
        return jsonify({
            'similarity': float(similarity.item()),
            'text1': text1,
            'text2': text2,
            'model': MODEL_NAME
        })
    
    except Exception as e:
        logger.error(f"Error in compute_similarity: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/models', methods=['GET'])
def list_models():
    return jsonify({
        'current_model': MODEL_NAME,
        'model_loaded': model is not None,
        'cache_dir': MODEL_CACHE_DIR
    })

if __name__ == '__main__':
    # Load model on startup
    load_model()
    
    # Start the Flask app
    app.run(
        host=os.getenv('FLASK_RUN_HOST', '0.0.0.0'),
        port=int(os.getenv('FLASK_RUN_PORT', 8083)),
        debug=os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    )
