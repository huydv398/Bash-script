#!/bin/bash 
read -p "Nhập địa chỉ người nhận: email " touser
read -p "Nhập chủ đề: " subject_email
read -p "Nhập nội dung: " content


{
    echo "Subject: $subject_email"
    echo $content
} | ssmtp $touser

curl -s -X POST "https://api.telegram.org/bot1946692490:AAEC83YVs-B5zJk0PSp8xDUiM2sE-JzsBJU/sendMessage" -d chat_id=750878537 -d text="Subject: $subject_email
$content"