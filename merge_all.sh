#!/bin/bash

versions=( "7.x-53" "7.x-52" "7.x-51" "7.x-50" "7.x-49" "7.x-48" "7.x-47" "7.x-46" "7.x-45" "7.x-43" "7.x-42" "7.x-41" "7.x-40" "7.x-38" "7.x-37" "7.x-36" "7.x-35" )
for i in "${versions[@]}"
do
    git checkout "$i" && git pull && git merge 7.x --no-edit && git push
	echo "Merged flx in $i"
done
git checkout 7.x

