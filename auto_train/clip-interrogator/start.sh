#!/bin/bash

floder_name=$PIC_NAME
model_name=$MODEL
batch=$BATCH_SIZE
epoches=$MAX_EPOCHES
output_name=$floder_name

python3 x_run_cli.py --folder ./pic_folder/$floder_name
echo "### run is done ###"
# read
cp -rf pic_folder/$floder_name ../lora-scripts/train/pic #dog
cd ../lora-scripts/train/pic # 进入目录
if [ -d "./7_$floder_name" ]; then
   # echo "delect 7_$floder_name"
   rm -rf ./7_$floder_name
fi
mv -f $floder_name 7_$floder_name
echo "### rename is done ###"

cd ../..
source xiao/bin/activate # 进入虚拟环境 
# echo "######$model_name $batch $epoches $output_name######"
bash train_args.sh $model_name $batch $epoches $output_name
echo "### train is done ###"