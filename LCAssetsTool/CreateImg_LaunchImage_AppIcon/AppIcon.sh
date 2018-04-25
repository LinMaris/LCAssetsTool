#! /bin/sh
# 指定命令解释器



setContents(){
   
cat << EOF  > ./$1/Contents.json
{
  "images" : [
   {
      "size" : "20x20",
      "idiom" : "iphone",
      "scale" : "2x",
      "filename" : "icon_40x40.png"
   },
   {
      "size" : "20x20",
      "idiom" : "iphone",
      "scale" : "3x",
      "filename" : "icon_60x60.png"
   },
   {
      "size" : "29x29",
      "idiom" : "iphone",
      "scale" : "2x",
      "filename" : "icon_58x58.png"
   },
   {
      "size" : "29x29",
      "idiom" : "iphone",
      "scale" : "3x",
      "filename" : "icon_87x87.png"
   },
   {
      "size" : "40x40",
      "idiom" : "iphone",
      "scale" : "2x",
      "filename" : "icon_80x80.png"
   },
   {
      "size" : "40x40",
      "idiom" : "iphone",
      "scale" : "3x",
      "filename" : "icon_120x120.png"
   },
   {
      "size" : "60x60",
      "idiom" : "iphone",
      "scale" : "2x",
      "filename" : "icon_120x120.png"
   },
   {
      "size" : "60x60",
      "idiom" : "iphone",
      "scale" : "3x",
      "filename" : "icon_180x180.png"
   },
   {
      "size" : "1024x1024",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "filename" : "icon_1024x1024.png"
   }
 ],
  "info" : {
     "version" : 1,
     "author" : "xcode"
 }
}
EOF
}

iconWithSize() {
echo "请在AppIcon文件夹中设置名为icon.png的图片"

sips -Z $2 icon.png --out ./$1/icon_$2x$2.png
}

fileName=AppIcon

mkdir $fileName

setContents $fileName

for size in  40 58 60 80 87 120 180 1024
do
iconWithSize $fileName $size
done





