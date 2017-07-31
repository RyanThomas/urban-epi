
echo "Enter the directory of the shapefiles. For the directory where this bash file is located, type '.', followed by [ENTER]:"

read dir

echo "Enter the name for the output spatialite database, followed by [ENTER]:"

read name

file=”./final/$name.shp”

for i in $(ls $dir.shp)
do

      if [ -f “$file” ]
      then
           echo “creating final/$name.shp”
           ogr2ogr -f ‘Spatialite’ -update -append $file $i -nln merge
      else
           echo “merging……”
      ogr2ogr -f ‘Spatialite’ $file $i
fi
done

