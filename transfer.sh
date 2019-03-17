#!/bin/bash

transfer() {

        if [ $# -eq 0 ];
        then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md";
        return 1;
        fi

        tmpfile=$( mktemp -t transferXXX );

        pass=`pwgen -s 30 1 | tr -d '\n'`
        openssl enc -aes-256-cbc -salt -in $1 -out $1.enc -k $pass

        if tty -s; then basefile=$(basename "$1.enc" | sed -e 's/[^a-zA-Z0-9._-]/-/g');
                curl --progress-bar --upload-file "$1.enc" "https://transfer.sh/$basefile" >> $tmpfile;
                else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ;
        fi;

        echo; echo "--"
        echo -n "1) Download file "
        cat $tmpfile
        echo; echo "2) Decrypt file with:"
        echo "openssl enc -aes-256-cbc -d -in $1.enc -out $1 -k $pass"
        echo "--"

        rm -f $1.enc
        rm -f $tmpfile;
}

