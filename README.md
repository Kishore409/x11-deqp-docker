# Run DEQP tests on X11 setup on a container

# Setup & build the Docker
  1) clone the source
  2) Set proxy and update id_rsa
  3) sudo docker build -t "deqp" 

# Run the docker
1) sudo -E xhost +local:root; sudo -E docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev -it --rm deqp:latest
2) Once you get Shell:
   cd /root/workspace/deqp/build/modules
   run the deqp tests


