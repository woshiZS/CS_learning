### Summarization of Machine Vision Course

#### Introduction

* Mainly in 4 most commonly applications: measurement(about to measurement is or not in specific tolerance, automate the process and more quickly and precisely ), counting(not only the amount but also the presence and absence), location(locate and orientation, if an angle is correct, find a unique pattern a location), decoding(refers to 1D and 2D symbologies. Like OCR and etc).

#### Rectification of stero pairs(立体像对的修正算法)

* 基本来说就是对照相机进行旋转，PPMs新的位置和之前的相机位置摆放的时候是一样的，但是经过合适旋转之后相机的朝向和原来不一样，固有参数保持不变，由此，新的PPM不同只在于他们的光源位置有差别，但是算法在光轴he基准线平行的时候会失效。

#### ImageNet

大致就是图像分类网络，

#### Reinforcement Learning with Augment Data

数据增强是监督学习中很常见的一种方式，对数据图像进行微小扰动，对数据进行微小污染（一些小的变化），是的到的信息更加可靠。

强化学习也是一样，使用数据来增强，灰度，裁剪颜色，旋转等等的方式。只要使数据大致上是原料的样子即可。要在有验证和训练的时候都采用数据增强的方法。是一种经典的策略优化方法，Proximal Policy Optimization。 ，是一种最先进的用于学习连续或者离散的方法。

结果这种增强的学习方法比许多其他增强学习的benchmark都要好。在这些数据增强里面收益最高的方式是crop（裁剪）加rotate （旋转） ，通过图像经过不同强化处理之后的表现，发现每次crop操作之后，图像数据中最为重要的部分，在该篇论文的数据中，是小人的躯干部分，因为躯干部分和地面的角度是影响小人平衡最主要的因素，从而影响到小人的行走。

但是crop（裁剪）本身可能并没有这种功效，只是恰好crop之后得到的结果，让输入变得更好（可能依赖于训练数据的形式），总之也不能草率的判定使用crop就可以更好的突出图像的重点这一结论。

在强化学习的泛化实验的中，我们使用某种已知游戏的策略取指导另一种相似但是未知的游戏操作，在众多数据增强的方法中，crop和cutout-color得到的分数最高。 但是未知游戏的种类进行变化的时，表现结果并不总是数据增强方法表现得更好，在某些游戏中，甚至原始的PPO表现水平是最高的。训练的结果更多的依赖于我们设置RL的方式。所以该篇论文中得到结论是存在一些问题的。

#### Deep image reconstruction from human brain activity

It will have a human look at a picture, it will measure the MRI activity

