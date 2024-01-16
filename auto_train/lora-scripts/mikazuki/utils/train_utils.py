import glob
import os
import re
import shutil
import sys

from mikazuki.log import log

python_bin = sys.executable


def is_promopt_like(s):
    for p in ["--n", "--s", "--l", "--d"]:
        if p in s:
            return True
    return False


def validate_model(model_name: str):
    if os.path.exists(model_name):
        return True

    # huggerface model repo
    if model_name.count("/") <= 1:
        return True

    return False


def validate_data_dir(path):
    if not os.path.exists(path):
        log.error(f"Data dir {path} not exists, check your params")
        return False

    dir_content = os.listdir(path)

    if len(dir_content) == 0:
        log.error(f"Data dir {path} is empty, check your params")

    subdirs = [f for f in dir_content if os.path.isdir(os.path.join(path, f))]

    if len(subdirs) == 0:
        log.warn(f"No subdir found in data dir")

    ok_dir = [d for d in subdirs if re.findall(r"^\d+_.+", d)]

    if len(ok_dir) == 0:
        log.warning(f"No leagal dataset found. Try find avaliable images")
        imgs = get_total_images(path, False)
        captions = glob.glob(path + '/*.txt')
        log.info(f"{len(imgs)} images found, {len(captions)} captions found")
        if len(imgs) > 0:
            num_repeat = suggest_num_repeat(len(imgs))
            dataset_path = os.path.join(path, f"{num_repeat}_zkz")
            os.makedirs(dataset_path)
            for i in imgs:
                shutil.move(i, dataset_path)
            if len(captions) > 0:
                for c in captions:
                    shutil.move(c, dataset_path)
            log.info(f"Auto dataset created {dataset_path}")
        else:
            log.error("No image found in data dir")
            return False

    return True


def suggest_num_repeat(img_count):
    if img_count <= 10:
        return 7
    elif 10 < img_count <= 50:
        return 5
    elif 50 < img_count <= 100:
        return 3

    return 1


def check_training_params(data):
    potential_path = [
        "train_data_dir", "reg_data_dir", "output_dir"
    ]
    file_paths = [
        "sample_prompts"
    ]
    for p in potential_path:
        if p in data and not os.path.exists(data[p]):
            return False

    for f in file_paths:
        if f in data and not os.path.exists(data[f]):
            return False
    return True


def get_total_images(path, recursive=True):
    if recursive:
        image_files = glob.glob(path + '/**/*.jpg', recursive=True)
        image_files += glob.glob(path + '/**/*.jpeg', recursive=True)
        image_files += glob.glob(path + '/**/*.png', recursive=True)
    else:
        image_files = glob.glob(path + '/*.jpg')
        image_files += glob.glob(path + '/*.jpeg')
        image_files += glob.glob(path + '/*.png')
    return image_files
