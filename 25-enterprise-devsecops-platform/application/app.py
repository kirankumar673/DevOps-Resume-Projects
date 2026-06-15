from flask import Flask, jsonify
import os

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
ENVIRONMENT = os.getenv("ENVIRONMENT", "production")

@app.route("/")
def home():
    return jsonify({
        "service": "Enterprise DevSecOps Platform",
        "version": APP_VERSION,
        "environment": ENVIRONMENT,
        "status": "running"
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "version": APP_VERSION}), 200

@app.route("/ready")
def ready():
    return jsonify({"status": "ready"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
