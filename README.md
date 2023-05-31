本代码实现自动图片分类以及全景图像拼接
在运行此代码时需要在matlab中配置python环境，python环境中应包括OpenCV的安装
全景图像拼接直接运行autostitch.m即可，图片素材存放在all1文件夹之中
makeclass.m为分类代码
CalcH.m 利用RANSAC算法计算单应矩阵
pystitch.m为在matlab中利用python进行混编的代码 
main.py 为python用于拼接图像的代码 
draw.m为绘制连线图的代码，需要findH的支持。如果仅作分类与拼接 可以忽略

实验环境
matlab 2023a 版本必须大于2022b 否则会存在部分函数不支持的情况
python 3.8
OpenCV 4.7