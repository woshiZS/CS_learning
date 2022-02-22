from ctypes import resize
import time
import itertools
import random
import sys

import numpy as np
from PIL import Image
from PIL import ImageFile
from skimage import img_as_float
from skimage.metrics import mean_squared_error

def shuffle_first_items(lst, i):
    if not i:
        return lst
    first_few = lst[:i]
    remaining = lst[i:]
    random.shuffle(first_few)
    return first_few + remaining

def bound(low, high, value):
    return max(low, min(high, value))

class ProgressCounter:
    def __init__(self, total):
        self.total = total
        self.counter = 0

    def update(self):
        self.counter += 1
        sys.stdout.write("Progress: %s%% %s" % (100 * self.counter / self.total, "\r"))
        sys.stdout.flush()

def img_mse(im1, im2):
    """Calculates the root mean square error between two images"""
    try:
        return mean_squared_error(img_as_float(im1), img_as_float(im2))
    except ValueError:
        print(f'RMS issue, Img1: {im1.size[0]} {im1.size[1]}, Img2: {im2.size[0]} {im2.size[1]}')
        raise KeyboardInterrupt

def resize_box_aspect_crop_to_extent(img, target_aspect, centerpoint=None):
    width = img.size[0]
    height = img.size[1]
    if not centerpoint:
        centerpoint =(int(width / 2), int(height / 2))
    requested_target_x = centerpoint[0]
    requested_target_y = centerpoint[1]
    aspect = width / float(height)
    if aspect > target_aspect:
        # Then crop the left and right edges:
        new_width = int(target_aspect * height)
        new_width_half = int(new_width / 2)
        target_x = bound(new_width_half, width - new_width_half, requested_target_x)
        left = target_x - new_width_half
        right = target_x + new_width_half
        resize = (left, 0, right, height)
    else:
        # ... crop the top and bottom 
        new_height = int(width/ target_aspect)
        new_height_half = int(new_height / 2)
        target_y = bound(new_height_half, height - new_height_half, requested_target_y)
        top = target_y - new_height_half
        bottom = target_y + new_height_half
        resize = (0, top, width, bottom)
    return resize

def aspect_crop_to_extent(img, target_aspect, centerpoint=None):
    '''
    调整图片到参数给定的比例
    '''
    resize = resize_box_aspect_crop_to_extent(img, target_aspect, centerpoint)
    return img.crop(resize)

class Config:
    def __init__(self, tile_ratio = 1920/800, tile_width = 50, enlargement = 8, color_mode = 'RGB'):
        self.tile_ratio = tile_ratio # 2.4
        self.tile_width = tile_width # height/width of mosaic tiles in pixels
        self.enlargement = enlargement # mosaic image will be this many times wider and taller than original
        self.color_mode = color_mode # mosaic image will be this many times wider and taller than original

    @property
    def tile_height(self):
        return int(self.tile_width / self.tile_ratio)

    @property
    def tile_size(self):
        return self.tile_width, self.tile_height # PIL expects (width, height)


class TileBox:
    """
    读取以及搜索匹配用于填充的图片
    """
    def __init__(self, tile_paths, config):
        self.config = config
        self.tiles = list()
        self.prepare_tiles_from_paths(tile_paths)

    def __process_tile(self, tile_path):
        with Image.open(tile_path) as i:
            img = i.copy()
        img = aspect_crop_to_extent(img, self.config.tile_ratio)
        large_tile_img = img.resize(self.config.tile_size, Image.ANTIALIAS).convert(self.config.color_mode)
        self.tiles.append(large_tile_img)
        return True

    def prepare_tiles_from_paths(self, tile_paths):
        print('Reading tiles from provided list...')
        progress = ProgressCounter(len(tile_paths))
        for tile_path in tile_paths:
            self.__process_tile(tile_path)
            progress.update()
        print('Processed tiles.')
        return True

    def best_tile_block_match(self, tile_block_original):
        match_results = [img_mse(t, tile_block_original) for t in self.tiles]
        best_fit_tile_index = np.argmin(match_results)
        return best_fit_tile_index
    def best_tile_from_block(self, tile_block_original, reuse = False):
        if not self.tiles:
            print('Ran out of images.')
            raise KeyboardInterrupt

        i = self.best_tile_block_match(tile_block_original)
        match = self.tiles[i].copy()
        if not reuse:
            del self.tiles[i]
        return match


