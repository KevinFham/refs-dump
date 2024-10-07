# InstantNGP Docker Container

### Original Repository

https://github.com/NVlabs/instant-ngp

### Build and Run

```sh
sudo docker build -t kevin:instant-ngp .

xhost +local:docker
sudo docker run -it --name instant-ngp --gpus all --privileged --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kevin:instant-ngp
```
