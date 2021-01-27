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

大致来说就是，先让一个人看一个张图片，然后检测那个人人脑的MRI活动，然后通过特征解码的到深度神经网络的输出，然后通过这些特征对图片进行重建，实验效果不是特别理想，但是万一实现确实是非常酷的想法，这样一来就相当于有了读心术.检测fmri相当于检测人脑的哪一部分细胞正在消耗氧气，用于检测哪块脑区处于活跃状态。用于重建图像的神经网络还是dnn,但是输入的图像是一批志愿者在看到图像之后，将其观察图片时的MRI值记录下来，通过特征解码器来获得神经网络的特征值，从MRI的特征值转换到神经网络的特征值。其实在这里初始图像就已经是一个噪声图像了（feature作为deep generator network的输出所生成的图片）

对于复杂图片的输入，重建后得到的图片可以达到人眼可以识别形状的程度，但是和原图片的差距还是比较大的。

但是对于简单的输入，如英文字母和算术符号之类的简单字符，还原之后的基本形状还是得以保留。然后研究团队进一步研究，让参与试验的志愿者常识去想象字符的形状，然后通过网络去重建图像，效果比看见图像相比可识别性显著下降。（人类回忆或者说冥想是不能记住每一个像素值的，而仅仅是记录一个图像的主要特征）