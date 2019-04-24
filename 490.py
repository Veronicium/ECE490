from mpl_toolkits.mplot3d import Axes3D 
import numpy as np 
import matplotlib.pyplot as plt 
from numpy import *

def f(x,y):
	return x * x * x + y * y * y

def g_funx(x): 
	return 3 * x * x

def g_funy(y): 
	return 3 * y * y

def gd(x_start,y_start,step,g_funx,g_funy): 
	x = x_start 
	y = y_start 
	lambde = 20
	rou = -0.1
	print('leran rate ',step,'init x',x_start,'init y',y_start, 'rou', rou, 'lambde', lambde) 

	for i in range(10000):

		if i % lambde == 0:    			#lamde次进行随机跳跃
			gradx = g_funx(x)
			grady = g_funy(y)
			if gradx < 1e-3 and grady < 1e-3: #如果梯度小于1e-3随机跳跃

				x -= gradx * step - rou
				y -= grady * step - rou
			else:							#其他情况不跳跃
				x -= gradx * step
				y -= grady * step
		else:							#其他情况不跳跃
			gradx = g_funx(x)
			x -= gradx * step
			grady = g_funy(y)
			y -= grady * step

		g_gdx.append(gradx)
		g_gdy.append(grady)
		tx.append(x)
		ty.append(y)
		cost.append(x**3+y**3)
		# if abs(gradx) < 1e-4:
		# 	break;
		# if abs(grady) < 1e-4:
		# 	break;
		if x < -2:						#如果x，y小于-2证明随机梯度下降成功
			break;
		if y < -2:
			break;
	print('[ Epoch = ] ',i,'gradx =',gradx,'grady =',grady,'x=',x,'y=',y)
	return i, gradx, grady, x, y

# show_grad_result(4,2,0.01)
if __name__ == "__main__":
	epoch = []
	initx1 = []
	inity1 = []
	tx_sum = []
	ty_sum = []
	cost_sum = []
	for j in range(100):						#一百次实验
		initx = 2 * np.random.rand() + 2
		inity = 2 * np.random.rand() + 2		#初始点在【2，4】之间任意一点
		tx = [] 
		ty = [] 
		g_gdx = [] 
		g_gdy = []
		cost = []
		i = gd(initx, inity, 0.01, g_funx, g_funy)
		initx1.append(initx)
		inity1.append(inity)
		epoch.append(i[0])
		tx_sum.append(tx)
		ty_sum.append(ty)
		cost_sum.append(cost)
	min_n = epoch.index(min(epoch))
	min_nn = min(epoch)								#最小的迭代次数
	print('epoch:', min(epoch), 'initx:', initx1[min_n],'inity:', inity1[min_n], 'min_n:', min_n,
	'tx:', tx_sum[min_n][min_nn], 'ty:', ty_sum[min_n][min_nn])
	fig = plt.figure()								#画图和数据输出
	ax = Axes3D(fig)
	x1 = np.arange(-4, 4, 0.1)
	y1 = np.arange(-4, 4, 0.1)
	x1, y1 = np.meshgrid(x1, y1)
	R = x1**3 + y1**3
	ax.plot_surface(x1, y1, R, rstride=1, cstride=1, cmap=plt.get_cmap('rainbow'))
	ax.scatter(tx_sum[min_n][0], ty_sum[min_n][0], zs=cost_sum[min_n][0], s=50, c='r')
	ax.plot(tx_sum[min_n], ty_sum[min_n], zs=cost_sum[min_n], zdir='z', c='r', lw=3)
	# plt.annotate('start_point', xyz = (tx_sum[min_n][0], ty_sum[min_n][0], ), xyztext=(1, 1, 1), arrowprops=dict(facecolor='black', shrink=0.05))
	T1 = f(tx_sum[min_n][0], ty_sum[min_n][0])
	T2 = f(tx_sum[min_n][min_nn], ty_sum[min_n][min_nn])
	ax.text(initx1[min_n], inity1[min_n], T1, 'start_point(%f,%f)'%(initx1[min_n], inity1[min_n]))
	ax.text(tx_sum[min_n][min_nn], ty_sum[min_n][min_nn], T2, 'end_point(%f,%f)'%(tx_sum[min_n][min_nn], ty_sum[min_n][min_nn]))
	plt.show()
