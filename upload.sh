#!/usr/bin/bash

source_root=$(dirname "$@")
cat $@ | while read -r line; do           	
	todir=$(echo "$line" | struct 3 "/Volumes/webfolders.imeetcentral.com/caranddriver/digitalassets/" | sed "s:\&:and:g" | sed "s:\::-:g");      	
	todir_parent=$(dirname "$todir")
	todir_year=$(dirname "$todir_parent")
	todir_model=$(dirname "$todir_year")
	if [[ -z "$todir" ]]; then                 		
		( echo "Failed make: $source_root/$line " >> failed.log); 		
		continue;        	
	fi;      	

	if [[ !(-d "$todir_model") ]]; then
		( echo "Failed model: $source_root/$line" >> failed.log); 		
		continue;
	fi;

	echo "CP: "$source_root/$line" > $todir"; 
	(mkdir "$todir_year" >> cperr.log);
	(mkdir "$todir_parent" >> cperr.log);
	(cp -vr "$source_root/$line" "$todir" >> cperr.log);
done | tee complete.log

