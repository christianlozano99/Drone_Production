import math
from flask import Flask, redirect, url_for, render_template, request
from dronekit import connect, VehicleMode, LocationGlobalRelative
from time import sleep
from colorama import Fore

# CV Model Libraries
import cv2, time
import numpy as np


app = Flask(__name__)

vehicle = None
# Telemetry variables used in UI
batteryPercent = 0.0
voltage = 0.0
current = 0.0
position = tuple()
height = 0.0
velocity = 0.0
gps = None
# This flag is set when searching for multiple targets.
multi_rescue = 0

# These flag variables are for testing the code without Lisa's part.
# The coordinates are an example. The CV found list will hold the locations
# of the people found.
submitConnect = True
submitCoordinates = True
Retreat = False
emergencyLand = False
stopDrone = False
personFound = False
personLocation = []
numOfRescued = 0
altitude = 10
# Used for testing the script w/o search_algorithm(). Do not use if search_algorithm() in use.
coordinates = [(-35.36386175056098, 149.1647898908397), \
                (-35.36203233417043, 149.16445339580716), \
                (-35.361818899557925, 149.16618073697418), \
                    (-35.36366051678722, 149.16665183001973)]

# Test input for search_algorith(). Not a perfect rectangle
testCoordinates =  [(-35.36165545753266, 149.1603591066628),    \
                    (-35.36148046674933, 149.1650368792219),    \
                    (-35.36391280463349, 149.16083117545315),   \
                    (-35.364227778280814, 149.16424294534718)]

# Test input is rectangle
test3 = [(-35.3638805824148, 149.16447914421548), \
                (-35.363915579561386, 149.16236556358444), \
                (-35.36174572778457, 149.16224754639185), \
                    (-35.36171072969738, 149.1643503981872)]

# Test input is half of football field (150' x 160')
test4_ft_ball_field = [(-35.36231539725387, 149.16226176440182), \
                        (-35.36275491977364, 149.1622723321772), \
                            (-35.362758366999635, 149.1617650789596), \
                                (-35.36231712087627, 149.16174605696395)]


def arm_n_takeoff(altitude, vehicleIn):
    vehicle = vehicleIn
    # Used to detect if drone stuck trying to reach set height.
    count = 1
    # Wait for drone to be armable
    while not vehicle.is_armable:
        print("Drone is not armable...")
        telemetry()
        sleep(1)  
    print("\nDrone is now armable!")

    # Update telemetry.
    telemetry()

    # Drone must be set to GUIDED mode for cmds to work.
    vehicle.mode = VehicleMode("GUIDED")

    # Wait for the mode to change to GUIDED
    while not vehicle.mode.name == 'GUIDED':
        print("Changing mode to GUIDED...")
        vehicle.mode = VehicleMode("GUIDED")    # Issue cmd again in case of instruction interruption.
        telemetry()
        sleep(1)
    print("In GUIDED mode!\n")

    # Update telemetry.
    telemetry()

    # Arm drone and wait for it to occur.
    vehicle.armed = True
    while vehicle.armed != True:
        print("Arming drone...")
        telemetry()
        sleep(1)
    print("Drone armed!")

    # Update telemetry.
    telemetry()

    # Takeoff!
    vehicle.simple_takeoff(altitude)
    print("Taking off.\n")

    # Wait until 95% of altitude is reached
    while vehicle.location.global_relative_frame.alt < (altitude * .95):
        print("Height: {}m" .format(vehicle.location.global_relative_frame.alt))

        # If vehicle stuck trying to reach set height then resent takeoff cmd.
        if count == 7:
            print("Resending takeoff cmd.")
            vehicle.simple_takeoff(altitude)
            count = 1

        telemetry()
        count += 1
        sleep(1)
    print("Reached target height!")

    return

