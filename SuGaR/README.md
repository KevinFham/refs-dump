# SuGaR Docker Container

### Original Repository

https://github.com/Anttwo/SuGaR

### Build and Run
```sh
sudo docker build -t kevin:sugar .

xhost +local:docker
sudo docker run -it --name sugar --gpus all --privileged --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kevin:sugar
```