class SourceImage:
    """Processing original image - scaling and cropping as needed"""
    def __init__(self, image_path, config):
        print('Processing main image...')
        self.image_path = image_path
        self.config = config

        with Image.open(self.image_path) as i:
            img = i.copy()
        # 按照给定参数放大原图，提高比较的粒度
        w = img.size[0] * self.config.enlargement
        h = img.size[1] * self.config.enlargement
        large_img = img.resize((w, h), Image.ANTIALIAS)
        w_diff = (w % self.config.tile_width) / 2
        h_diff = (h % self.config.tile_height) / 2

        # 调整原图为tile的整数倍
        if w_diff or h_diff:
            large_img = large_img.crop((w_diff, h_diff, w - w_diff, h - h_diff))

        self.image = large_img.convert(self.config.color_mode)
        print('Main image processed.')


class MosaicImage:
    """Holder for the mosaic"""
    def __init__(self, original_img_copy, target, config):
        self.config = config
        self.target = target
        self.image = original_img_copy
        self.x_tile_count = int(original_img_copy.size[0] / self.config.tile_width)
        self.y_tile_count = int(original_img_copy.size[1] / self.config.tile_height)
        self.total_tiles = self.x_tile_count * self.y_tile_count
        print(f'Mosaic will be {self.x_tile_count:,} tiles wide and {self.y_tile_count:,} tiles high ({self.total_tiles:,} total).')

    def add_tile(self, tile, coords):
        """Add the provided image onto the mosaic at the provided coords."""
        try:
            self.image.paste(tile, coords)
        except TypeError as e:
            print('Maybe the tiles are not the right size. ' + str(e))

    def save(self):
        self.image.save(self.target)

def coords_from_middle(x_count, y_count, y_bias = 1, shuffle_first = 0):
    '''
    从中心区域开始填充
    '''
    x_mid = int(x_count / 2)
    y_mid = int(y_count / 2)
    coords = list(itertools.product(range(x_count), range(y_count)))
    coords.sort(key=lambda coordinate: abs(coordinate[0] - x_mid) * y_bias + abs(coordinate[1] - y_mid))
    coords = shuffle_first_items(coords, shuffle_first)
    return coords

def create_mosaic(source_path, target, tile_ratio = 1920/800, tile_width = 75, enlargement = 8, reuse = True, color_mode = 'RGB', tile_paths = None, shuffle_first = 30):
    # 避免图片太大，取消PIL的设定上限
    ImageFile.LOAD_TRUNCATED_IMAGES = True
    Image.MAX_IMAGE_PIXELS = None
    config = Config(
        tile_ratio = tile_ratio,        # height/width of mosaic tiles in pixels
        tile_width = tile_width,        # height/width of mosaic tiles in pixels
        enlargement = enlargement,      # the mosaic image will be this many times wider and taller than the original 
        color_mode = color_mode         # L for greyscale or RGB for color
    )
    # Pull in and Process Original Image
    print('Setting up targe image')
    source_image = SourceImage(source_path, config)

    # Setup mosaic
    mosaic = MosaicImage(source_image.image, target, config)


    # Asset Tiles, and save if needed, returns where the small and large pictures are stored
    print('Assessing Tiles')
    tile_box = TileBox(tile_paths, config)

    try:
        progress = ProgressCounter(mosaic.total_tiles)
        coords = coords_from_middle(mosaic.x_tile_count, mosaic.y_tile_count, y_bias = config.tile_ratio, shuffle_first = shuffle_first)
        for x,y in coords:

            # Make a box for this sector
            box_crop = (x * config.tile_width, y * config.tile_height, (x + 1) * config.tile_width, (y + 1) * config.tile_height)

            # Get origial Image Data for this Sector
            comparison_block = source_image.image.crop(box_crop)

            # Get Best Image name that matches the Orig Sector image
            tile_match = tile_box.best_tile_from_block(comparison_block, reuse = reuse)

            # Add Best match to Mosaic
            mosaic.add_tile(tile_match, box_crop)

            progress.update()

    except Exception as e:
        print(str(e) + '\nStopping')

    finally:
        mosaic.save()
