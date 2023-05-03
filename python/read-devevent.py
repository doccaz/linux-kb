import struct 
f = open( "/dev/input/event20", "rb" ); # Open the file in the read-binary mode
while 1:
  data = f.read(24)
  print struct.unpack('4IHHI',data)
  ###### PRINT FORMAL = ( Time Stamp_INT , 0 , Time Stamp_DEC , 0 , 
  ######   type , code ( key pressed ) , value (press/release) )

