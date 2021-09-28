from flask import Flask, redirect, url_for, render_template, request
from dronekit import connect, VehicleMode
from time import sleep
from colorama import Fore


app = Flask(__name__)

#testing moises test.py with app
def arm_n_takeoff(altitude, vehicleIn):
    vehicle = vehicleIn

    while not vehicle.is_armable:
        print("Drone is not armable...")
        sleep(1)
    print("\nDrone is now armable!")

    vehicle.mode = VehicleMode("GUIDED")

    while not vehicle.mode.name == 'GUIDED':
        print("Changing mode to GUIDED...")
        sleep(1)
    print("\nIn GUIDED mode!")

    vehicle.armed = True
    while vehicle.armed != True:
        print("Drone is arming...")
        sleep(1)
    print("\nDrone is armed!")

    # Takeoff!
    vehicle.simple_takeoff(altitude)
    print("Taking off.")

    # Wait until 95% of altitude is reached
    while vehicle.location.global_relative_frame.alt < (altitude * .95):
        print("Height: {}m" .format(vehicle.location.global_relative_frame.alt))
        sleep(1)
    print("\nReached target height!")

    print(vehicle.location.global_relative_frame)

# main page where mostly everything will happen
@app.route("/", methods = ['POST', 'GET'])
def home():
    SelectedPort = 0

    if request.method == 'POST':
        if request.form.get('PortNumber') != '':
            SelectedPort = 1
            connectionString = "127.0.0.1:" + request.form.get('PortNumber')
            print(Fore.GREEN + "Port: "+ connectionString + " selected")
            print(Fore.WHITE)
            vehicle = connect(connectionString, wait_ready = True)
            arm_n_takeoff(20 , vehicle)

        else:
            print("INVALID!")
            return render_template("index.html", flash_message = False, SelectedPort = SelectedPort)


        return render_template("index.html", flash_message = True, SelectedPort = SelectedPort, Battery = vehicle.battery.level\
            , Port = request.form.get("PortNumber"), location = vehicle.location.global_relative_frame)

    return render_template("index.html", flash_message = False, SelectedPort = 0)

# made a nema decoder probably useless
@app.route("/NMEAdecoder")
def coordinateInput():
    return render_template("NMEAdecoder.html")

if __name__ == "__main__":
    #vehicle = connect('tcp:127.0.0.1:5760', wait_ready=True)
    app.run(debug = True,threaded=True)
