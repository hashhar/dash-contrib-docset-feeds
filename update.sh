#!/bin/bash

INBUILT_FEED='https://github.com/Kapeli/feeds'
CONTRIB_FEED='http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/index.json'

# Update the INBUILT_FEED from upstream
if [ -d "$(basename "$INBUILT_FEED")" ]; then
	cd "$(basename "$INBUILT_FEED")" && git checkout master && git pull && cd ..
else
	git clone "$INBUILT_FEED"
fi

# Update the CONTRIB_FEED from upstream
wget -qO - "$CONTRIB_FEED" | \
    sed -n -e '/^ \{4\}"/p' \
           -e '/^      "archive" :.*tgz"/p' \
           -e '/^      "version" :/p' | \
           awk -F '"' 'NR%3==1 { nm = $2 ; next }
                       NR%3==2 { ar = $4 ; ; next }
                       NR%3==0 { vr = $4 ; 
                                 of = nm ".xml"
                                 print "<entry>" > of
                                 print "<version>" vr "</version>" >> of
                                 print "<url>http://frankfurt.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "<url>http://london.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "<url>http://newyork.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "<url>http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "<url>http://singapore.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "<url>http://tokyo.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "<url>http://sydney.kapeli.com/feeds/zzz/user_contributed/build/" nm "/" ar "</url>" >> of
                                 print "</entry>" >> of
                                 ar = ""; vr = ""; nm = ""; next ;
                               }'

# Remove duplicate files and keep only the more recent versions
rm CouchDB.xml Julia.xml Phalcon.xml

# This is bound to have some errors
# Detect erroneous files

# Get all files that have malformed URLs
MALFORMED_FILES=$(grep -L "http://.*\.tgz" ./*.xml)

# Fix MALFORMED_FILES using some regex magic (need to make this better and not look stupid)
for file in $MALFORMED_FILES; do
	vim "$file" -u ./.vimrc  +'call FixFileUrl()' +wq
done

# Extract URLs from all files and creat a wget input file
WGET_URLS='/tmp/docsets_url'
grep "http://london\..*\.tgz" ./**/*.xml -o --no-filename > "$WGET_URLS"

# Download the archives and extract them to proper docsets directory
cd "${1='/tmp/'}" && \
	wget --continue -i "$WGET_URLS"
#&& \
#	tar xzf ./*.tgz -C "$HOME/.local/share/Zeal/Zeal/docsets/"