# This function updates the telemetry data and prints it on the terminal.
def telemetry():
    # These variables are declared at the top of the script. Will be used for
    # the user interface to output telemetry.
    global batteryPercent, voltage, current, position, height, velocity, gps
    
    voltage =           vehicle.battery.voltage
    current =           vehicle.battery.current
    batteryPercent =    vehicle.battery.level
    gps =               vehicle.gps_0
    position =          (vehicle.location.global_frame.lat, vehicle.location.global_frame.lon)
    height =            vehicle.location.global_relative_frame.alt
    velocity =          vehicle.airspeed / 0.44704
    
    '''
    print("\n*************************************")
    print("{}" .format(vehicle.battery))
    print("{}" .format(gps))
    print("Drone position: {}" .format(position))
    print("Drone altitude: {}m" .format(height))
    print("Speed: {}mph" .format(velocity))
    print("*************************************\n")
    '''
def land():
    
    global vehicle, emergencyLand, numOfRescued

    # Update telemetry.
    telemetry()

    if not emergencyLand:
        # Return to Launch
        print("\nReturning to launch.\n")
        vehicle.mode = VehicleMode("RTL")
        while not vehicle.mode.name == "RTL":
            print("Changing to RTL mode...")
            vehicle.mode = VehicleMode("RTL")
            sleep(1)
        print("\nDrone Switched to RTL mode!")

    else:
        # Land drone
        vehicle.mode = "LAND"
        while not vehicle.mode.name == "LAND":
            print("Changing to LAND mode...")
            vehicle.mode = "LAND"
            sleep(1)
        print("\nDrone Switched to LAND mode!")
        print("Landing...")

    print("Closing vehicle object.")
    #vehicle.close()
    # need to consider making this a new page on UI
    i = 0
    print("\n_______MISSION REPORT:______________________________")
    print("Number of rescued: {}" .format(numOfRescued))
    for location in personLocation:
        print("Person {} at: {}" .format(i, location))
        i += 1
    print("_______END OF MISSION______________________________\n")

    # End program execution.
    exit()

def get_distance_meters(aLocation1, aLocation2):
    dlat = aLocation2.lat - aLocation1.lat
    dlong = aLocation2.lon - aLocation1.lon
    return math.sqrt((dlat*dlat) + (dlong*dlong)) * 1.113195e5

#equation of the line between 2 gps coordinates
def search_algorithm(coordinates, altitude):

    # initialize coords lilst
    coords = [0, 0, 0, 0]

    # coordinates are in (lat,long); coords is a list of the corners of a perfect rectangle that contains the user-inputted search area

    coords[0] = (min(coordinates[0][0], coordinates[3][0]), min(coordinates[0][1], coordinates[1][1]))
    coords[1] = (max(coordinates[1][0], coordinates[2][0]), min(coordinates[0][1], coordinates[1][1]))
    coords[2] = (max(coordinates[1][0], coordinates[2][0]), max(coordinates[2][1], coordinates[3][1]))
    coords[3] = (min(coordinates[0][0], coordinates[3][0]), max(coordinates[2][1], coordinates[3][1]))


    longitudes = [coords[0][1], coords[1][1]]
    latitudes = [coords[0][0], coords[1][0]]

    # interval for search passes: .00006 degrees (approximately 2m)

    i = 1

    while (longitudes[i] < coords[3][1]):
        i += 1
        if i%2 == 0:
            latitudes.append(latitudes[i-1])
            longitudes.append(longitudes[i-1] + .00006)
        else:
            latitudes.append(latitudes[i-3])
            longitudes.append(longitudes[i-3] + .00006)
        

    # write calculated latitudes/longitudes to list of tuples

    waypoints = []
    for i in range(0, len(longitudes)):
        waypoints.append((latitudes[i], longitudes[i]))

    return waypoints


