import sys
import re
from PIL import Image 
from numpy import asarray

# read argument (image file name) 
image_file = sys.argv[1]

# open image
image = Image.open(image_file)

# conver image to array
# the array shape is [width x height x 4]
# these 4 arrays are: red, green, blue and intensity
array = asarray(image)
# check if the image is rgb or black&white
is_rgb = len(array.shape)>2

if is_rgb:
    r = array[:,:,0]
    g = array[:,:,1]
    b = array[:,:,2]
else:
    r = array
    g = array
    b = array

# prepare output file
output_file_name = re.sub('.[a-zA-Z0-9]*$', '.dat', image_file)
output_file = open(output_file_name, 'w')
output_file.write("// image rom content of: " + str(image_file) + "\n")
output_file.write("// WIDTH = " + str(image.width) + "\n")
output_file.write("// HEIGHT = " + str(image.height) + "\n")


# for each pixel convert color number to HEX and take only the 0'th element (4bits)
for h in range(image.height):
    for w in range(image.width):
       # if is_rgb
        pixel = '{:X}'.format(r[h,w])[0]+'{:X}'.format(g[h,w])[0]+'{:X}'.format(b[h,w])[0]
       # else
       #     pixel = 
        output_file.write(pixel + "\n")

output_file.close()

# image2 = Image.fromarray(r)
# image2.show()

# print(data)
