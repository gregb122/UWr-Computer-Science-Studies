import matplotlib.image as mpimg
import matplotlib.pyplot as plt


COLOR_DIFF = 0.8


def get_image_contour(image_path: str):
    """
    Extracting contours from image problem. It's very simple implementation of it.
    :param image_path:  Image handled by matplotlib.image library
    """
    image = mpimg.imread(image_path)
    for i in range(1, len(image)):
        for j in range(1, len(image[1])):
            prev = image[i - 1, j - 1]
            current = image[i, j]
            diff_count = 0
            for rgb_channel in range(3):
                if abs(prev[rgb_channel] - current[rgb_channel]) > 0.8:
                    diff_count += 1
            # 1 - white, 0 - black
            if diff_count >= 1:
                image[i, j, 0] = 0
                image[i, j, 1] = 0
                image[i, j, 2] = 0
            else:
                image[i, j, 0] = 1
                image[i, j, 1] = 1
                image[i, j, 2] = 1

    plt.imshow(image)
    plt.show()


get_image_contour("fish.png")
