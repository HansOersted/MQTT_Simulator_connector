# MQTT Simulator Connector in Ubuntu

&emsp;&emsp;This repo shows an example of a Simulink subscribing MQTT.  
&emsp;&emsp;The data subscribed is later processed as the altitude reference for a UAV to track.  

&emsp;&emsp;It is adviced to follow the other repository subscribing communicating with MQTT in m file.  
  
&emsp;&emsp;Interestingly, up to January 21, 2025, the OPC UA block in Simulator is not designed for Linux. One cannot use an exist block in Simulink to subscribe the OPC UA signal directly.  

&emsp;&emsp;Therefore, a global variable is defined in m file where it is being updated and being fed the Simulink in real-time.  
<br>

&emsp;&emsp;The final output is demonstrated in the following video.  

<br>

[Screencast from 01-20-2025 10:58:01 PM.webm](https://github.com/user-attachments/assets/c9517d8e-3ab3-49d1-897e-3e3f16473c4f)

<br>

## Section 1. Define the global variable.

&emsp;&emsp;In the m file, we define a global variable, global `reference`. This global variable `reference` will be updated in the m file.  

<br>

## Section 2. Subscribe the interested topic.  

&emsp;&emsp;Similar to the prior example, we subscribe data, `Actual_diameter` from proveit.  

```
mqttClient = mqttclient('tcp://127.0.0.1');

subscribe(mqttClient, 'opcua/data', 'Callback', @(topic, data_string) handleMessage(data_string));  
```

&emsp;&emsp;For detail, we refer to the prior repo.

<br>

## Section 3. Update the global variable.  

&emsp;&emsp;`reference` is updated in the callback function `handleMessage(data_string)`.  

```
function handleMessage(data_string)
    global reference;
    reference = str2double(data_string);
    assignin('base', 'reference', reference);
end
```

&emsp;&emsp;Everytime a message is received, `reference` will be updated for our further use (in Simulink).


<br>

## Section 4. Feed the simulator with the global `reference`.  

&emsp;&emsp;In our designation, Simulink is being updated with the latest value of `reference` in real-time. Therefore, theSimulator has the latest information about the data from MQTT.

<br>

## Section 5. Process the reference and setup a UAV tracking problem.  

&emsp;&emsp;The UAV is initially positioned at `0` altitude. And it is desired to track `reference/200` in real-time.  

&emsp;&emsp;The figure below demonstrates the history of `reference/200`. Note that the value changes over time due to the change of the subscribing `Actual_diameter` from proveit.  

<br>

![image](https://github.com/user-attachments/assets/5c9f344b-aa93-453b-a3b1-566388f24b2a)

<br>

## Section 6. UAV controller.  

&emsp;&emsp;A UAV altitude controller is designed to track the desired altitude, `reference/200`. It is a simple PD controller without feedforward signal.  

&emsp;&emsp;The actual trajectory (tracking result) of the UAV is plotted below.  

<br>

![image](https://github.com/user-attachments/assets/53033f21-3bc9-4ba9-8d49-252254fe5671)   

<br>

&emsp;&emsp;It can be observed that the UAV tracks `reference/200` well.

&emsp;&emsp;Note that the parameters can be tuned for better tracking performance. But it is not the focus in this repo. The interested players are encouraged to tune the controller, e.g., change the values of `Kp = 5;` and `Kd = 2;` in the m file.  

<br>

## Section 7. UAV Annimation.  

&emsp;&emsp;The annimation of the UAV is being played in real time with the Simulink block. 


