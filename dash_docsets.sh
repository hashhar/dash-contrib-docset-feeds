#!/bin/bash
wget -qO - http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/index.json | \
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


