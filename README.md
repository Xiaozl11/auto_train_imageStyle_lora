# 基于[clip-interrogator](https://github.com/pharmapsychotic/clip-interrogator)和[lora-scripts](https://github.com/Akegarasu/lora-scripts)自动训练lora模型
**主要内容：**<br>
1. clip可以将图片生成文字，可作为lora训练的tags。
2. 使用lora-scripts训练，可以得到一个xxx.safetensorts模型。
3. 使用[A绘世启动器](https://www.bilibili.com/video/BV1iM4y1y7oA/?vd_source=aff9c338513223443fc027291d49b572)生成图片。
   
**准备工作：**<br>
1. 需要一个大模型，比如[stable-diffusion-v1-5](https://huggingface.co/runwayml/stable-diffusion-v1-5), 下载v1-5-pruned.ckpt，需要开魔法。<br>
2. 将模型放置auto_train/lora-scripts/sd-models路径下<br>
3. lora-scripts/train中是需要训练的图片。需要注意的是，比如存放图片和标签的图片文件夹的名称是‘cats’,则构建一个目录lora-scripts/cats/6_cats/xxx.png。前面一定要有数字，在5-8之间，代表重复次数。<br>
4. 安装环境：
    ```
    # 建议在虚拟环境中运行。install.bash文件会创建一个名为 "xiao" 的虚拟环境
    apt install -y python3.10-venv
    bash install.bash
    ```
5. clip部分参考[clip-README](https://github.com/Xiaozl11/clip/blob/main/README.md)配置好即可。

**程序运行：**<br>
切换到auto_train/clip-interrogator目录下，运行start.sh脚本<br>
  ```
  bash start.sh  $pic_name $model_name $batch $epoches
  # $pic_name ： 训练图片的文件夹名字
  # $model_name ： 大模型名称，即放在sd-models文件夹中的模型名字
  # $batch ： 一批样本 
  # $epoches ： 训练轮数
  # 例如以下命令
  bash start.sh cat v1-5-pruned.ckpt 2 20
  # 训练好的模型会在/lora-scripts/output路径下。
  ```

**其他**<br>
[clip-README](https://github.com/pharmapsychotic/clip-interrogator/blob/main/README.md)<br>
[lora-scripts-README](https://github.com/Akegarasu/lora-scripts/blob/main/README-zh.md)<br>
