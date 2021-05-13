#!/bin/bash
function banthan {
    echo "Đương Huy"
    echo "SN: 18031998"
    echo "Quê quán: Vĩnh phúc"
}

function congty {
    echo "ESVN"
    echo "Onedata"
    echo "Địa chỉ 82 dịch vọng hậu"
}

if [  -z $1 ]
then
echo "Chưa nhập thông tin:"
echo "usage: script congty or script banthan"
elif [ $1 = banthan ]
then
    banthan
elif [ $1 = congty ]
then
    congty
fi