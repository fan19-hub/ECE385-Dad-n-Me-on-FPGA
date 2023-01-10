filename=input("Your input file name:")
filepath="sprite_bytes"+"/"+filename+".txt"
rgblist=[]
with open(filepath,"r")as f:
    rgblist=f.readlines()
with open("sprite_ram"+"/"+filename+'.ram',"wb")as f:
    count=1
    for i in rgblist:
        i=i.strip()
        f.write(bytes([int(i, base=16)]))#必须要加中括号！！！！！
        f.write(bytes([0]))
        count+=2
        # if(count%1024==0):
            # print(1)
        # print(i)
    #     a=int(i[0:2], base=16)
    #     f.write(bytes([a]))
    #     a=int(i[2:4], base=16)
    #     f.write(bytes([a]))
    #     a=int(i[4:6], base=16)
    #     f.write(bytes([a]))
# with open("sprite_ram"+"/"+filename+'.ram',"rb")as f:
#     a=f.read()
#     print(a[0])
print(count/1024/1024)
