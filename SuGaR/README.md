# SuGaR Docker Container

### Original Repository

https://github.com/Anttwo/SuGaR

## Build and Run

First, provide access to your gpu during docker build: ([How to `docker build` with nvidia runtime](https://stackoverflow.com/a/61737404))

Then, build the container

```sh
sudo docker build -t kevin:sugar .

# Run the container w/ access to your display
xhost +local:docker
sudo docker run -it --name sugar --gpus all --privileged --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kevin:sugar
```

#### If `Error response from daemon: could not select device driver "" with capabilities: [[gpu]]` 

([Issue](https://forums.developer.nvidia.com/t/could-not-select-device-driver-with-capabilities-gpu/80200))

```sh
sudo apt install nvidia-container-toolkit
systemctl restart docker
```

## Commandline Run Example
```sh
ffmpeg -i ../Waterbottle.MOV -qscale:v 1 -qmin 1 -vf fps=2 %04d.jpg
python3 gaussian_splatting/convert.py -s data/waterbottle
python3 gaussian_splatting/train.py -s data/waterbottle/ --iterations 7000 -m output/waterbottle/
python3 train.py -s data/waterbottle -c output/waterbottle/ --refinement_time short -r <"dn_consistency" or "sdf">
```

Have not tested `dn_consistency` yet, but supposedly better. Altering `--refinement_time` has not had much impact in my experiments.

