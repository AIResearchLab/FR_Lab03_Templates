# FR_Lab03_Templates

Foundations of Robotics Lab 3 and final project matlab resources

## install image processing toolbox using mpm

the source requires the image processing toolbox

```bash
# install extra toolboxes inside the container
wget https://www.mathworks.com/mpm/glnxa64/mpm
chmod +x mpm
sudo ./mpm install --release=R2022b --destination=/opt/matlab/R2022b/ --products Image_Processing_Toolbox
```
