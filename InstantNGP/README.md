# InstantNGP Docker Container

### Original Repository

https://github.com/NVlabs/instant-ngp

### Build and Run

```sh
sudo docker build -t kevin:instant-ngp .
sudo docker run -it --name sugar --gpus all --privileged --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kevin:instant-ngp
```
