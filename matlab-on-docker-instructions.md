# using matlab installed via docker

## run a web version

```bash
# run matlab docker as web ui mode
# if the license server is mathworks.win.canberra.edu.au
# change the license server name accordingly
docker run -it --rm --network host -e MLM_LICENSE_FILE=27000@mathworks.win.canberra.edu.au --shm-size=512M mathworks/matlab:r2022b -browser

# find the service at localhost:8888
```

## run as a system tool (on start-up)

```bash
# create
docker run -d --restart unless-stopped --name matlab-r2022b-web --network host -e MLM_LICENSE_FILE=27000@mathworks.win.canberra.edu.au --shm-size=512M mathworks/matlab:r2022b -browser

# create with a mapped volume
docker run -d --restart unless-stopped --name matlab-r2022b-web -v /home/student/fr2023/matlab:/home/matlab/Documents/MATLAB --network host -e MLM_LICENSE_FILE=27000@mathworks.win.canberra.edu.au --shm-size=512M mathworks/matlab:r2022b -browser

# find the service at localhost:8888

# stop
docker stop matlab-r2022b-web

# restart
docker start matlab-r2022b-web
```

```bash
# install extra toolboxes inside the container
wget https://www.mathworks.com/mpm/glnxa64/mpm
chmod +x mpm
sudo ./mpm install --release=R2022b --destination=/opt/matlab/R2022b/ --products ROS_Toolbox
```

```bash
# update python
sudo apt update
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

wget https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz
tar -xf Python-3.9.13.tgz

cd Python-3.9.13
./configure --enable-optimizations

make
sudo make altinstall

# use this python for the rostoolbox config
```