# mirror normal
ffplay -i /dev/video0 -vf "crop=iw/2:ih:0:0,split[left][tmp];[tmp]hflip[right];[left][right] hstack"


