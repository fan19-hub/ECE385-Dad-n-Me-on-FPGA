from PIL import Image
from collections import Counter
from scipy.spatial import KDTree
import numpy as np
def hex_to_rgb(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
def rgb_to_hex(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
filename = input("What's the image name? ")

im = Image.open("./sprite_originals/" + filename + ".png") #Can be many different formats.
im = im.convert("RGBA")

outImg = Image.new('RGB', im.size, color='white')
outFile = open("./sprite_bytes/" + filename + '.sv', 'w')
count=0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        pixel = im.getpixel((x,y))
        # print(pixel)
        outImg.putpixel((x,y), pixel)
        r, g, b, a = im.getpixel((x,y))
        r,g,b="%x"%r,"%x"%g,"%x"%b
        rgb=(2-len(r))*'0'+r+(2-len(g))*'0'+g+(2-len(b))*'0'+b
        outFile.write("20'h%x: out <= 23'h"%count+rgb+";\n")
        count+=1
outFile.close()

outImg.save("./sprite_converted1/" + filename+ ".png")
