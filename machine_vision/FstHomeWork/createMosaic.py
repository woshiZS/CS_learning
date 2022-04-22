import photoMosaic
import os

if __name__ == "__main__":
    subject = "./target.jpg"
    result = "./result_large_scale.jpg"
    tile_paths = []
    for item in os.listdir("./"):
        if item.startswith('out'):
            tile_paths.append(item)

    color_mode = 'RGB'
    photoMosaic.create_mosaic(
        subject,
        result,
        2560/1440,
        100,
        color_mode = color_mode,
        tile_paths = tile_paths
    )