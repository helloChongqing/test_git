#! /bin/bash

#第一部分，如果用户反悔可以直接退出
clear
echo -e "\033[32m ####### 此脚本用于安装prometheus ####### \033[0m"
echo -e "\033[32m >>>>> 如果不想安装，可直接 'ctrl+c' 退出 <<<<< \033[0m"
sleep 3

#第二部分开始
clear

echo -e "\035[32m ####### 正在进行安装前检测 ####### \033[0m"

prometheus_source_dir=~/prometheus/prometheus.source/
prometheus_install_dir=~/prometheus/
systemctl stop firewalld && systemctl disable firewalld
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
mkdir -p ${prometheus_source_dir}

#检测是否有wget，没有的话就安装，安装不了就直接用curl
wget_check=$(rpm -qa wget | wc -l)
if [ ${wget_check} -eq 0 ];then
   yum -y install wget &>/dev/null;
   if [ $? -ne 0 ];then
      read -p "请输入你所需要安装的Prometheus版本（x.xx.x）:  " prometheus_version
      echo ">>>>> 开始下载源码 <<<<<"
      sleep 3
      cd ${prometheus_source_dir} && curl -O  https://mirrors.tuna.tsinghua.edu.cn/github-release/prometheus/prometheus/2.51.1%20_%202024-03-27/prometheus-${prometheus_version}.linux-amd64.tar.gz
         if [ $? -ne 0 ];then
            echo "下载源码失败，请检查是否是输入的版本号有问题，检查完毕再重试" && exit
         fi
      echo ">>>>> 正在安装Prometheus${prometheus_version}版本 <<<<<"
      tar -zxvf ${prometheus_source_dir}prometheus-${prometheus_version}.linux-amd64.tar.gz -C ${prometheus_install_dir}
      cd ${prometheus_install_dir}prometheus-${prometheus_version}.linux-amd64
      ./prometheus &
      ss -ltpn | grep 9090 && echo "安装成功" || echo "安装失败，请检查后重试"

      #如果能安装wget的话就会执行这一段
   else
      read -p "请输入你所需要安装的Prometheus版本（x.xx.x）:  " prometheus_version
      echo ">>>>> 开始下载源码 <<<<<"
      sleep 3
      cd ${prometheus_source_dir} && wget https://mirrors.tuna.tsinghua.edu.cn/github-release/prometheus/prometheus/2.51.1%20_%202024-03-27/prometheus-${prometheus_version}.linux-amd64.tar.gz
         if [ $? -ne 0 ];then
            echo "下载源码失败，请检查是否是输入的版本号有问题，检查完毕再重试" && exit
         fi
      echo ">>>>> 正在安装Prometheus${prometheus_version}版本 <<<<<"
      tar -zxvf ${prometheus_source_dir}prometheus-${prometheus_version}.linux-amd64.tar.gz -C ${prometheus_install_dir}
      cd ${prometheus_install_dir}prometheus-${prometheus_version}.linux-amd64
      ./prometheus &
      ss -ltpn | grep 9090 && echo "安装成功" || echo "安装失败，请检查后重试"
   fi
   #如果安装了wget的话就直接执行这里
else
   read -p "请输入你所需要安装的Prometheus版本（x.xx.x）:  " prometheus_version
   echo ">>>>> 开始下载源码 <<<<<"
   sleep 3
   cd ${prometheus_source_dir} && wget https://mirrors.tuna.tsinghua.edu.cn/github-release/prometheus/prometheus/2.51.1%20_%202024-03-27/prometheus-${prometheus_version}.linux-amd64.tar.gz
      if [ $? -ne 0 ];then
         echo "下载源码失败，请检查是否是输入的版本号有问题，检查完毕再重试" && exit
      fi
   echo ">>>>> 正在安装Prometheus${prometheus_version}版本 <<<<<"
   tar -zxvf ${prometheus_source_dir}prometheus-${prometheus_version}.linux-amd64.tar.gz -C ${prometheus_install_dir}
   cd ${prometheus_install_dir}prometheus-${prometheus_version}.linux-amd64
   ./prometheus &
   ss -ltpn | grep 9090 && echo "安装成功" || echo "安装失败，请检查后重试"
fi   
