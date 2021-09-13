from flask import Flask, redirect, url_for, render_template, request
from dronekit import connect

app = Flask(__name__)

# main page where mostly everything will happen
@app.route("/", methods = ['POST', 'GET'])
def home():
    SelectedPort = 0

    if request.method == 'POST':
        if request.form.get('PortNumber') == '1':
            print("PORT 1 SELECTED")
            SelectedPort = 1

        elif request.form.get('PortNumber') == '2':
            print("PORT 2 SELECTED")
            SelectedPort = 2

        elif request.form.get('PortNumber') == '3':
            print("PORT 3 SELECTED")
            SelectedPort = 3 

        else:
            print("INVALID!")
            return render_template("index.html", flash_message = False, SelectedPort = SelectedPort)


        return render_template("index.html", flash_message = True, SelectedPort = SelectedPort)

    return render_template("index.html", flash_message = False, SelectedPort = 0)

# made a nema decoder probably useless
@app.route("/NMEAdecoder")
def coordinateInput():
    return render_template("NMEAdecoder.html")

if __name__ == "__main__":
    #vehicle = connect('tcp:127.0.0.1:5760', wait_ready=True)
    app.run(debug = True,threaded=True)
