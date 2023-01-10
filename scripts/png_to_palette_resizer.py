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
new_w, new_h = map(int, input("What's the new height x width? Like 28 28. ").split(' '))
palette_hex = ['0xDAB0D8','0xCB99CC','0xFFFFFF','0x000000','0x96D3F2','0x14A2EA','0xA10000','0x7C7B4F','0x65AA67','0x500A3E','0x5D5D5D','0x579252','0x64623B','0x6800F7','0x999999','0x323232','0x585F72','0x9CA200','0x686903','0xFFFF2A','0xFFA82A','0x9140FE','0xA863FC','0xFFCCFF','0xC9C9CC','0x9A7162','0x9A7162','0xF0966D','0xEC4266','0xEC4266']
palette_rgb = [hex_to_rgb(color) for color in palette_hex]

pixel_tree = KDTree(palette_rgb)
im = Image.open("./sprite_originals/" + filename+ ".png") #Can be many different formats.
im=im.resize((new_w, new_h),Image.ANTIALIAS)
im = im.convert("RGBA")
layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
layer.paste(im, (0, 0))
im = layer
#im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
pix = im.load()
pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
pix_freqs_sorted.reverse()
# print(pix)
outImg = Image.new('RGB', im.size, color='white')
outFile = open("./sprite_bytes/" + filename + '.txt', 'w')
i = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        pixel = im.getpixel((x,y))
        # print(pixel)
        if(pixel==(0,0,0,0)):
            outImg.putpixel((x,y), (0,0,0,0))
            outFile.write(("%x"%(255)).zfill(2)+'\n')
            # print(i)
        elif(pixel[3] < 200):
            outImg.putpixel((x,y), palette_rgb[0])
            outFile.write(("%x"%(0)).zfill(2)+'\n')
            # print(i)
        else:
            index = pixel_tree.query(pixel[:3])[1]
            outImg.putpixel((x,y), palette_rgb[index])
            outFile.write(("%x"%(index)).zfill(2)+'\n')
        i += 1
outFile.close()
outImg.save("./sprite_converted/" + filename + ".png" )