def search(coordinates):

    global batteryPercent, personFound, personLocation, numOfRescued, emergencyLand, velocity,\
            testCoordinates, stopDrone, Retreat, multi_rescue
    
    # Get mission coordinates.
    print("BEFORE - coordinates: {}" .format(coordinates))
    coordinates = search_algorithm(coordinates, altitude = 3.05)
    print("AFTER - coordinates: {}" .format(coordinates))
    global vehicle
    arm_n_takeoff(3.05, vehicle)  # 3.05m == 10ft

    vehicle.airspeed = 20           # Set drone speed in m/s.
    index = 1                       # Used for printing current waypoint #.

    # Execute until no more coordinates. This loop controls what the drone does if special case arises.
    for wp in coordinates:

        # Create LocationGlobalRelative variable of current waypoint to then pass to simple_goto()
        destination = LocationGlobalRelative(wp[0], wp[1], altitude)

        # Get distance between current location and destination. Used to detect arrival to waypoint.
        distance = get_distance_meters(vehicle.location.global_relative_frame, destination)

        # These 2 variables are used for comparison to detect if drone is stuck at waypoint.
        init_distance = distance
        count = 1
        
        # Update telemtry
        telemetry()

        print("\nHeading to waypoint {}: {}\n" .format(index, wp))

        # Tells drone to move to destination.
        vehicle.simple_goto(destination)

        # Keep moving to destination as long as battery ok and no UI interaction occurs.
        while distance >= 1.5 and not Retreat and not emergencyLand and not stopDrone and batteryPercent > 20:

            # Detects if drone gets stuck while heading to waypoint by monitoring change in distance. If 10 iterations have passed
            # and the current distance is 95% or greater of the initial distance; then drone is stuck.
            # simple_goto cmd might have gotten lost.
            if count == 15 and distance/init_distance >= .95:
                print("Getting un-stuck.") 
                vehicle.simple_goto(destination)    # Resend goto cmd to finish heading to wp.
                count = 1                           # Reset count variable to detect if stuck again.

            # If drone randomly changes to RTL go back to GUIDED.
            if vehicle.mode.name == 'RTL':
                vehicle.mode = VehicleMode("GUIDED")
                while not vehicle.mode.name == "GUIDED":
                    print("FIXING RANDOM RTL...")
                print("FIXED: IN GUIDED AGAIN...")
                vehicle.simple_goto(destination)

            if personFound:
                if multi_rescue:    # If rescueing multiple do not RTL at first target find.
                    # Store person location
                    personLocation.append( (vehicle.location.global_frame.lat, vehicle.location.global_frame.lon) )
                
                    print("\nFOUND PERSON AT: ({0:.4f}, {1:.4f})" .format(personLocation[-1][-2], \
                                                                        personLocation[-1][-1])) # Last appended lat & lon
                    # Lower flag to not trigger again, count person, and sleep for 2 seconds to avoid detecting same person.
                    personFound = False
                    numOfRescued += 1
                    sleep(2)
                else:   # Finds 1 target and RTL.
                    print("\nFOUND PERSON AT: ({0:.4f}, {1:.4f})" .format(vehicle.location.global_frame.lat, \
                                                                        vehicle.location.global_frame.lon)) # Last appended lat & lon
                    print("Mission Complete!")
                    land()


            print("Remaining distance: {0:.2f}m | Speed: {1:.2f}mph" .format(distance, velocity))
            telemetry()
            distance = get_distance_meters(vehicle.location.global_frame, destination)

            # Increment count. At count = 10 the code will detect if the distance has changed or not.
            count += 1
            # Used to slow down the amount output printed.
            sleep(.5)

            #vehicle.simple_goto(destination)

            '''NOTE: NOT WORKING - Uncomment next two lines to test Retreat.'''
            #sleep(4)
            #stopDrone = True
            '''Uncomment next two lines to test Retreat.'''
            #sleep(4)
            #Retreat = True
            '''Uncomment next two lines to test emergencyLand.'''
            #sleep(4)
            #emergencyLand = True
            '''Uncomment next two lines to test finding people.'''
            #if index == 4:
                #sleep(3)
                #personFound = True

        # If user presses Retreat button exit and RTL
        if Retreat:
            print("\n-------------------------------------"
            "\nRETREAAAAT!"
            "\n-------------------------------------")
            land()

        # If user presses emergency land button, drone lands.
        # Vehicle object closed and script exits.
        if emergencyLand:
            print("\n-------------------------------------"
            "\nEMERGENCY LAND!"
            "\n-------------------------------------")
            land()
        
        # If battery low, RTL.
        if batteryPercent <= 20:
            print("\n-------------------------------------"
            "\nBATTERY LOW! END OF MISSION."
            "\n-------------------------------------")
            #emergencyLand = True
            land()
            
        index += 1


        
 
