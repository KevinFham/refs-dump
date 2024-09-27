# SuGaR Docker Container

```sh
sudo docker build -t kevin:sugar .
sudo docker run -it --name sugar --gpus all --privileged --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kevin:sugar
```
