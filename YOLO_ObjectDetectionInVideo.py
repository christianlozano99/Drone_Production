
import cv2, time
import numpy as np


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


if __name__ == '__main__':
	CV_Model()