# Code for CV Model (YOLOv4) below
# YOLOv4 Tiny Weights and CFG Files must be within folder of app.py
def CV_Model():
	#Load YOLO
	#net = cv2.dnn.readNet("yolov4.weights","yolov4.cfg") # Original yolov4
	net = cv2.dnn.readNet("yolov4-tiny.weights","yolov4-tiny.cfg") #Tiny Yolo
	classes = []
	with open("coco.names","r") as f:
	    classes = [line.strip() for line in f.readlines()]

	print(classes)

	layer_names = net.getLayerNames()
	outputlayers = [layer_names[i[0] - 1] for i in net.getUnconnectedOutLayers()]


	colors= np.random.uniform(0,255,size=(len(classes),3))


	#loading image
	source = 0 #"AnalogTest1.mp4") #0 for 1st webcam

	cap=cv2.VideoCapture(source) 

	if cap is None or not cap.isOpened():
	   print('Warning: unable to open video source:', source)

	else:
		print('Opening video source:', source)


	font = cv2.FONT_HERSHEY_PLAIN
	starting_time= time.time()
	frame_id = 0

	while True:
	    _,frame= cap.read() # 
	    frame_id+=1

	    height,width,channels = frame.shape
	    #detecting objects
	    blob = cv2.dnn.blobFromImage(frame,0.00392,(320,320),(0,0,0),True,crop=False) #reduce 416 to 320    

	        
	    net.setInput(blob)
	    outs = net.forward(outputlayers)
	    #print(outs[0])

	    stop = False

	    #Showing info on screen/ get confidence score of algorithm in detecting an object in blob
	    class_ids=[]
	    confidences=[]
	    boxes=[]
	    for out in outs:
	        for detection in out:
	            scores = detection[5:]
	            class_id = np.argmax(scores)
	            confidence = scores[class_id]
	            if confidence > 0.3:
	                #onject detected
	                center_x= int(detection[0]*width)
	                center_y= int(detection[1]*height)
	                w = int(detection[2]*width)
	                h = int(detection[3]*height)

	                #cv2.circle(img,(center_x,center_y),10,(0,255,0),2)
	                #rectangle co-ordinaters
	                x=int(center_x - w/2)
	                y=int(center_y - h/2)
	                #cv2.rectangle(img,(x,y),(x+w,y+h),(0,255,0),2)

	                boxes.append([x,y,w,h]) #put all rectangle areas
	                confidences.append(float(confidence)) #how confidence was that object detected and show that percentage
	                class_ids.append(class_id) #name of the object tha was detected

	                print(classes[class_id], '\t', round(confidence * 100, 2))

	                # If humans have been detected with 80% confidence, then set boolean value to True (this can stop detection if we wish)
	                if classes[class_id] == 'person' and confidence >= 0.8:
	                	stop = True

	    indexes = cv2.dnn.NMSBoxes(boxes,confidences,0.4,0.6)


	    for i in range(len(boxes)):
	        if i in indexes:
	            x,y,w,h = boxes[i]
	            label = str(classes[class_ids[i]])
	            confidence= confidences[i]
	            color = colors[class_ids[i]]
	            cv2.rectangle(frame,(x,y),(x+w,y+h),color,2)
	            cv2.putText(frame,label+"  (Confidence: "+str(round(confidence * 100,1)) + "%)",(x,y+30),font,1,(255,255,255),2)
	            

	    elapsed_time = time.time() - starting_time
	    fps=frame_id/elapsed_time
	    cv2.putText(frame,"FPS:"+str(round(fps,2)),(10,50),font,2,(0,0,0),1)
	    
	    cv2.imshow("Image",frame)

	    key = cv2.waitKey(1) #wait 1ms the loop will start again and we will process the next frame
	 


	# Only Use for When We Want to Stop with Humans!!!   
	#    if stop == True:
	#    	break;

	    if key == 27: #esc key stops the process
	        break;

	# Save the last frame detected to a JPEG file
	name = "Last_Frame.jpg"
	cv2.imwrite(name, frame)


	cap.release() 
	cv2.destroyAllWindows()

    return True
    # Only Use for When We Want to Stop with Humans!!!  
    #return stop
    
    
    
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
            global vehicle
            vehicle = connect(connectionString, wait_ready = True, timeout = 90)
            #arm_n_takeoff(3.05 , vehicle)

        else:
            print("INVALID!")
            return render_template("index.html", flash_message = False, SelectedPort = SelectedPort)

        return render_template("index.html", flash_message = True, SelectedPort = SelectedPort, Battery = vehicle.battery.level\
            , Port = request.form.get("PortNumber"), location = vehicle.location.global_relative_frame, \
            lat = float(vehicle.location.global_frame.lat), lng = float(vehicle.location.global_frame.lon))

    return render_template("index.html", flash_message = False, SelectedPort = 0)

