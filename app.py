from flask import Flask, redirect, url_for, render_template
from dronekit import connect

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/coordinateInput")
def coordinateInput():
    return render_template("coordniatePage.html")

@app.route("/controlOverride")
def overrideControls():
    return render_template("controlOverride.html")

if __name__ == "__main__":
    #vehicle = connect('tcp:127.0.0.1:5760', wait_ready=True)
    app.run(debug = True,threaded=True)
