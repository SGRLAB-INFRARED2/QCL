function out = isLaserConnected()

isConnected = false; 
isConnectedPtr = libpointer('bool', isConnected); 
calllib('MIRcatSDK','MIRcatSDK_IsConnectedToLaser', isConnectedPtr); 
isConnected = isConnectedPtr.value;

out = isConnected;

end
