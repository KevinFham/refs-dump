# InstantNGP Docker Container

### Original Repository

https://github.com/NVlabs/instant-ngp

## Build and Run

First, provide access to your gpu during docker build: ([How to `docker build` with nvidia runtime](https://stackoverflow.com/a/61737404))

Then, build the container

```sh
sudo docker build -t kevin:instant-ngp .

xhost +local:docker
sudo docker run -it --name instant-ngp --gpus all --privileged --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kevin:instant-ngp
```

#### If `Error response from daemon: could not select device driver "" with capabilities: [[gpu]]` 

([Issue](https://forums.developer.nvidia.com/t/could-not-select-device-driver-with-capabilities-gpu/80200))

```sh
sudo apt install nvidia-container-toolkit
systemctl restart docker
```
