import sys
import re
from PIL import Image 
from numpy import (array, uint8)

dat_file_name = sys.argv[1]
dat_file = open(dat_file_name, 'r')


# pomin naglowek i odczytaj W i H
dat_file.readline()
width = int(re.sub('\n', '', re.sub('// WIDTH = ', '', dat_file.readline())))
height = int(re.sub('\n', '', re.sub('// HEIGHT = ', '', dat_file.readline())))

rgb =  array([ [ [ 0 for i in range( 4 ) ] for w in range( width ) ] for h in range( height ) ], dtype=uint8)

# czytaj znak po znaku
w = 0
h = 0
for pixel in dat_file:
    rgb[h,w] = [16*uint8(int(pixel[0], 16)), 16*uint8(int(pixel[1], 16)), 16*uint8(int(pixel[2], 16)), uint8(255)]
    if w == width - 1:
        h = h + 1
    w = (w + 1) % width

dat_file.close()

image = Image.fromarray(rgb)
image.show()
# open image
# image = Image.open(image_file)

# conver image to array
# the array shape is [width x height x 4]
# these 4 arrays are: red, green, blue and intensity
# array = asarray(image)
# check if the image is rgb or black&white
# is_rgb = len(array.shape)>2

# prepare output file
# output_file_name = re.sub('.[a-zA-Z0-9]*$', '.dat', image_file)
# output_file = open(output_file_name, 'w')
# output_file.write("// image rom content of: " + str(image_file) + "\n")
# output_file.write("// WIDTH = " + str(image.width) + " HEIGHT = " + str(image.height) + "\n")


# for each pixel convert color number to HEX and take only the 0'th element (4bits)
# for w in range(image.width):
#     for h in range(image.height):
#        # if is_rgb
#         pixel = '{:X}'.format(r[h,w])[0]+'{:X}'.format(g[h,w])[0]+'{:X}'.format(b[h,w])[0]
#        # else
#        #     pixel = 
#         output_file.write(pixel + "\n")
# 
# output_file.close()
# 
# # image2 = Image.fromarray(r)
# # image2.show()
# 
# # print(data)
