addpath('E:\程序\自己修改程序备份\自己修改\动作识别cuboids_Apr19_2006\stfeatures')

%% draw bend
clear all,close all
load('E:\程序\自己修改程序备份\自己修改\动作识别cuboids_Apr19_2006\set00\clip_bend008.mat');
load('E:\程序\自己修改程序备份\自己修改\动作识别cuboids_Apr19_2006\set00\cuboids_bend008.mat');
cuboid_display_stv( I, [8 8 12], subs(1:15,:) )


%% draw walk
clear all,close all
load('E:\程序\动作识别cuboids_Apr19_2006\新建文件夹\set02\clip_walk007.mat')
load('E:\程序\动作识别cuboids_Apr19_2006\新建文件夹\set02\cuboids_walk007.mat')
cuboid_display_stv( I, [8 8 12], subs(1:15,:) )
set(0,'defaultfigurecolor','w')