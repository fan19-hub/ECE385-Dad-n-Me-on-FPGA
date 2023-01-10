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
def process(filename):
    palette_hex =['0xDAB0D8','0xCB99CC','0xFFFFFF','0x000000','0x96D3F2','0x14A2EA','0xA10000','0x7C7B4F','0x65AA67','0x500A3E','0x5D5D5D','0x579252','0x64623B','0x6800F7','0x999999','0x323232','0x585F72','0x9CA200','0x686903','0xFFFF2A','0xFFA82A','0x9140FE','0xA863FC','0xFFCCFF','0xCBC9CD','0x9A7162','0xF8CA9F','0xF0966D','0xEC4266']
    mode=0
    if 'e_' in filename:
        new_w, new_h =(60,93)
        palette_hex =['0xFFCCFF','0x000000']
        mode=-1
    elif ('a_' in filename):
        new_w, new_h =(100,100)
        mode=1
        palette_hex =['0xA664FF','0x9140FF','0xFFFFFF','0x666666','0x000000']
    elif (filename=='1' or filename=='2'):
        
        new_w, new_h =(80,100)
        palette_hex =['0xA664FF','0x9140FF','0xFFFFFF','0x666666','0x000000']
        mode=1
    elif "blood" in filename:
        new_w, new_h =(68,86)
    elif "v"==filename:
        new_w, new_h =(291,344)
        palette_hex =['0xC71F22','0xC6C6C6','0x000000']
        mode=-1
    elif "g"==filename:
        new_w, new_h =(313,228)
        palette_hex =['0x7A7A7A','0xE0E0E0','0xB6B6B6','0x4D4D4D','0xFFFFFF','0x000000']
        mode=1
    else:
        print("oh no")
        new_w, new_h =(60,93)
   
    print(len(palette_hex))
    palette_rgb = [hex_to_rgb(color) for color in palette_hex]

    pixel_tree = KDTree(palette_rgb)
    im = Image.open("./sprite_originals/" + filename+ ".png") #Can be many different formats.
    im=im.resize((new_w, new_h),Image.ANTIALIAS)
    im = im.convert("RGBA")
    layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
    layer.paste(im, (0, 0))
    im = layer
    im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
    pix = im.load()
    pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
    pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
    pix_freqs_sorted.reverse()
    # print(pix)
    outImg = Image.new('RGB', im.size, color='white')
    outFile = open("./sprite_bytes/" + filename + '.txt', 'w')
    i = 0
    # outFile.write(bytes([im.size[0]]))
    # outFile.write(bytes([im.size[1]]))
    for y in range(im.size[1]):
        for x in range(im.size[0]):
            pixel = im.getpixel((x,y))
            # print(pixel)
            if(mode==-1):
                if(pixel==(0,0,0,0)):
                    outImg.putpixel((x,y), (0,0,0,0))
                    outFile.write(format(3, 'b').zfill(2)+'\n')
                # print(i)
                elif(pixel[3] < 200):
                    outImg.putpixel((x,y), palette_rgb[0])
                    outFile.write(format(3, 'b').zfill(2)+'\n')
                    # print(i)
                else:
                    index = pixel_tree.query(pixel[:3])[1]
                    outImg.putpixel((x,y), palette_rgb[index])
                    outFile.write(format(index, 'b').zfill(2)+'\n')
            if(mode==0):
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
            if(mode==1):
                if(pixel==(0,0,0,0)):
                    outImg.putpixel((x,y), (0,0,0,0))
                    outFile.write(format(7, 'b').zfill(3)+'\n')
                    # print(i)
                elif(pixel[3] < 200):
                    outImg.putpixel((x,y), palette_rgb[0])
                    outFile.write(format(7, 'b').zfill(3)+'\n')
                    # print(i)
                else:
                    index = pixel_tree.query(pixel[:3])[1]
                    outImg.putpixel((x,y), palette_rgb[index])
                    outFile.write(format(index, 'b').zfill(3)+'\n')
            i += 1
    outFile.close()
    outImg.save("./sprite_converted/" + filename + ".png" )

import os
f_list=os.listdir(os.path.abspath("sprite_originals"))
for f_pth in f_list:
    filename=f_pth.split(".")[0]
    if not 'bg' in filename:
        process(filename)

