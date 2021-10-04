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

@app.route('/background_process_test')
def background_process_test():
    data = request.get_json
    UserInputCoordinates = [(request.args.get('coor1LAT'), request.args.get('coor1LNG')),\
                            (request.args.get('coor2LAT'), request.args.get('coor2LNG')),\
                            (request.args.get('coor3LAT'), request.args.get('coor3LNG')),\
                            (request.args.get('coor4LAT'), request.args.get('coor4LNG'))]
                            
    print("Coordinates 1(LAT,LNG): "+ str(UserInputCoordinates[0]))
    print("Coordinates 2(LAT,LNG): "+ str(UserInputCoordinates[1]))
    print("Coordinates 3(LAT,LNG): "+ str(UserInputCoordinates[2]))
    print("Coordinates 4(LAT,LNG): "+ str(UserInputCoordinates[3]))

    return ('hi')

if __name__ == "__main__":
    #vehicle = connect('tcp:127.0.0.1:5760', wait_ready=True)
    app.run(debug = True,threaded=True)