#sends the coordinates to back end
@app.route('/searchStarter')
def searchStarter():
    data = request.get_json
    UserInputCoordinates = [(float(request.args.get('coor1LAT')), float(request.args.get('coor1LNG'))),\
                            (float(request.args.get('coor2LAT')), float(request.args.get('coor2LNG'))),\
                            (float(request.args.get('coor3LAT')), float(request.args.get('coor3LNG'))),\
                            (float(request.args.get('coor4LAT')), float(request.args.get('coor4LNG')))]
                            
    print("Coordinates 1(LAT,LNG): "+ str(UserInputCoordinates[0]))
    print("Coordinates 2(LAT,LNG): "+ str(UserInputCoordinates[1]))
    print("Coordinates 3(LAT,LNG): "+ str(UserInputCoordinates[2]))
    print("Coordinates 4(LAT,LNG): "+ str(UserInputCoordinates[3]))
    global coordinates
    search(UserInputCoordinates)
    return ('hi')

#gets telemetry data to update UI
@app.route('/telemetryInfo')
def telemetryInfo():
    data = request.get_json
    global vehicle
    voltage = vehicle.battery.voltage
    current = vehicle.battery.current
    Battery = vehicle.battery.level
    gps = vehicle.gps_0
    velocity = vehicle.airspeed / 0.44704

    #thinking about this
    Location = vehicle.location.global_relative_frame
    lon = vehicle.location.global_frame.lon
    lat = vehicle.location.global_frame.lat
    sender = {'currentLocation': str(Location) ,'batteryLeft': str(Battery), 'currVoltage':str(voltage), 'currCurrent' : str(current), \
               'vGPS': str(gps), 'currVelocity': str(velocity), 'longitude': float(lon), 'latitude':float(lat) }
    return (sender)

@app.route('/emergencyLander')
def emergencyLander():
    global emergencyLand
    emergencyLand = True
    land()

@app.route('/RTLLand')
def RTLLand():
    global emergencyLand
    emergencyLand = False
    land()


if __name__ == "__main__":
    #vehicle = connect('tcp:127.0.0.1:5760', wait_ready=True)
    app.run(debug = True,threaded=True)
